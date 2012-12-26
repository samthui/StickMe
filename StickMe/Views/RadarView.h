//
//  RadarView.h
//  StickMe
//
//  Created by admin on 12/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BOUND_MARGIN    5

@interface RadarView : UIView

@property (nonatomic, retain) NSMutableArray* rangesArray;
@property (nonatomic, assign) int maxDistance;

@end
