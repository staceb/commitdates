//
//  MoviePlayer.m
//  GreenWalk
//
//  Created by John Gardner on 28/07/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "MoviePlayer.h"


@implementation MoviePlayer

@synthesize root, changingURL;


- (id) init{
	if(self = [super init])
		[self setupPlayer];
	return self;
}

- (void) setupPlayer{
	self.changingURL	=	NO;
	self.scalingMode	=	MPMovieScalingModeNone;
	self.controlStyle	=	MPMovieControlStyleNone;
}

- (void) setContentURL: (NSURL *) contentURL{
	self.changingURL	=	YES;
	[super setContentURL:contentURL];
	self.changingURL	=	NO;
}

@end