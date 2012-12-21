//
//  Constants.m
//  MasterLocking
//
//  Created by Phien Tram on 11/15/12.
//  Copyright (c) 2012 Golden Key. All rights reserved.
//

#import "Constants.h"

@implementation Constants

//const NSString *kUserDefaultsStoredDeviceUUID   = @"UserDefaultsStoredDeviceUUIDKey";
//const NSString *kUserDefaultsMaxLockDistance    = @"UserDefaultsMaxLockDistance";
//const NSString *kUserDefaultsLocationLatitude   = @"UserDefaultsLocationLatitude";
//const NSString *kUserDefaultsLocationLongitude  =@"UserDefaultsLocationLongitude";
//const NSString *kUserDefaultsLoginUsername = @"UserDefaultsLoginUsername";
//const NSString *kUserDefaultsLoginPassword = @"UserDefaultsLoginPassword";
//
////const NSString *kUserDefaultsFlag = @"UserDefaultsFlag";
//const NSString *kUserDefaultsIsAlreadyLogined = @"UserDefaultsIsAlreadyLogined";
//const NSString *kUserDefaultsKey = @"UserDefaultsKey";
//

const NSTimeInterval kRefreshViewsInterval          = 2; //2s

const NSTimeInterval kScanInterval                = 0.1;//0.1; // 100 ms
const NSTimeInterval kConnectionInterval        = 0.02; //20 ms
const NSTimeInterval kConnectionTimeout         = 5; //5 s
const NSTimeInterval kReadRSSIInterval          = 0.02;//20 ms
const NSTimeInterval kAverageRSSI                 = kRefreshViewsInterval; //2 s

const NSString *kUsersStickedObjectList = @"User's devices list";
const NSString *kUUIDsList = @"UUIDs list";

@end
