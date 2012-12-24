//
//  StickObjectSummary.m
//  StickMe
//
//  Created by admin on 12/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StickObjectSummary.h"

@implementation StickObjectSummary

@synthesize UUID = _UUID;
@synthesize name = _name;
@synthesize noticeInRange = _noticeInRange;
@synthesize noticeOutRange = _noticeOutRange;
@synthesize setupDistance = _setupDistance;

- (id) initWithCoder: (NSCoder *)coder
{//NSLog(@"hi 1");
	self = [[StickObjectSummary alloc] init];
    if (self != nil)
	{//NSLog(@"hi 2");
		self.name = [coder decodeObjectForKey:@"name"];//NSLog(@"hi 3");
		self.UUID = [coder decodeObjectForKey:@"UUID"];//NSLog(@"hi 4");
        self.noticeInRange = [coder decodeBoolForKey:@"must_notice_in_range"];
        self.noticeOutRange = [coder decodeBoolForKey:@"must_notice_out_range"];
        self.setupDistance = [coder decodeIntForKey:@"setup_Distance"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{//NSLog(@"hi 5");
	[coder encodeObject:_name forKey:@"name"];//NSLog(@"hi 6");
	[coder encodeObject:_UUID forKey:@"UUID"];//NSLog(@"hi 7");	
    [coder encodeBool:_noticeInRange forKey:@"must_notice_in_range"];
    [coder encodeBool:_noticeOutRange forKey:@"must_notice_out_range"];
    [coder encodeInt:_setupDistance forKey:@"setup_Distance"];
}

- (void) dealloc
{
    self.name = nil;
    self.UUID = nil;
    
    [super dealloc];
}

//#pragma mark - NSCopying
//- (id)copyWithZone:(NSZone *)zone
//{
//    return [self retain];
//}

@end
