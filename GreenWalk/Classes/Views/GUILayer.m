//
//	GUILayer.m
//	GreenWalk
//
//	Created by John Gardner on 28/05/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import "GUILayer.h"



@implementation GUILayer

@synthesize bearing, links	=	_links;


- (id) initWithCoder:(NSCoder *) aDecoder{
	self	=	[super initWithCoder:aDecoder];
	if(self)	[self setupView];
	return self;
}


- (id) initWithFrame: (CGRect) frame{
	self	=	[super initWithFrame:frame];
	if(self)	[self setupView];
	return self;
}


- (void) setLinks: (NSArray *) input{
	if(input != _links){
		_links		=	input;
		
		[self removeSubviews];
		
		NSUInteger	count	=	[input count];
		if(count > 0) for(int i = 0; i < count; ++i)
			[self addSubview:[[input objectAtIndex:i] button]];
		
		[self realign];
	}
}




- (void) layoutSubviews{
	UIView *sup			=	self.superview;
	if(sup != nil){
		CGFloat	height			=	sup.bounds.size.height;
		CGRect bounds			=	self.bounds;
		bounds.size.height		=	height;
		[self setFrame:bounds];
	}
}


- (void) setupView{
	self.opaque				=	NO;
	self.autoresizingMask	=	UIViewAutoresizingFlexibleWidth;
	[self realign];
}



//	Realign position of buttons whenever the screen layout's changed.
- (void) realign{
	
	if(self.links){
		CGSize size			=	self.frame.size;
		
		Link *link;
		LinkLayout layout;
		CGAffineTransform xform;
		for(unsigned i = 0; i < [self.links count]; i++){
			link			=	[self.links objectAtIndex:i];
			layout			=	self.bearing == BearingPortrait ? link.portrait : link.landscape;
			
			xform			=	CGAffineTransformIdentity;
			if(layout.rotation)
				xform		=	CGAffineTransformRotate(xform, (layout.rotation * M_PI / 180.0));
			
			if(link.type == LinkTypeSegment)
				xform					=	CGAffineTransformTranslate(xform, 0, SEGBTN_FRAME_HEIGHT / 2);
			
			link.button.bearing			=	self.bearing;
			link.button.transform		=	xform;
			link.button.center			=	CGPointMake(layout.position.x * size.width, layout.position.y * size.height);
			[link.button setNeedsDisplay];
		}
	}
}



- (void) dealloc{
	[_links release];

	[super dealloc];
}


@end