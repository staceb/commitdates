//
//  SignLinkButton.h
//  GreenWalk
//
//  Created by John Gardner on 2/10/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "GreenWalkAppDelegate.h"
#import "LinkButton.h"


@class GreenWalkAppDelegate;

@interface SignLinkButton : LinkButton {
	CGLayerRef imgIconDefault;
	CGLayerRef imgIconHighlight;
	UILabel *label;
}

@property (nonatomic) CGLayerRef imgIconDefault;
@property (nonatomic) CGLayerRef imgIconHighlight;
@property (nonatomic, retain) UILabel *label;



/*	Draws a Sign Button's background frame */
+ (CGLayerRef) drawFrame: (CGContextRef) c
					rect: (CGRect) rect
				  colour: (unsigned) colour;


/*	Draws a Sign Button's icon */
+ (CGLayerRef) drawIcon: (CGContextRef) c
				   rect: (CGRect) rect
				 colour: (unsigned) colour;


@end