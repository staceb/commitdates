//
//  GreenWalkViewController.m
//  GreenWalk
//
//  Created by John Gardner on 3/12/10.
//  Copyright 2010 Swinburne. All rights reserved.
//

#import "GreenWalkViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation GreenWalkViewController


@synthesize viewport;
@synthesize keypad;

@synthesize plist;
@synthesize movieURL;
@synthesize waypoints;
@synthesize activeWP;
@synthesize targetWP;



//	Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad{
	[super viewDidLoad];

	NSBundle *bundle	=	[NSBundle mainBundle];


	//	Load our .plist and declare our Waypoints
	NSString *path				=	[bundle pathForResource:PLIST_PATH ofType:@"plist"];
	self.plist					=	[NSDictionary dictionaryWithContentsOfFile:path];

	NSArray *array				=	[self.plist valueForKey:WP_WAYPOINTS_KEY];
	int count					=	[array count];
	self.waypoints				=	[NSMutableArray arrayWithCapacity: count];

	int i;
	NSDictionary *entry;
	for(i = 0; i < count; i++){
		entry			=	[array objectAtIndex:i];
		Waypoint *wp	=	[[Waypoint alloc] init];
		wp.name			=	[entry valueForKey:WP_NAME_KEY];
		wp.frame		=	(int)	[entry valueForKey:WP_FRAME_KEY];
		wp.time			=	(float) [[entry valueForKey:WP_TIME_KEY] floatValue];
		[waypoints addObject:wp];
	}
	[entry release];

	self.activeWP		=	0;
	self.targetWP		=	1;
	
	
	//	Add a Keypad for our Arrows
	CGRect rect				=	self.view.bounds;
	self.keypad				=	[[Keypad alloc] initWithFrame:rect];
	self.keypad.showArrows	=	NO;
	[self.view addSubview:self.keypad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arrowTapped:) name:EVENT_ARROW_TAPPED object:nil];

	
	
	//	Load our Movie
	path				=	[bundle pathForResource:MOVIE_PATH ofType:@"mov"];
	self.movieURL		=	[[NSURL fileURLWithPath:path] retain];


	//	Start the show
	[self addAndStartPlayer];

	
	[self.view bringSubviewToFront:self.keypad];
	[bundle release];
}




//	Adds the moviePlayer to the view controller and begins the show
- (void) addAndStartPlayer{
	MPMoviePlayerViewController *theMovie	=	[[MPMoviePlayerViewController alloc] initWithContentURL:self.movieURL];
	
	if(theMovie){
		self.viewport	=	theMovie;
		[theMovie release];


		//	Listener to respond to playback changes
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector: @selector(playbackChange:)
		 name: MPMoviePlayerPlaybackStateDidChangeNotification
		 object: [self.viewport moviePlayer]];



		[self.view addSubview:self.viewport.view];
		self.viewport.moviePlayer.scalingMode		=	MPMovieScalingModeNone;
		self.viewport.moviePlayer.controlStyle		=	MPMovieControlStyleNone;
		self.viewport.view.userInteractionEnabled	=	NO;
		[self presentMoviePlayerViewControllerAnimated: self.viewport];
		[self.viewport.moviePlayer play];
	}
}





//	Response called when detecting a change in main video's playback
- (void) playbackChange: (NSNotification *) notif{
	id player			=	[notif object];
	NSInteger state		=	[player playbackState];


	switch(state){
		case MPMoviePlaybackStateStopped:{
			[self timerStop];
			break;
		}

		case MPMoviePlaybackStatePaused:{
			[self timerPause];
			break;
		}
		
		case MPMoviePlaybackStatePlaying:{
			[self timerPlay];
			break;
		}
			
		default: break;
	}
}



/*============================================================
	Timer Functions
============================================================*/

- (void) timerPause{
/*
	MPMoviePlayerController	*player	=	[self.viewport moviePlayer];
	NSTimeInterval time				=	[player currentPlaybackTime];
	NSNumber *frame					=	[NSNumber numberWithDouble:time];
	NSLog(@"Paused @ %@", [frame stringValue]);
*/
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.keypad.showArrows		=	YES;
}


- (void) timerPlay{
	Waypoint *wp						=	[self getNextWP];
	MPMoviePlayerController	*player		=	[self.viewport moviePlayer];
	NSTimeInterval now					=	[player currentPlaybackTime];
	NSTimeInterval time					=	[wp timeAsDouble] - now;

	[self performSelector: @selector(timerFire:) withObject:wp afterDelay:time];
	self.keypad.showArrows	=	NO;
}


- (void) timerStop{
	
}


- (void) timerFire: (id) obj{
	Waypoint *wp	=	obj;

	[self.viewport.moviePlayer pause];
	
	//	Force player to jump to the expected frame (in case timer fires too early or too soon)
	double time	=	[wp timeAsDouble];
	self.viewport.moviePlayer.currentPlaybackTime	=	time;

	
	NSLog(@"Hello");
}



/*============================================================
	Waypoint Functions
============================================================*/

//	Returns the current (last) Waypoint reached by the user
- (Waypoint *) getLastWP{
	return [self.waypoints objectAtIndex:self.activeWP];
}

//	Returns the next Waypoint the user's travelling to
- (Waypoint *) getNextWP{
	return [self.waypoints objectAtIndex:self.targetWP];
}





//	Allow landscape orientation
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation{
	return YES;
}


//	Called when we're about to rotate the interface
- (void) willRotateToInterfaceOrientation:	(UIInterfaceOrientation) toInterfaceOrientation
								 duration:	(NSTimeInterval) duration{
	self.keypad.showArrows	=	NO;
}


/*	Called after the above method if the interface rotation is about to be animated
- (void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
										  duration: (NSTimeInterval)duration{
	
}*/


//	Called once the interface rotation has finished
- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation{
	
	Waypoint *next	=	[self getNextWP];
	
	//	Currently at a waypoint
	if(next == nil){
		[self.keypad alignArrows];
		self.keypad.showArrows	=	YES;
	}


	//CGRect rect	=	self.view.bounds;
	//NSLog(@"Rotated View: %f x %f", rect.size.width, rect.size.height);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void) dealloc{
	[super dealloc];
}




//	Returns the current frame of the movie
- (int) getFrame: (MPMoviePlayerController *) player{
	NSTimeInterval time		=	[player currentPlaybackTime];
	NSNumber *frame			=	[NSNumber numberWithDouble:time];
	float something			=	roundf([frame floatValue] * 25.0f);
	return((int) something);
}



//	Returns a String representation of a MPMoviePlaybackState constant.
- (NSString *) playStateToString: (MPMoviePlaybackState) state{
	switch(state){
		case MPMoviePlaybackStateStopped:			{	return @"Stopped";			break;	}
		case MPMoviePlaybackStatePlaying:			{	return @"Playing";			break;	}
		case MPMoviePlaybackStatePaused:			{	return @"Paused";			break;	}
		case MPMoviePlaybackStateInterrupted:		{	return @"Interrupted";		break;	}
		case MPMoviePlaybackStateSeekingForward:	{	return @"Seeking Forward";	break;	}
		case MPMoviePlaybackStateSeekingBackward:	{	return @"Seeking Backward";	break;	}
		default: break;
	}
	return @"";
}


//	Returns a String representation of a UIInterfaceOrientation constant
- (NSString *) orientationToString: (UIInterfaceOrientation) orientation{
	switch(orientation){
		case 1:		return @"Portrait";					break;
		case 2:		return @"Portrait, Upside-down";	break;
		case 3:		return @"Landscape, Left";			break;
		case 4:		return @"Landscape, Right";			break;
	}
	return nil;
}


@end