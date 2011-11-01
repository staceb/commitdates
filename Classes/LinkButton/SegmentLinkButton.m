//
//  SegmentLinkButton.m
//  GreenWalk
//
//  Created by John Gardner on 30/09/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "SegmentLinkButton.h"


@implementation SegmentLinkButton

@synthesize imgArrowDefault, imgArrowHighlight;



- (void) setupView{
	[super setupView];

	GreenWalkAppDelegate *delegate	=	(GreenWalkAppDelegate *) [[UIApplication sharedApplication] delegate];
	self.imgFrame				=	delegate.segbtnFrame;
	self.imgArrowDefault		=	delegate.segbtnArrowDefault;
	self.imgArrowHighlight		=	delegate.segbtnArrowHighlight;
}



- (void) drawRect: (CGRect) rect{
	[super drawRect:rect];
	CGContextRef context	=	UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, rect.size.width / 2, rect.size.height / 2);
	CGContextRotateCTM(context, self.bearing == BearingLandscape ? self.landscape.direction : self.portrait.direction);
	CGContextTranslateCTM(context, -(rect.size.width / 2), -(rect.size.height / 2));
	CGContextDrawLayerAtPoint(context, CGPointZero, (self.highlighted ? self.imgArrowHighlight : self.imgArrowDefault));
}



/*	Draws a Segment Button's background frame */
+ (CGLayerRef) drawFrame: (CGContextRef) c
					rect: (CGRect) rect
				  colour: (unsigned) colour{

	CGLayerRef output		=	CGLayerCreateWithContext(c, rect.size, NULL);
	CGContextRef context	=	CGLayerGetContext(output);
	
	
	//	Enable antialiasing
	CGContextSetAllowsAntialiasing(context, YES);
	
	
	//	Black Background
	CGContextSetRGBFillColor(context,
		(float) (colour >> 24)			/ 255,
		(float) (colour >> 16	& 0xFF)	/ 255,
		(float) (colour >> 8	& 0xFF)	/ 255,
		(float) (colour			& 0xFF)	/ 255
	);
	UIBezierPath *path	=	[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(SEGBTN_FRAME_CORNER_RADIUS, SEGBTN_FRAME_CORNER_RADIUS)];
	CGContextAddPath(context, [path CGPath]);
	CGContextFillPath(context);	
	
	return output;
}


/*	Draws the Arrow graphic to be superimposed over the frame */
+ (CGLayerRef) drawArrow: (CGContextRef) c
					rect: (CGRect) rect
				  colour: (unsigned) colour{

	CGLayerRef output		=	CGLayerCreateWithContext(c, rect.size, NULL);
	CGContextRef context	=	CGLayerGetContext(output);
	
	//	Arrow
	UIBezierPath *icon	=	[UIBezierPath bezierPath];
	CGRect iconBounds	=	CGRectMake(0, 0, SEGBTN_FRAME_WIDTH, SEGBTN_FRAME_HEIGHT);
	
	CGFloat xScale		=	rect.size.width / iconBounds.size.width;
	CGFloat yScale		=	rect.size.height / iconBounds.size.height;
	
	
	CGPoint vertices[]	=	{{17,4.5}, {7,14.5}, {14,14.5}, {14,23.5}, {20,23.5}, {20,14.5}, {27,14.5}};
	[icon moveToPoint:CGPointMake(vertices[0].x * xScale, vertices[0].y * yScale)];
	for(unsigned i = 1; i < 7; ++i)
		[icon addLineToPoint:CGPointMake(vertices[i].x * xScale, vertices[i].y * yScale)];
	
	
	CGContextSetRGBFillColor(context,
		(float) (colour >> 24)			/ 255,
		(float) (colour >> 16	& 0xFF)	/ 255,
		(float) (colour >> 8	& 0xFF)	/ 255,
		(float) (colour			& 0xFF)	/ 255
	);
	
	CGContextAddPath(context, [icon CGPath]);
	CGContextFillPath(context);
	
	return output;
}



- (void) dealloc{
	CGLayerRelease(imgArrowDefault);
	CGLayerRelease(imgArrowHighlight);
	
	[super dealloc];
}


@end