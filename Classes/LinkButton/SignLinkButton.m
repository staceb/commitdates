//
//  SignLinkButton.m
//  GreenWalk
//
//  Created by John Gardner on 2/10/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "SignLinkButton.h"


@implementation SignLinkButton

@synthesize imgIconDefault, imgIconHighlight, label;



- (void) setupView{
	[super setupView];
	
	GreenWalkAppDelegate *delegate	=	(GreenWalkAppDelegate *) [[UIApplication sharedApplication] delegate];
	self.imgFrame					=	delegate.sgnbtnFrame;
	self.imgIconDefault				=	delegate.sgnbtnIconDefault;
	self.imgIconHighlight			=	delegate.sgnbtnIconHighlight;
	
	UILabel *l			=	[[UILabel alloc] initWithFrame:self.frame];
	[self addSubview:l];
	[l setFrame:CGRectMake(SGNBTN_TEXT_X, SGNBTN_TEXT_Y, self.frame.size.width, self.frame.size.height)];

	
	l.text				=	SGNBTN_TEXT_STRING;
	l.backgroundColor	=	[UIColor clearColor];
	l.opaque			=	YES;
	l.contentMode		=	UIViewContentModeTopLeft;
	l.font				=	[UIFont fontWithName:@"Helvetica-Bold" size:15];
	l.textColor			=	[UIColor colorWithRed:
					(float) (SGNBTN_TEXT_COLOUR_DEFAULT >> 24) / 255
			green:	(float) (SGNBTN_TEXT_COLOUR_DEFAULT >> 16	& 0xFF)	/ 255
			 blue:	(float) (SGNBTN_TEXT_COLOUR_DEFAULT >> 8	& 0xFF)	/ 255
			alpha:	(float) (SGNBTN_TEXT_COLOUR_DEFAULT			& 0xFF)	/ 255
	];
	
	l.highlightedTextColor	=	[UIColor colorWithRed:
					(float) (SGNBTN_TEXT_COLOUR_HIGHLIGHT >> 24) / 255
			green:	(float) (SGNBTN_TEXT_COLOUR_HIGHLIGHT >> 16	& 0xFF)	/ 255
			 blue:	(float) (SGNBTN_TEXT_COLOUR_HIGHLIGHT >> 8	& 0xFF)	/ 255
			alpha:	(float) (SGNBTN_TEXT_COLOUR_HIGHLIGHT		& 0xFF)	/ 255
	];
	self.label	=	l;
}


- (void) drawRect: (CGRect) rect{
	[super drawRect:rect];
	
	CGContextRef context	=	UIGraphicsGetCurrentContext();
	CGPoint point			=	{SGNBTN_ICON_X, SGNBTN_ICON_Y};
	CGContextDrawLayerAtPoint(context, point, (self.highlighted ? self.imgIconHighlight : self.imgIconDefault));
}

- (void) onTouchDown: (id) sender{
	NSLog(@"Touch Down");
	self.label.highlighted	=	YES;
	[super onTouchDown:sender];
}

- (void) onTouchRelease: (id) sender{
	self.label.highlighted	=	NO;
	NSLog(@"Touch Up");
	[super onTouchRelease:sender];
}


/*	Draws a Sign Button's background frame */
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
	UIBezierPath *path	=	[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:SGNBTN_FRAME_CORNER_RADIUS];
	CGContextAddPath(context, [path CGPath]);
	CGContextFillPath(context);

	return output;
}


/*	Draws a Sign Button's icon */
+ (CGLayerRef) drawIcon: (CGContextRef) c
				   rect: (CGRect) rect
				 colour: (unsigned) colour{

	CGLayerRef output		=	CGLayerCreateWithContext(c, rect.size, NULL);
	CGContextRef context	=	CGLayerGetContext(output);
	
	
	UIBezierPath *icon	=	[UIBezierPath bezierPath];
	CGRect iconBounds	=	CGRectMake(0, 0, 26, 27);
	
	CGFloat xScale		=	rect.size.width / iconBounds.size.width;
	CGFloat yScale		=	rect.size.height / iconBounds.size.height;
	
	
	[icon moveToPoint:CGPointMake((7.204 * xScale) + 1, (0.330 * yScale) + 1)];
	CGPoint v1[]	=	{
		{11.67,	-0.938},	{16.779, 1.559},	{18.502, 5.876},
		{20.076, 9.37},		{19.208, 13.549},	{16.811, 16.449},
		{17.023, 16.647},	{17.45, 17.048},	{17.662, 17.25},
		{17.864, 17.115},	{18.269, 16.846},	{18.471, 16.711},
		{20.126, 18.024},	{21.444, 19.692},	{22.996, 21.118},
		{23.684, 21.873},	{24.597, 22.494},	{25.002, 23.461},
		{24.134, 24.451},	{23.279, 25.822},	{21.971, 26.155},
		{19.933, 24.302},	{18.04, 22.278},	{16.088, 20.335},
		{15.395, 19.899},	{15.908, 19.18},	{16.092, 18.608},
		{15.867, 18.41},	{15.422, 18.005},	{15.201, 17.807},
		{12.782, 19.39},	{9.701, 19.966},	{6.916, 19.112},
		{3.413, 18.113},	{0.665, 14.956},	{0.152,	11.344},
		{-0.748, 6.596},	{2.463, 1.459},		{7.204,	0.33}		
	};
	for(unsigned i = 0; i < 39; i += 3)
		[icon	addCurveToPoint:	CGPointMake((v1[i+2].x * xScale) + 1,	(v1[i+2].y * yScale)	+ 1)
				controlPoint1:		CGPointMake((v1[i].x * xScale) + 1,		(v1[i].y * yScale)		+ 1)
				controlPoint2:		CGPointMake((v1[i+1].x * xScale) + 1,	(v1[i+1].y * yScale)	+ 1)];
	[icon closePath];
	
	
	
	[icon moveToPoint:CGPointMake((7.824 * xScale) + 1, (2.139 * yScale) + 1)];
	CGPoint v2[]	=	{
		{5.036, 2.822},		{2.773, 5.147},		{2.117, 7.936},
		{1.204, 11.354},	{3.057, 15.213},	{6.21,	16.764},
		{8.414,	17.944},	{11.211, 17.871},	{13.37,	16.616},
		{16.68,	14.845},	{18.367, 10.486},	{16.887, 6.988},
		{15.618, 3.42},		{11.512, 1.136},	{7.824, 2.139}
	};
	for(unsigned i = 0; i < 15; i += 3)
		[icon	addCurveToPoint:	CGPointMake((v2[i+2].x * xScale)	+ 1,		(v2[i+2].y * yScale)	+ 1)
				controlPoint1:		CGPointMake((v2[i].x * xScale)		+ 1,		(v2[i].y * yScale)		+ 1)
				controlPoint2:		CGPointMake((v2[i+1].x * xScale)	+ 1,		(v2[i+1].y * yScale)	+ 1)];
	[icon closePath];
	
	
	
	[icon moveToPoint:CGPointMake((8.526 * xScale) + 1, (5.453 * yScale) + 1)];
	CGPoint v3[]	=	{
		{9.277, 5.453},		{10.024, 5.453},	{10.775, 5.453},
		{10.775, 6.501},	{10.775, 7.554},	{10.775, 8.601},
		{11.823, 8.601},	{12.875, 8.601},	{13.923, 8.601},
		{13.923, 9.352},	{13.923, 10.098},	{13.923, 10.85},
		{12.875, 10.85},	{11.823, 10.85},	{10.775, 10.85},
		{10.775, 11.898},	{10.775, 12.95},	{10.775, 13.997},
		{10.024, 13.997},	{9.277, 13.997},	{8.526, 13.997},
		{8.526, 12.949},	{8.526, 11.897},	{8.526, 10.85},
		{7.478, 10.85},		{6.426, 10.85},		{5.378, 10.85},
		{5.378, 10.098},	{5.378, 9.352},		{5.378, 8.601},
		{6.426, 8.601},		{7.479, 8.601},		{8.526, 8.601},
		{8.526, 7.554},		{8.526, 6.501},		{8.526, 5.453}
	};
	for(unsigned i = 0; i < 36; i += 3)
		[icon	addCurveToPoint:	CGPointMake((v3[i+2].x * xScale)	+ 1,		(v3[i+2].y * yScale)	+ 1)
				controlPoint1:		CGPointMake((v3[i].x * xScale)		+ 1,		(v3[i].y * yScale)		+ 1)
				controlPoint2:		CGPointMake((v3[i+1].x * xScale)	+ 1,		(v3[i+1].y * yScale)	+ 1)];
	[icon closePath];
	
	
	
	//	Apply Bezier Path to CGContext
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
	[label release];
	CGLayerRelease(imgIconDefault);
	CGLayerRelease(imgIconHighlight);

	[super dealloc];
}


@end