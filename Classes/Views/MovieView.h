//
//	MovieView.h
//	GreenWalk
//
//	Created by John Gardner on 27/07/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "Segment.h"

@class Segment;


@interface MovieView : UIView {
	UIView *target;
	UIView *aoiX;
	UIView *aoiY;
	
	CAKeyframeAnimation *_portrait;
	CAKeyframeAnimation *_landscape;
	
	int		_bearing;
}

@property (nonatomic, retain) IBOutlet UIView *target;
@property (nonatomic, retain) IBOutlet UIView *aoiX;
@property (nonatomic, retain) IBOutlet UIView *aoiY;

@property (nonatomic, retain) CAKeyframeAnimation *portrait;
@property (nonatomic, retain) CAKeyframeAnimation *landscape;

@property (nonatomic) int bearing;


- (void) setupView;
- (void) setAnimations: (Segment *) input;
- (void) addTarget: (UIView *) input
   withOrientation: (BearingType) orient;

@end