//
//  GWCoreAdditions.m
//  GreenWalk
//
//  Created by John Gardner on 13/08/11.
//  Copyright 2011 Swinburne. All rights reserved.
//

#import "GWCoreAdditions.h"


CGFloat degToRad(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat radToDeg(CGFloat radians) {return radians * 180 / M_PI;};

CGPoint CGPointOffset(CGPoint point, CGPoint offset){
	CGPoint p	=	point;
	p.x	+=	offset.x;
	p.y	+=	offset.y;
	return p;
}

void printRect(CGRect rect){
	NSNumber *x		=	[NSNumber numberWithFloat:rect.origin.x];
	NSNumber *y		=	[NSNumber numberWithFloat:rect.origin.y];
	NSNumber *w		=	[NSNumber numberWithFloat:rect.size.width];
	NSNumber *h		=	[NSNumber numberWithFloat:rect.size.height];
	NSLog(@"<Rect x=\"%1$@\" y=\"%2$@\" width=\"%3$@\" height=\"%4$@\">", [x stringValue], [y stringValue], [w stringValue], [h stringValue]);
}

void printSize(CGSize size){
	NSNumber *w		=	[NSNumber numberWithFloat:size.width];
	NSNumber *h		=	[NSNumber numberWithFloat:size.height];
	NSLog(@"<Size %@ x %@>", [w stringValue], [h stringValue]);
}

void print3DTransform(CATransform3D t, BOOL prettyPrint){
	NSString *format	=	prettyPrint ?
		@"\n\t%@\t%@\t%@\t%@\n\t%@\t%@\t%@\t%@\n\t%@\t%@\t%@\t%@\n\t%@\t%@\t%@\t%@\n" :
		@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@";
	
	NSString *s	=	[NSString stringWithFormat:format,
		[[NSNumber numberWithFloat:t.m11] stringValue],
		[[NSNumber numberWithFloat:t.m12] stringValue],
		[[NSNumber numberWithFloat:t.m13] stringValue],
		[[NSNumber numberWithFloat:t.m14] stringValue],
		[[NSNumber numberWithFloat:t.m21] stringValue],
		[[NSNumber numberWithFloat:t.m22] stringValue],
		[[NSNumber numberWithFloat:t.m23] stringValue],
		[[NSNumber numberWithFloat:t.m24] stringValue],
		[[NSNumber numberWithFloat:t.m31] stringValue],
		[[NSNumber numberWithFloat:t.m32] stringValue],
		[[NSNumber numberWithFloat:t.m33] stringValue],
		[[NSNumber numberWithFloat:t.m34] stringValue],
		[[NSNumber numberWithFloat:t.m41] stringValue],
		[[NSNumber numberWithFloat:t.m42] stringValue],
		[[NSNumber numberWithFloat:t.m43] stringValue],
		[[NSNumber numberWithFloat:t.m44] stringValue]
	];
	NSLog(@"%@", s);
}

void encode3DTransform(CATransform3D t){
	NSData *dTransform	=	[NSData dataWithBytes:&t length:sizeof(t)];
	NSDictionary *dict	=	[NSDictionary dictionaryWithObjectsAndKeys:dTransform, @"transform", nil];
	[dict writeToFile:@"exported.plist" atomically:YES];
}



@implementation UIView (GWCoreAdditions)

- (void) removeSubviews{
	NSUInteger count	=	[self.subviews count];
	if(count > 0) for(unsigned i = 0; i < count; ++i)
		[[self.subviews objectAtIndex:0] removeFromSuperview];	
}

@end



@implementation NSDictionary (GWCoreAdditions)

- (CGPoint) pointValue{
	CGPoint point	=	{[[self valueForKey:@"X"] floatValue], [[self valueForKey:@"Y"] floatValue]};
	return point;
}


- (CGSize) sizeValue{
	CGSize size		=	{[[self valueForKey:@"width"] floatValue], [[self valueForKey:@"height"] floatValue]};
	return size;
}


- (NSString *) resourceString{
	NSBundle *bundle	=	[NSBundle mainBundle];
	return [bundle pathForResource:[self valueForKey:@"filename"] ofType:nil inDirectory:[self valueForKey:@"path"]];
}


- (NSURL *) resourceURL{
	NSString *path	=	[self resourceString];
	return (path ? [NSURL fileURLWithPath:path] : nil);
}

@end




@implementation UIAlertView (GWCoreAdditions)

+ (UIAlertView *) createFromDictionary: (NSDictionary *) input{
	NSString *text	=	[[input valueForKey:@"text"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
	NSString *btn1	=	[input valueForKey:@"button1"];
	NSString *btn2	=	[input valueForKey:@"button2"];
	return [[UIAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:btn1 otherButtonTitles:btn2, nil];
}

@end





@implementation NSString (GWCoreAdditions)

- (CATransform3D) transform3DValue{
	NSArray *split			=	[self componentsSeparatedByString:@","];
	CATransform3D output	=	{
		[[split objectAtIndex:0] floatValue], [[split objectAtIndex:1] floatValue], [[split objectAtIndex:2] floatValue],
		[[split objectAtIndex:3] floatValue], [[split objectAtIndex:4] floatValue], [[split objectAtIndex:5] floatValue],
		[[split objectAtIndex:6] floatValue], [[split objectAtIndex:7] floatValue], [[split objectAtIndex:8] floatValue],
		[[split objectAtIndex:9] floatValue], [[split objectAtIndex:10] floatValue], [[split objectAtIndex:11] floatValue],
		[[split objectAtIndex:12] floatValue], [[split objectAtIndex:13] floatValue], [[split objectAtIndex:14] floatValue],
		[[split objectAtIndex:15] floatValue]
	};
	return output;
}

@end