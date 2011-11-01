//
//  LinkButton.m
//  GreenWalk
//
//  Created by John Gardner on 19/08/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "LinkButton.h"
#import "Link.h"


@implementation LinkButton

@synthesize imgFrame, portrait, landscape, bearing, link;


- (id) initWithFrame: (CGRect) frame{
	if(self = [super initWithFrame:frame])
		[self setupView];
	return self;
}


- (void) setupView{
	self.opaque	=	NO;
	[self addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
	[self addTarget:self action:@selector(onTouchRelease:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) onTouchDown: (id) sender{
	[self setNeedsDisplay];
}


- (void) onTouchRelease: (id) sender{
	self.highlighted	=	NO;
	[self setNeedsDisplay];
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BUTTON_PRESSED object:self]];
}



//	Only override drawRect: if you perform custom drawing.
//	*	An empty implementation adversely affects performance during animation.
- (void) drawRect: (CGRect) rect{
	CGContextDrawLayerAtPoint(UIGraphicsGetCurrentContext(), CGPointZero, self.imgFrame);
}


- (void) dealloc{
	[link release];
	
	[super dealloc];
}

@end