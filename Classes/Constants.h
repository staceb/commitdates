/*
 *  Constants.h
 *  GreenWalk
 *
 *  Created by John Gardner on 8/08/11.
 *  Copyright 2011 Swinburne. All rights reserved.
 *
 */
#import <QuartzCore/QuartzCore.h>


typedef enum{
	XAxis,
	YAxis,
	ZAxis
}	Axis;


typedef enum{
	BearingNone,
	BearingPortrait,
	BearingLandscape
} BearingType;


typedef enum{
	LinkTypeSegment,
	LinkTypeSign
} LinkType;


typedef enum{
	SignStateClosed,
	SignStateOpening,
	SignStateOpened,
	SignStateClosing
} SignState;



struct __LinkLayout{
	CGFloat rotation;
	CGFloat direction;
	CGPoint position;
	CATransform3D sign;
};
typedef struct __LinkLayout LinkLayout;






#define	SEGMENT_REACHED					@"gw:segmentReached"
#define	BUTTON_PRESSED					@"gw:buttonPressed"
#define SIGNVIEW_OPENED					@"gw:signviewOpened"
#define SIGNVIEW_CLOSED					@"gw:signviewClosed"


#define MAGIC_OFFSET_PORTRAIT_X			80
#define MAGIC_OFFSET_PORTRAIT_Y			0
#define MAGIC_OFFSET_LANDSCAPE_X		0
#define MAGIC_OFFSET_LANDSCAPE_Y		80


#define FLYOUT_DURATION					1


/*	Segment Buttons	*/
#define SEGBTN_FRAME_WIDTH				34
#define SEGBTN_FRAME_HEIGHT				30
#define SEGBTN_FRAME_CORNER_RADIUS		11
#define SEGBTN_FRAME_COLOUR				0x000000B3

#define SEGBTN_ARROW_WIDTH				20
#define SEGBTN_ARROW_HEIGHT				19

#define SEGBTN_ARROW_COLOUR_DEFAULT		0xD9D9D9FF
#define SEGBTN_ARROW_COLOUR_HIGHLIGHT	0xFFFFFFFF


/*	Sign Buttons */
#define SGNBTN_FRAME_WIDTH				106
#define SGNBTN_FRAME_HEIGHT				31
#define SGNBTN_FRAME_CORNER_RADIUS		16
#define SGNBTN_FRAME_COLOUR				0x000000B3

#define SGNBTN_ICON_X					6
#define SGNBTN_ICON_Y					5
#define SGNBTN_ICON_WIDTH				22
#define SGNBTN_ICON_HEIGHT				22

#define SGNBTN_TEXT_X					33
#define SGNBTN_TEXT_Y					0
#define SGNBTN_TEXT_COLOUR_DEFAULT		0xD9D9D9FF
#define SGNBTN_TEXT_COLOUR_HIGHLIGHT	0xFFFFFFFF
#define SGNBTN_TEXT_STRING				@"Examine"


#define percent(p,o,s)					((p-s) / (p-s)) * 100
#define percentOf(p,o,s)				(p / 100) * (o - s)