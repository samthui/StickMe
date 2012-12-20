//
//  RadarView.m
//  StickMe
//
//  Created by admin on 12/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadarView.h"

#define ORDERED_RANGE_S_COLOR [NSArray arrayWithObjects:[UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor redColor], nil]

@implementation RadarView

@synthesize rangesArray = _rangesArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    self.rangesArray = nil;
    
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!self.rangesArray || _rangesArray.count < 1) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bound;
    float radius;
    CGRect viewFrame = self.frame;
    CGSize sizeFrame = viewFrame.size;
    
    for (int i = 0; i < _rangesArray.count; i++) {
        radius = [[_rangesArray objectAtIndex:i] floatValue];
        bound = CGRectMake(sizeFrame.width/2 - radius, sizeFrame.height/2 - radius, 2*radius, 2*radius);
        
        CGContextAddEllipseInRect(ctx, bound);
        UIColor* color = [ORDERED_RANGE_S_COLOR objectAtIndex:(i % [(NSArray*)ORDERED_RANGE_S_COLOR count])];
        CGContextSetFillColor(ctx, CGColorGetComponents([color CGColor]));        
    }
    CGContextFillPath(ctx);
    
 //Drawing code
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(ctx, rect);
//    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blueColor] CGColor]));
//    CGContextFillPath(ctx);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetLineWidth(context, 2.0);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    
//    CGRect rectangle = CGRectMake(0,0,100,100);
//    
//    CGContextAddEllipseInRect(context, rectangle);
//    
//    CGContextStrokePath(context);
}


@end
