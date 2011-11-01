//
//	GUILayer.h
//	GreenWalk
//
//	Created by John Gardner on 28/05/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GWCoreAdditions.h"
#import "Segment.h"
#import "SegmentLinkButton.h"


@interface GUILayer : UIView {
	NSArray *_links;
	BearingType bearing;
}

@property (nonatomic, retain) NSArray *links;
@property (nonatomic) BearingType bearing;


- (void) setupView;
- (void) realign;


@end