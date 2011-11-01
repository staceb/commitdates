//
//  LinkButton.h
//  GreenWalk
//
//  Created by John Gardner on 19/08/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@class Link;

@interface LinkButton : UIControl {
	CGLayerRef imgFrame;
	LinkLayout portrait;
	LinkLayout landscape;
	BearingType bearing;
	
	Link *link;
}

@property (nonatomic) CGLayerRef imgFrame;
@property (nonatomic) LinkLayout portrait;
@property (nonatomic) LinkLayout landscape;
@property (nonatomic) BearingType bearing;

@property (nonatomic, retain) Link *link;


- (void) setupView;

- (void) onTouchDown: (id) sender;
- (void) onTouchRelease: (id) sender;


@end