//
//	Sign.h
//	SpaceCrawl
//
//	Created by John Gardner on 18/10/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "GWCoreAdditions.h"
#import "Link.h"


@class Link;

@interface Sign : UIView <UIWebViewDelegate> {
	UIView *target;
	UIView *background;
	UIWebView *webView;
	
	UIView *flyoutX;
	UIView *flyoutY;
	UIView *flyoutXFrame;
	UIView *flyoutYFrame;
	CGRect flyoutXFrameRect;
	CGRect flyoutYFrameRect;
	
	Link *link;
	
	LinkLayout _portrait;
	LinkLayout _landscape;
	SignState state;
	int _bearing;
	BOOL reversed;
}

@property (nonatomic, retain) IBOutlet UIView *target;
@property (nonatomic, retain) IBOutlet UIView *background;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) IBOutlet UIView *flyoutX;
@property (nonatomic, retain) IBOutlet UIView *flyoutY;
@property (nonatomic, retain) IBOutlet UIView *flyoutXFrame;
@property (nonatomic, retain) IBOutlet UIView *flyoutYFrame;
@property (nonatomic) CGRect flyoutXFrameRect;
@property (nonatomic) CGRect flyoutYFrameRect;

@property (nonatomic, retain) Link *link;

@property (nonatomic) LinkLayout portrait;
@property (nonatomic) LinkLayout landscape;
@property (nonatomic) SignState state;
@property (nonatomic) int bearing;
@property (nonatomic) BOOL reversed;


- (void) setLayout: (CATransform3D) xform
		forBearing: (BearingType) b
		 inReverse: (BOOL) reverse;

- (void) open: (Link *) input;
- (void) close;
- (void) reset;


/*	Callbacks and Notification Handlers */
- (void) webViewDidFinishLoad: (UIWebView *) view;
- (void) animationDidStop: (CAAnimation *) anim
				 finished: (BOOL) flag;



/*	Utility Methods	*/

+ (CATransform3D) rotate: (CATransform3D) t
				 degrees: (float) degrees
					axis: (Axis) axis;

+ (CGRect) rotateRect: (CGRect) input
				   to: (BearingType) type;

+ (void) exportValue: (NSValue *) value;

@end