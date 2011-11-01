//
//	RootViewController.h
//	GreenWalk
//
//	Created by John Gardner on 27/07/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MoviePlayer.h"
#import "MovieView.h"
#import "GUILayer.h"
#import "Sign.h"
#import "Segment.h"


@class GUILayer, MovieView, MoviePlayer, Segment, Sign;


@interface RootViewController : UIViewController <UIAlertViewDelegate> {
	MovieView *movieView;
	MoviePlayer *moviePlayer;
	Sign *sign;
	GUILayer *gui;
	UIImageView *stillView;
	
	NSMutableDictionary *segments;
	Segment *_segment;
	UIImage *_still;
	
	UIAlertView *welcomeDialogue;
	UIAlertView *endDialogue;
	NSURL *visitSiteURL;
	NSUInteger numStops;
	NSUInteger stopsVisited;
	BOOL welcomed;
	BOOL ended;
	
	BearingType _bearing;
}


//	View/hierarchy related properties
@property (nonatomic, retain) IBOutlet MovieView *movieView;
@property (nonatomic, retain) IBOutlet MoviePlayer *moviePlayer;
@property (nonatomic, retain) IBOutlet Sign *sign;
@property (nonatomic, retain) IBOutlet GUILayer *gui;
@property (nonatomic, retain) IBOutlet UIImageView *stillView;


//	Navigation Properties
@property (nonatomic, retain) NSMutableDictionary *segments;
@property (nonatomic, retain) Segment *segment;
@property (nonatomic, retain) UIImage *still;


//	Dialogue-related properties
@property (nonatomic, retain) UIAlertView *welcomeDialogue;
@property (nonatomic, retain) UIAlertView *endDialogue;
@property (nonatomic, retain) NSURL *visitSiteURL;
@property (nonatomic) NSUInteger numStops;
@property (nonatomic) NSUInteger stopsVisited; 
@property (nonatomic) BOOL welcomed;
@property (nonatomic) BOOL ended;


//	Other
@property (nonatomic, readonly) BOOL moving;
@property (nonatomic) BearingType bearing;



- (BearingType) orientationType: (UIInterfaceOrientation) orient;
- (void) setBearing: (BearingType) input;

- (void) applySegment: (Segment *) input;
- (void) hideStill: (id) sender;

- (void) addObservers;

- (void) onButtonPressed: (NSNotification *) notify;
- (void) onPlaybackFinished: (NSNotification *) notify;
- (void) onSignViewOpened: (NSNotification *) notify;

@end