//
//  MovieView.m
//  GreenWalk
//
//  Created by John Gardner on 27/07/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "MovieView.h"


@implementation MovieView

@synthesize target, aoiX, aoiY,
	portrait	=	_portrait,
	landscape	=	_landscape,
	bearing		=	_bearing;



- (void) setPortrait: (CAKeyframeAnimation *) input{
	if(input != _portrait){
		_portrait	=	input;
		[aoiX.layer addAnimation:_portrait forKey:@"position"];
	}
}

- (void) setLandscape: (CAKeyframeAnimation *) input{
	if(input != _landscape){
		_landscape	=	input;
		[aoiY.layer addAnimation:_landscape forKey:@"position"];
	}
}


//	Swap the targeted subview between the areas-of-interest
- (void) setBearing: (int) input{
	_bearing	=	input;
	[target.layer removeFromSuperlayer];
	switch(input){
		case BearingPortrait:	[aoiX.layer insertSublayer:target.layer atIndex:1];		break;
		case BearingLandscape:	[aoiY.layer insertSublayer:target.layer atIndex:1];		break;
		default:				[self.layer insertSublayer:target.layer atIndex:1];		break;
	}
}



//	Performs the necessary setup operations after loading the view
- (void) setupView{
	aoiX.layer.anchorPoint		=	CGPointMake(0, 0);
	aoiY.layer.anchorPoint		=	CGPointMake(0, 0);
}

- (void) setAnimations: (Segment *) input{
	self.portrait	=	input.portrait;
	self.landscape	=	input.landscape;
}


- (void) addTarget: (UIView *) input
   withOrientation: (BearingType) orient{
	[self.target addSubview:input];
	self.bearing	=	orient;
}



- (void) dealloc{
	[super dealloc];
}


@end