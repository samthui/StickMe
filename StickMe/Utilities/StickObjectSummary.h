//
//  StickObjectSummary.h
//  StickMe
//
//  Created by admin on 12/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StickObjectSummary : NSObject <NSCoding>

@property (nonatomic, retain) NSString* UUID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) BOOL noticeInRange;
@property (nonatomic, assign) BOOL noticeOutRange;
@property (nonatomic, assign) int setupDistance;

@end
