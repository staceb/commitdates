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
	BOOL playing;
}

@property (nonatomic, retain) UIViewController *root;
@property (nonatomic) BOOL changingURL;
@property (nonatomic) BOOL playing;

- (void) setupPlayer;

@end