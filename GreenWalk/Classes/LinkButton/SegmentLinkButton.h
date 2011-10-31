//
//  SegmentLinkButton.h
//  GreenWalk
//
//  Created by John Gardner on 30/09/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "GreenWalkAppDelegate.h"
#import "LinkButton.h"


@class GreenWalkAppDelegate;

@interface SegmentLinkButton : LinkButton {
	CGLayerRef imgArrowDefault;
	CGLayerRef imgArrowHighlight;
}

@property (nonatomic) CGLayerRef imgArrowDefault;
@property (nonatomic) CGLayerRef imgArrowHighlight;


/*	Draws a Segment Button's background frame */
+ (CGLayerRef) drawFrame: (CGContextRef) c
					rect: (CGRect) rect
				  colour: (unsigned) colour;


/*	Draws the Arrow graphic to be superimposed over the frame */
+ (CGLayerRef) drawArrow: (CGContextRef) c
					rect: (CGRect) rect
				  colour: (unsigned) colour;

@end