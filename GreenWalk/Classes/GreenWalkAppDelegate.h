//
//  GreenWalkAppDelegate.h
//  GreenWalk
//
//  Created by John Gardner on 27/07/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "SegmentLinkButton.h"
#import "SignLinkButton.h"


@class RootViewController;

@interface GreenWalkAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	RootViewController *rootView;
	
	CGLayerRef segbtnFrame;
	CGLayerRef segbtnArrowDefault;
	CGLayerRef segbtnArrowHighlight;
	
	CGLayerRef sgnbtnFrame;
	CGLayerRef sgnbtnIconDefault;
	CGLayerRef sgnbtnIconHighlight;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootView;

@property (nonatomic) CGLayerRef segbtnFrame;
@property (nonatomic) CGLayerRef segbtnArrowDefault;
@property (nonatomic) CGLayerRef segbtnArrowHighlight;

@property (nonatomic) CGLayerRef sgnbtnFrame;
@property (nonatomic) CGLayerRef sgnbtnIconDefault;
@property (nonatomic) CGLayerRef sgnbtnIconHighlight;

- (void) cacheGraphics;

@end