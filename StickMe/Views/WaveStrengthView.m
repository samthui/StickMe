//
//  WaveStrengthView.m
//  StickMe
//
//  Created by admin on 12/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaveStrengthView.h"

@interface WaveStrengthView ()

-(int) convertFromRangeToRadius:(int)range;

@end

@implementation WaveStrengthView

@synthesize range = _range;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{        
    CGRect viewFrame = self.frame;
//    NSLog(@"%@", NSStringFromCGRect(viewFrame));
    CGSize frameSize = viewFrame.size;
    
    int radius = [self convertFromRangeToRadius:_range];
    
    CGPoint center = CGPointMake(frameSize.width/2, frameSize.height);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx,
                    center.x,
                    center.y,
                    radius,
                    -M_PI/18 - M_PI/2,
                    M_PI/18 - M_PI/2,
                    1); 
    UIColor* color = [UIColor greenColor];
    CGContextSetFillColor(ctx, CGColorGetComponents([color CGColor]));   
    CGContextFillPath(ctx);  
    
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path addArcWithCenter:center 
//                    radius:10
//                startAngle:-PI/6 - PI/2
//                  endAngle:PI/6 - PI/2
//                 clockwise:NO];
//    [path fill];
    
//    CGContextBeginPath(ctx);
//    CGContextAddArc(ctx, center.x, center.y, 10, -PI/6 - PI/2, -PI/6 - PI/2, 0);
//    CGContextClosePath(ctx); // could be omitted
//    CGContextSetFillColorWithColor(ctx, [UIColor cyanColor].CGColor);
//    CGContextFillPath(ctx);
}

#pragma mark - private methods
-(int) convertFromRangeToRadius:(int)range
{
    int radius = 0;
    
    if (range < 4) {
        radius = self.frame.size.height;
    }
    else if (range < 8) {
        radius = 29;
    }
    else if (range < 17) {
        radius = 24;
    }
    else if (range < 30) {
        radius = 19;
    }
//    NSLog(@"radius: %i", radius);
    
    return radius;
}

@end
