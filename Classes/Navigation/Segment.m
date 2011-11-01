//
//  Segment.m
//  GreenWalk
//
//  Created by John Gardner on 18/08/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "Segment.h"
#import "GWCoreAdditions.h"


@implementation Segment

@synthesize ID, name, transition, visited, still, clip, duration, delay, targetID, links, anim, portrait, landscape;


+ (Segment *) createFromDictionary: (NSDictionary *) kDict
						   usingID: (NSString *) kID{
	
	Segment *s			=	[Segment alloc];
	s.ID				=	kID;
	s.name				=	[kDict valueForKey:@"name"];
	s.transition		=	CFBooleanGetValue((CFBooleanRef) [kDict valueForKey:@"transition"]);
	s.targetID			=	[kDict valueForKey:@"target"];
	s.duration			=	[[kDict valueForKey:@"duration"] doubleValue];
	s.delay				=	[[kDict valueForKey:@"delay"] doubleValue];

	
	//	Still Image
	NSDictionary *kStill	=	[kDict valueForKey:@"still"];
	NSString *stillPath		=	[kStill resourceString];
	if(stillPath != nil)
		s.still				=	[UIImage imageWithContentsOfFile:stillPath];

	
	//	Video Clip
	NSDictionary *kClip		=	[kDict valueForKey:@"clip"];
	s.clip					=	[kClip resourceURL];


	
	//	Construct array of Link instances
	NSMutableArray *links		=	[kDict valueForKey:@"links"];
	NSUInteger count			=	[links count];
	s.links						=	[NSMutableArray arrayWithCapacity:count];
	for(int i = 0; i < count; ++i)
		[s.links addObject:[Link createFromDictionary:[links objectAtIndex:i]]];
	
	
	//	Declare the Path's animations
	if(s.transition){
		NSDictionary *anim		=	[kDict valueForKey:@"anim"];
		s.portrait				=	[Segment createAnimation:anim fromName:@"portrait"];
		s.landscape				=	[Segment createAnimation:anim fromName:@"landscape"];
		s.portrait.duration		=	s.duration;
		s.landscape.duration	=	s.duration;
	}
	
	
	[s init];
	return s;
}




+ (NSMutableArray *) expandPointArray: (NSArray *) input
						  usingOffset: (CGPoint) offset{
	NSUInteger count			=	[input count];
	NSMutableArray *output		=	[NSMutableArray arrayWithCapacity:count];
	CGPoint point;
	for(int i = 0; i < count; ++i){
		point		=	CGPointOffset([[input objectAtIndex:i] pointValue], offset);
		[output addObject:[NSValue valueWithCGPoint:point]];
	}
	return output;
}



//	Unwraps a keyframe animation from an NSDictionary of supplied values and times
+ (CAKeyframeAnimation *) createAnimation: (NSDictionary *) dict
								 fromName: (NSString *) name{
	NSDictionary *keys			=	[dict valueForKey:name];
	CAKeyframeAnimation *output	=	[CAKeyframeAnimation animation];
	CGPoint offset				=	(@"portrait" == name) ? CGPointMake(MAGIC_OFFSET_PORTRAIT_X, MAGIC_OFFSET_PORTRAIT_Y) : CGPointMake(MAGIC_OFFSET_LANDSCAPE_X, MAGIC_OFFSET_LANDSCAPE_Y);
	
	NSMutableArray *values		=	[Segment expandPointArray:[keys valueForKey:@"values"] usingOffset:offset];
	NSMutableArray *times		=	[NSMutableArray arrayWithArray:[keys valueForKey:@"times"]];
	if([times objectAtIndex:0] > 0){
		[times insertObject:[NSNumber numberWithFloat:0.0] atIndex:0];
		[values insertObject:[values objectAtIndex:0] atIndex:0];
	}

	output.values				=	values;
	output.keyTimes				=	times;
	output.fillMode				=	kCAFillModeBoth;
	output.removedOnCompletion	=	NO;
	return output;
}


- (id) init{
	if(self = [super init]){
		
	}
	return self;
}




- (NSString *) description{
	NSNumber *dur	=	[NSNumber numberWithDouble:self.duration];
	NSNumber *del	=	[NSNumber numberWithDouble:self.delay];
	return [NSString stringWithFormat:@"<Segment \"%@\" name=\"%@\" duration=\"%@\" delay=\"%@\" still=\"%@\" clip=\"%@\">", self.ID, self.name, [dur stringValue], [del stringValue], self.still, self.clip];
}


- (void) dealloc{
	[ID release];
	[name release];
	[targetID release];
	[links release];
	[anim release];
	
	[portrait release];
	[landscape release];
	
	[super dealloc];
}

@end