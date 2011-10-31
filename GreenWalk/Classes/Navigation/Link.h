//
//	Link.h
//	GreenWalk
//
//	Created by John Gardner on 27/07/11.
//	Copyright 2011 Swinburne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "GWCoreAdditions.h"
#import "SegmentLinkButton.h"


@class LinkButton;

@interface Link : NSObject {
	NSString *targetID;
	LinkType type;
	LinkLayout portrait;
	LinkLayout landscape;
	
	LinkButton *button;
}


+ (Link *) createFromDictionary: (NSDictionary *) dict;
+ (LinkLayout) layoutFromDictionary: (NSDictionary *) dict;

@property (nonatomic, retain) NSString *targetID;
@property (nonatomic) LinkType type;
@property (nonatomic) LinkLayout portrait;
@property (nonatomic) LinkLayout landscape;

@property (nonatomic, retain) LinkButton	*button;

@end