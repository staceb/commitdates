//
//  Segment.h
//  GreenWalk
//
//  Created by John Gardner on 18/08/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "Link.h"


@interface Segment : NSObject {
	NSString *ID;
	NSString *name;
	BOOL transition;
	BOOL visited;
	
	UIImage *still;
	NSURL *clip;
	
	NSTimeInterval duration;
	NSTimeInterval delay;
	NSString *targetID;
	NSMutableArray *links;
	NSDictionary *anim;
	
	CAKeyframeAnimation *portrait;
	CAKeyframeAnimation *landscape;
}


@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) BOOL transition;
@property (nonatomic) BOOL visited;

@property (nonatomic, retain) UIImage *still;
@property (nonatomic, retain) NSURL *clip;

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic, retain) NSString *targetID;
@property (nonatomic, retain) NSMutableArray *links;
@property (nonatomic, retain) NSDictionary *anim;

@property (nonatomic, retain) CAKeyframeAnimation *portrait;
@property (nonatomic, retain) CAKeyframeAnimation *landscape;


+ (Segment *) createFromDictionary: (NSDictionary *) kDict
						   usingID: (NSString *) kID;

+ (NSMutableArray *) expandPointArray: (NSArray *) input
						  usingOffset: (CGPoint) offset;

+ (CAKeyframeAnimation *) createAnimation: (NSDictionary *) dict
								 fromName: (NSString *) name;

@end