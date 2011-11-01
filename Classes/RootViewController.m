//
//  RootViewController.m
//  GreenWalk
//
//  Created by John Gardner on 27/07/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "RootViewController.h"


static NSBundle *bundle		=	nil;

@implementation RootViewController

@synthesize movieView, moviePlayer, sign, gui, stillView;
@synthesize welcomeDialogue, endDialogue, visitSiteURL, numStops, stopsVisited, welcomed, ended;
@synthesize segments, moving,
	bearing		=	_bearing,
	segment		=	_segment,
	still		=	_still;



- (BearingType) orientationType: (UIInterfaceOrientation) orient{
	return ((orient == UIInterfaceOrientationPortrait || orient == UIInterfaceOrientationPortraitUpsideDown) ? BearingPortrait : BearingLandscape);
}


- (void) setSegment: (Segment *) input{
	if(input != _segment){
		
		
		//	Unsetting the property
		if(input == nil){
			_segment	=	nil;
			[self.moviePlayer stop];
		}
		
		
		//	Setting a valid Segment value
		else{
			_segment	=		input;
			if(input.still)		self.still	=	input.still;
			if(input.clip)		[self.moviePlayer setContentURL:input.clip];

			
			//	Allow the Segment's delay property to intercept applySegment:
			if(input.delay){
				self.stillView.hidden	=	NO;
				
				//	Align the AOIs to the first point in the keyframe
				NSValue *posPortrait				=	[input.portrait.values objectAtIndex:0];
				NSValue *posLandscape				=	[input.landscape.values objectAtIndex:0];
				self.movieView.aoiX.layer.position	=	[posPortrait CGPointValue];
				self.movieView.aoiY.layer.position	=	[posLandscape CGPointValue];
				
				[self performSelector:@selector(applySegment:) withObject:input afterDelay:input.delay];
			}

			else
				[self applySegment:input];
		}
	}
}



//	Method that triggers playback or reveals GUI once a segment is reached
- (void) applySegment: (Segment *) input{
	self.stillView.hidden	=	NO;
	
	if(input.transition){
		self.gui.links				=	nil;
		self.moviePlayer.playing	=	YES;
		[self performSelector:@selector(hideStill:) withObject:self afterDelay:0.2];
		[self.movieView setAnimations:input];
		[self.moviePlayer play];
	}

	
	else{
		self.moviePlayer.playing	=	NO;
		
		//	End of tour!
		if(!self.ended && self.stopsVisited >= self.numStops && [_segment.ID isEqualToString:@"WS"]){
			[self.endDialogue show];
			self.ended		=	YES;
		}
		
		//	Mark as "visited" if we haven't been here before.
		else if(!input.visited){
			input.visited	=	YES;
			self.stopsVisited++;
		}

		
		//	Not a transition, but has a target Segment declared anyway
		if(input.targetID){
			self.gui.links	=	nil;
			self.segment	=	[self.segments objectForKey:input.targetID];
		}

		
		//	Regular Segment: Reveal the GUILayer and set the Links
		else{
			if(!welcomed){
				[self.welcomeDialogue show];
				self.welcomed	=	YES;
			}

			else
				self.gui.links	=	_segment.links;
		}
	}
}


//	Callback to conceal still image after the next clip's started playing
- (void) hideStill: (id) sender{
	self.stillView.hidden	=	YES;
}


- (void) setStill: (UIImage *) input{
	_still	=	input;
	self.stillView.image	=	input;
}



//	Returns TRUE if the user's currently heading towards a destination
- (BOOL) moving{
	return ((bool) self.segment && self.segment.transition);
}


//	Get or set the current bearing used to handle the layout of the subviews
- (void) setBearing: (BearingType) input{
	_bearing				=	input;
	self.movieView.bearing	=	_bearing;
	self.gui.bearing		=	_bearing;
	self.sign.bearing		=	_bearing;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad{
	[super viewDidLoad];

	UIApplication *app		=	[UIApplication sharedApplication];
	app.statusBarHidden		=	YES;
	
	bundle					=	[NSBundle mainBundle];
	NSString *filePath		=	[bundle pathForResource:@"MovieData.plist" ofType:nil];
	NSDictionary *dict		=	[NSDictionary dictionaryWithContentsOfFile:filePath];

	
	
	//	Load the Segments into memory
	NSDictionary *kSegs		=	[dict valueForKey:@"segments"];
	self.segments			=	[NSMutableDictionary dictionaryWithCapacity:[kSegs count]];
	for(NSString *key in kSegs)
		[self.segments setObject:[Segment createFromDictionary:[kSegs objectForKey:key] usingID:key] forKey:key];

	
	//	Configure dialogues
	NSDictionary *kDialogues		=	[dict valueForKey:@"dialogues"];
	self.welcomeDialogue			=	[UIAlertView createFromDictionary:[kDialogues valueForKey:@"welcome"]];
	self.welcomeDialogue.delegate	=	self;
	
	NSDictionary *kEnd				=	[kDialogues valueForKey:@"end"];
	self.visitSiteURL				=	[NSURL URLWithString:[kEnd valueForKey:@"url"]];
	self.endDialogue				=	[UIAlertView createFromDictionary:kEnd];
	self.endDialogue.delegate		=	self;

	for(id obj in self.segments)
		if(!((Segment *) [self.segments objectForKey:obj]).transition)
			self.numStops++;
	
	
	
	//	Handle the other views
	UIScreen *screen		=	[UIScreen mainScreen];
	[self.view setFrame:screen.applicationFrame];
	
	
	self.gui.hidden							=	YES;
	self.sign.hidden						=	YES;
	self.bearing							=	[self orientationType:self.interfaceOrientation];
	self.movieView.layer.zPosition			=	-2000;
	self.sign.background.layer.zPosition	=	-2000;
	
	
	
	//	Instantiate the MoviePlayer
	self.moviePlayer	=	[[MoviePlayer alloc] init];
	if(self.moviePlayer){
		[self.moviePlayer.view setFrame:self.view.bounds];
		[self.moviePlayer.view addSubview:self.stillView];
		[self.stillView setFrame:self.moviePlayer.view.bounds];
		self.moviePlayer.shouldAutoplay	=	NO;
		[self.movieView setupView];
		
		//	Connect the movie player's view to the UIViewController before sending it to the movieView
		[self.view addSubview:self.moviePlayer.view];
		[self.movieView addTarget:self.moviePlayer.view withOrientation:self.bearing];
	}

	
	[self addObservers];
	self.segment	=	[self.segments objectForKey:@"start"];
}



//	Register the necessary observers with the default notification centre
- (void) addObservers{
	NSNotificationCenter *centre	=	[NSNotificationCenter defaultCenter];
	[centre addObserver:self selector:@selector(onButtonPressed:) name:BUTTON_PRESSED object:nil];
	[centre addObserver:self selector:@selector(onPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	[centre addObserver:self selector:@selector(onSignViewOpened:) name:SIGNVIEW_OPENED object:nil];
}



- (void) onButtonPressed: (NSNotification *) notify{
	LinkButton *obj		=	[notify object];
	Link *link			=	obj.link;

	switch(link.type){
		
		case LinkTypeSegment:{
			Segment *next					=	[self.segments objectForKey:link.targetID];
			if(next != nil)	self.segment	=	next;
			break;
		}
		
		case LinkTypeSign:{
			[self.sign open:link];
			self.gui.hidden			=	YES;
			break;
		}
	}
}


- (void) onPlaybackFinished: (NSNotification *) notify{
	NSLog(@"onPlaybackFinished");
	if(!self.moviePlayer.changingURL){
		[self.gui realign];
		self.segment	=	[self.segments objectForKey:self.segment.targetID];
		self.gui.hidden	=	NO;
	}
}


//	Called when the Sign's transition has finished playing.
- (void) onSignViewOpened: (NSNotification *) notify{
	
	if(self.sign.state == SignStateOpening){
		UIView *target	=	self.sign.target;
		[self.view addSubview:target];
		[target setFrame:self.view.bounds];
		self.sign.state	=	SignStateOpened;
	}
	
	else if(self.sign.state == SignStateClosing){
		[self.sign reset];
		self.gui.hidden		=	NO;
	}
}


//	Called when pressing a button on an AlertView
- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex{
	if(alertView == self.welcomeDialogue)
		self.gui.links	=	_segment.links;
	
	else if(alertView == self.endDialogue && buttonIndex == 1)
		[[UIApplication sharedApplication] openURL:self.visitSiteURL];
}



- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
								 duration: (NSTimeInterval)	duration{
	NSLog(@"Rotating to %@", [self orientationType:toInterfaceOrientation] == BearingLandscape ? @"Landscape" : @"Portrait");
	
	CGRect bounds	=	self.view.bounds;
	CGRect newRect	=	CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
	[self.moviePlayer.view setFrame:newRect];
	
	self.bearing			=	[self orientationType:toInterfaceOrientation];
	self.gui.hidden			=	YES;
	[self.stillView setFrame:newRect];
}


//	Sent to the view controller after the user interface rotates.
- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation{
	[self.moviePlayer.view setFrame:self.view.bounds];
	
	if(!self.moving){
		if(self.sign.state == SignStateClosed)
			self.gui.hidden	=	NO;
		[self.gui realign];
	}
}



//	Allow landscape orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation{
	return YES;
}



//	Releases the view if it doesn't have a superview.
- (void) didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}


// Release any retained subviews of the main view.
- (void) viewDidUnload{
	// e.g. self.myOutlet = nil;
}


- (void) dealloc{
	[movieView release];
	[moviePlayer release];
	[sign release];
	[gui release];
	[stillView release];
	
	[segments release];
	[_segment release];
	[_still release];
	
	[welcomeDialogue release];
	[endDialogue release];
	[visitSiteURL release];
	
	[super dealloc];
}

@end