//
//	Link.m
//	GreenWalk
//
//	Created by John Gardner on 27/07/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import "Link.h"


@implementation Link

@synthesize targetID, type, portrait, landscape, button;


+ (Link *) createFromDictionary: (NSDictionary *) dict{
	Link *output			=	[Link alloc];
	
	NSValue *target			=	[dict valueForKey:@"target"];
	output.targetID			=	([target isKindOfClass:[NSDictionary class]]) ? [(NSDictionary *) target resourceString] : [target description];
	output.type				=	[[dict valueForKey:@"type"] intValue];
	
	NSDictionary *layout	=	[dict valueForKey:@"layout"];
	output.portrait			=	[Link layoutFromDictionary:[layout valueForKey:@"portrait"]];
	output.landscape		=	[Link layoutFromDictionary:[layout valueForKey:@"landscape"]];

	[output init];
	return output;
}


+ (LinkLayout) layoutFromDictionary: (NSDictionary *) dict{
	CGFloat rotation			=	[[dict valueForKey:@"rotation"] floatValue];
	CGFloat direction			=	[[dict valueForKey:@"direction"] floatValue];
	CGPoint position			=	[[dict valueForKey:@"position"] pointValue];
	
	CATransform3D sign;
	NSData *kSign				=	[dict valueForKey:@"sign"];
	
	if(kSign != nil)
		[kSign getBytes:&sign length:[kSign length]];
	else
		sign					=	CATransform3DIdentity;
	
	LinkLayout layout			=	{rotation, direction, position, sign};
	return layout;
}



- (id) init{
	if(self = [super init]){

		switch(self.type){
			case LinkTypeSign:	self.button	=	[[SignLinkButton alloc]		initWithFrame:CGRectMake(0, 0, SGNBTN_FRAME_WIDTH, SGNBTN_FRAME_HEIGHT)];	break;
			default:			self.button	=	[[SegmentLinkButton alloc]	initWithFrame:CGRectMake(0, 0, SEGBTN_FRAME_WIDTH, SEGBTN_FRAME_HEIGHT)];	break;
		}
		self.button.link		=	self;
		self.button.portrait	=	self.portrait;
		self.button.landscape	=	self.landscape;
	}
	return self;
}

- (NSString *) description{
	return [NSString stringWithFormat:@"<Link target=\"%2$@\" type=\"%3$d\">", self.targetID, self.type];
}


- (void) dealloc{
	[button release];
	
	[super dealloc];
}

@end