//
//  Constants.m
//  MasterLocking
//
//  Created by Phien Tram on 11/15/12.
//  Copyright (c) 2012 Golden Key. All rights reserved.
//

#import "Constants.h"

@implementation Constants

const NSString *kUserDefaultsStoredDeviceUUID   = @"UserDefaultsStoredDeviceUUIDKey";
const NSString *kUserDefaultsMaxLockDistance    = @"UserDefaultsMaxLockDistance";
const NSString *kUserDefaultsLocationLatitude   = @"UserDefaultsLocationLatitude";
const NSString *kUserDefaultsLocationLongitude  =@"UserDefaultsLocationLongitude";
const NSString *kUserDefaultsLoginUsername = @"UserDefaultsLoginUsername";
const NSString *kUserDefaultsLoginPassword = @"UserDefaultsLoginPassword";

//const NSString *kUserDefaultsFlag = @"UserDefaultsFlag";
const NSString *kUserDefaultsIsAlreadyLogined = @"UserDefaultsIsAlreadyLogined";
const NSString *kUserDefaultsKey = @"UserDefaultsKey";

const NSTimeInterval kConnectionInterval    = 0.02; //20 ms
const NSTimeInterval kConnectionTimeout     = 0.1; //100 ms
@end
