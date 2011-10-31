//
//  GreenWalkViewController.h
//  GreenWalk
//
//  Created by John Gardner on 3/12/10.
//  Copyright 2010 Swinburne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Arrow.h"
#import "Keypad.h"
#import "Waypoint.h"

#define PLIST_PATH			@"Green Walk"
#define MOVIE_PATH			@"compiled"
#define EVENT_ARROW_TAPPED	@"GWArrowTapped"

@interface GreenWalkViewController : UIViewController {
	IBOutlet MPMoviePlayerViewController *viewport;
	Keypad *keypad;
	
	NSDictionary		*plist;			//	Contents loaded from "Green Walk" property list
	NSURL				*movieURL;		//	Path to Quicktime file
	NSMutableArray		*waypoints;		//	Array of Waypoints
	int					activeWP;		//	Current (Last) Waypoint
	int					targetWP;		//	Waypoint the user's currently heading towards
}


@property (retain) MPMoviePlayerViewController *viewport;
@property (retain) Keypad *keypad;

@property (nonatomic, retain)	NSDictionary		*plist;
@property (nonatomic, retain)	NSURL				*movieURL;
@property (nonatomic, retain)	NSMutableArray		*waypoints;
@property (nonatomic)			int					activeWP;
@property (nonatomic)			int					targetWP;


- (void) addAndStartPlayer;
- (void) playbackChange: (NSNotification *) notif;


- (void) timerPlay;
- (void) timerPause;
- (void) timerStop;
- (void) timerFire: (id) obj;


- (Waypoint *) getLastWP;
- (Waypoint *) getNextWP;


- (int) getFrame: (MPMoviePlayerController *) player;
- (NSString *) playStateToString: (MPMoviePlaybackState) val;

@end