//
//  RadarView.m
//  StickMe
//
//  Created by admin on 12/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadarView.h"

#import "Utilities.h"

#define ORDERED_RANGE_S_COLOR [NSArray arrayWithObjects:[UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor redColor], nil]

@implementation RadarView

@synthesize rangesArray = _rangesArray;
@synthesize maxDistance = _maxDistance;

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
    _maxDistance = 0;
    
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    if (!self.rangesArray || _rangesArray.count < 1) {
//        return;
//    }
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGRect bound;
//    float radius;
//    CGRect viewFrame = self.frame;
//    CGSize sizeFrame = viewFrame.size;
//    
//    for (int i = 0; i < _rangesArray.count; i++) {
//        radius = [[_rangesArray objectAtIndex:i] floatValue];
//        bound = CGRectMake(sizeFrame.width/2 - radius, sizeFrame.height/2 - radius, 2*radius, 2*radius);
//        
////        CGContextAddEllipseInRect(ctx, bound);
////        UIColor* color = [ORDERED_RANGE_S_COLOR objectAtIndex:(i % [(NSArray*)ORDERED_RANGE_S_COLOR count])];
////        CGContextSetFillColor(ctx, CGColorGetComponents([color CGColor]));   
////        CGContextFillPath(ctx);  
//        
//        CGContextSetLineWidth(ctx, 2.0);
//        UIColor* color = [ORDERED_RANGE_S_COLOR objectAtIndex:(i % [(NSArray*)ORDERED_RANGE_S_COLOR count])];
//        CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
//        CGContextAddEllipseInRect(ctx, bound);
//        CGContextStrokePath(ctx);
//    } 
//}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bound;
    float radius;
    CGRect viewFrame = self.frame;
    CGSize sizeFrame = viewFrame.size;
    float maxRadius = sizeFrame.width/2.0 - BOUND_MARGIN;
    
    int guardian = STEP_0_5m;
    for (int i = 0; guardian <= _maxDistance; i++) {
        radius = (float)guardian*maxRadius/_maxDistance;
        bound = CGRectMake(sizeFrame.width/2 - radius, sizeFrame.height/2 - radius, 2*radius, 2*radius);
        
//        CGContextAddEllipseInRect(ctx, bound);
//        UIColor* color = [ORDERED_RANGE_S_COLOR objectAtIndex:(i % [(NSArray*)ORDERED_RANGE_S_COLOR count])];
//        CGContextSetFillColor(ctx, CGColorGetComponents([color CGColor]));   
//        CGContextFillPath(ctx);  
        
        CGContextSetLineWidth(ctx, 2.0);
        UIColor* color = [ORDERED_RANGE_S_COLOR objectAtIndex:(i % [(NSArray*)ORDERED_RANGE_S_COLOR count])];
        CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
        CGContextAddEllipseInRect(ctx, bound);
        CGContextStrokePath(ctx);
        
        if (guardian < RANGE_5m) {
            guardian += STEP_0_5m;
        }
        else if (guardian < RANGE_20m) {
            guardian += STEP_5_20m;
        }
        else {
            guardian += STEP_20_30m;
        }
    } 
}


@end
