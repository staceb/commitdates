//
//	GreenWalkAppDelegate.m
//	GreenWalk
//
//	Created by John Gardner on 27/07/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import "GreenWalkAppDelegate.h"

@implementation GreenWalkAppDelegate

@synthesize window;
@synthesize rootView;
@synthesize segbtnFrame, segbtnArrowDefault, segbtnArrowHighlight;
@synthesize sgnbtnFrame, sgnbtnIconDefault, sgnbtnIconHighlight;



#pragma mark -
#pragma mark Application lifecycle


//	Override point for customisation after application launch.
- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions{

	[self cacheGraphics];
	
	// Add the view controller's view to the window and display.
	[self.window addSubview:rootView.view];
	[self.window makeKeyAndVisible];

	return YES;
}


//	Cache CGLayerRefs for GUI use
- (void) cacheGraphics{
	
	//	SegmentLinkButtons (Directional Arrows)
	CGContextRef context		=	UIGraphicsGetCurrentContext();
	CGRect arrowRect			=	(true) ? CGRectMake(0, 0, SEGBTN_FRAME_WIDTH, SEGBTN_FRAME_HEIGHT) : CGRectMake(0, 0, SEGBTN_ARROW_WIDTH, SEGBTN_ARROW_HEIGHT);
	self.segbtnFrame			=	[SegmentLinkButton drawFrame:context rect:CGRectMake(0, 0, SEGBTN_FRAME_WIDTH, SEGBTN_FRAME_HEIGHT) colour:SEGBTN_FRAME_COLOUR];
	self.segbtnArrowDefault		=	[SegmentLinkButton drawArrow:context rect:arrowRect colour:SEGBTN_ARROW_COLOUR_DEFAULT];
	self.segbtnArrowHighlight	=	[SegmentLinkButton drawArrow:context rect:arrowRect colour:SEGBTN_ARROW_COLOUR_HIGHLIGHT];


	//	SignLinkButtons (Floating Text Labels)
	CGRect iconRect				=	CGRectMake(SGNBTN_ICON_X, SGNBTN_ICON_Y, SGNBTN_ICON_WIDTH, SGNBTN_ICON_HEIGHT);
	self.sgnbtnFrame			=	[SignLinkButton drawFrame:context rect:CGRectMake(0, 0, SGNBTN_FRAME_WIDTH, SGNBTN_FRAME_HEIGHT) colour:0x000000B3];
	self.sgnbtnIconDefault		=	[SignLinkButton drawIcon:context rect:iconRect colour:SGNBTN_TEXT_COLOUR_DEFAULT];
	self.sgnbtnIconHighlight	=	[SignLinkButton drawIcon:context rect:iconRect colour:SGNBTN_TEXT_COLOUR_HIGHLIGHT];
}



//	Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an
//	incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state. Use this
//	method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
- (void) applicationWillResignActive: (UIApplication *) application{
	if(self.rootView.moviePlayer.playing){
		[self.rootView.moviePlayer pause];
	}
}


//	Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore
//	your application to its current state in case it is terminated later. If your application supports background execution, called instead of
//	applicationWillTerminate: when the user quits.
- (void) applicationDidEnterBackground: (UIApplication *) application{
	self.rootView.gui.hidden		=	YES;
	self.rootView.movieView.hidden	=	YES;
}



//	Called as part of transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
- (void) applicationWillEnterForeground: (UIApplication *) application{
	self.rootView.gui.hidden		=	NO;
	self.rootView.movieView.hidden	=	NO;
	[self.rootView didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
}


//	Restart any tasks that were paused (or not yet started) while the application was inactive.
//	If the application was previously in the background, optionally refresh the user interface.
- (void) applicationDidBecomeActive: (UIApplication *) application{
	if(self.rootView.moviePlayer.playing){
		[self.rootView.moviePlayer play];
	}
}


//	Called when the application is about to terminate. See also applicationDidEnterBackground:
- (void) applicationWillTerminate: (UIApplication *) application{
	
}


#pragma mark -
#pragma mark Memory management


//	Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
- (void) applicationDidReceiveMemoryWarning: (UIApplication *) application{

}


- (void) dealloc{
	[rootView release];
	[window release];
	[super dealloc];
}


@end