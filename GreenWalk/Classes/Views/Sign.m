//
//	Sign.m
//	SpaceCrawl
//
//	Created by John Gardner on 18/10/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import "Sign.h"


@implementation Sign

@synthesize target, background, webView, flyoutX, flyoutY, flyoutXFrame, flyoutXFrameRect, flyoutYFrame, flyoutYFrameRect, link, state, reversed,
	portrait	=	_portrait,
	landscape	=	_landscape,
	bearing		=	_bearing;



//	Swap the targeted subview between the flyout views
- (void) setBearing: (int) input{
	_bearing	=	input;
	if(self.state != SignStateOpened){
		[target.layer removeFromSuperlayer];
		switch(input){
			case BearingPortrait:	[flyoutXFrame.layer insertSublayer:target.layer atIndex:1];	break;
			case BearingLandscape:	[flyoutYFrame.layer insertSublayer:target.layer atIndex:1];	break;
			default:				[self.layer insertSublayer:target.layer atIndex:1];			break;
		}
	}
}


//	Creates and applies the animations used for a bearing's flyout view
- (void) setLayout: (CATransform3D) xform
		forBearing: (BearingType) b
		 inReverse: (BOOL) reverse{
	
	double duration			=	reverse ? (FLYOUT_DURATION * 0.3) : FLYOUT_DURATION;
	
	
	//================================================================================
	//		Flyout View Animations
	//================================================================================
	CALayer *layer				=	b == BearingLandscape ? flyoutY.layer : flyoutX.layer;
	layer.transform				=	xform;
	
	
	//	3D Transform
	CABasicAnimation *anim		=	[CABasicAnimation animation];
	anim.duration				=	duration;
	anim.removedOnCompletion	=	NO;
	anim.fillMode				=	kCAFillModeBoth;
	anim.fromValue				=	[NSValue valueWithCATransform3D:(reverse ? CATransform3DIdentity : xform)];
	anim.toValue				=	[NSValue valueWithCATransform3D:(reverse ? xform : CATransform3DIdentity)];
	anim.delegate				=	self;
	[layer removeAllAnimations];
	[layer addAnimation:anim forKey:@"transform"];
	
	
	//	Opacity
	CABasicAnimation *opacity	=	[CABasicAnimation animation];
	opacity.duration			=	duration * 0.8;
	opacity.removedOnCompletion	=	NO;
	opacity.fillMode			=	kCAFillModeBoth;
	opacity.fromValue			=	[NSNumber numberWithFloat:(reverse ? 1 : 0)];
	opacity.toValue				=	[NSNumber numberWithInt:(reverse ? 0 : 1)];
	[layer addAnimation:opacity forKey:@"opacity"];

	
	
	//================================================================================
	//		Shield Animations
	//================================================================================
	CABasicAnimation *opacity2		=	[CABasicAnimation animation];
	layer							=	self.background.layer;
	opacity2.duration				=	duration;
	opacity2.removedOnCompletion	=	NO;
	opacity2.fillMode				=	kCAFillModeBoth;
	opacity2.fromValue				=	[NSNumber numberWithInt:(reverse ? 0.8 : 0)];
	opacity2.toValue				=	[NSNumber numberWithFloat:(reverse ? 0 : 0.8)];
	[layer removeAllAnimations];
	[layer addAnimation:opacity2 forKey:@"opacity"];
}


- (void) setPortrait: (LinkLayout) input{
	_portrait	=	input;
	[self setLayout:input.sign forBearing:BearingPortrait inReverse:self.reversed];
}


- (void) setLandscape: (LinkLayout) input{
	_landscape	=	input;
	[self setLayout:input.sign forBearing:BearingLandscape inReverse:self.reversed];
}



//	Opens the document targeted by the specified Link
- (void) open: (Link *) input{
	
	if(self.state == SignStateClosed){
		self.link				=	input;
		self.hidden				=	YES;

		//	Load the HTML document into the webView		
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:input.targetID]]];
	}
}


//	Closes the open document, if any
- (void) close{
	
	if(self.state == SignStateOpened){
		self.state		=	SignStateClosing;
		self.reversed	=	YES;
		
		[self addSubview:self.target];
		self.bearing	=	self.bearing;
		[self setNeedsLayout];
		
		self.portrait	=	self.portrait;
		self.landscape	=	self.landscape;
	}
}


//	Reset subviews at the end of a fade-out transition
- (void) reset{	
	self.hidden			=	YES;
	self.state			=	SignStateClosed;
	self.reversed		=	NO;
}



- (void) layoutSubviews{
	if(self.state != SignStateOpened){
		CGRect rect	=	self.bearing == BearingPortrait ? flyoutXFrame.bounds : flyoutYFrame.bounds;
		[self.target setFrame:rect];
	}
}


//	Use the delegate method webViewDidFinishLoad to reveal the contents and start the transition; this
//	prevents an unsightly flash of white from appearing before the page has had a chance to load.
- (void) webViewDidFinishLoad: (UIWebView *) view{
	self.hidden				=	NO;
	self.portrait			=	self.link.portrait;
	self.landscape			=	self.link.landscape;
	self.state				=	SignStateOpening;
}


//	Check query string to determine if we should close the view or not
- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType{
	if([[[request URL] description] hasSuffix:@"?close"]){
		[self close];
		return NO;
	}
	return YES;
}


//	Signals that the transition's finished; hand our WebView over to our RootViewController to allow user interaction
- (void) animationDidStop: (CAAnimation *) anim
				 finished: (BOOL) flag{
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SIGNVIEW_OPENED object:self]];
}




- (void) dealloc{
	[target release];
	[background release];
	[webView release];
	
	[flyoutX release];
	[flyoutY release];
	[flyoutXFrame release];
	[flyoutYFrame release];
	
	[super dealloc];
}





/*	Utility Methods	*/

+ (CATransform3D) rotate: (CATransform3D) t
				 degrees: (float) degrees
					axis: (Axis) axis{
	return CATransform3DRotate(t, degrees * M_PI / 180, (axis == XAxis ? 1 : 0), (axis == YAxis ? 1 : 0), (axis == ZAxis ? 1 : 0));
}


//	Reorients a rectangle to face either portrait or landscape orientation
+ (CGRect) rotateRect: (CGRect) input
				   to: (BearingType) type{
	CGFloat w	=	input.size.width;
	CGFloat h	=	input.size.height;
	if((w > h && type == BearingPortrait) || (h > w && type == BearingLandscape)){
		input.size.width	=	h;
		input.size.height	=	w;
	}
	return input;
}


+ (void) exportValue: (NSValue *) value{
	NSDictionary *dict	=	[NSDictionary dictionaryWithObjectsAndKeys:value, @"value", nil];
	[dict writeToFile:@"wat" atomically:YES];
}

@end