//
//  GWCoreAdditions.h
//  GreenWalk
//
//  Created by John Gardner on 13/08/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


CGFloat degToRad(CGFloat degrees);
CGFloat radToDeg(CGFloat radians);

CGPoint CGPointOffset(CGPoint point, CGPoint offset);

void printRect(CGRect rect);
void printSize(CGSize size);
void print3DTransform(CATransform3D t, BOOL prettyPrint);
void encode3DTransform(CATransform3D t);


@interface UIView (GWCoreAdditions)

- (void) removeSubviews;

@end



@interface NSDictionary (GWCoreAdditions)

- (CGPoint)		pointValue;
- (CGSize)		sizeValue;
- (NSString *)	resourceString;
- (NSURL *)		resourceURL;

@end



@interface UIAlertView (GWCoreAdditions)

+ (UIAlertView *) createFromDictionary: (NSDictionary *) input;

@end



@interface NSString (GWCoreAdditions)

- (CATransform3D) transform3DValue;

@end