//
//  MoviePlayer.h
//  GreenWalk
//
//  Created by John Gardner on 28/07/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface MoviePlayer : MPMoviePlayerController {
	UIViewController *root;
	BOOL changingURL;
}

@property (nonatomic, retain) UIViewController *root;
@property (nonatomic) BOOL changingURL;

- (void) setupPlayer;

@end