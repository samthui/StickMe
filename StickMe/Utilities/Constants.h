//
//  Constants.h
//  MasterLocking
//
//  Created by Phien Tram on 11/15/12.
//  Copyright (c) 2012 Golden Key. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern const NSString *kUserDefaultsStoredDeviceUUID;
extern NSString *kUserDefaultsMaxLockDistance;
extern NSString *kUserDefaultsLocationLatitude;
extern NSString *kUserDefaultsLocationLongitude;

extern NSString *kUserDefaultsLoginUsername;
extern NSString *kUserDefaultsLoginPassword;

//extern NSString *kUserDefaultsFlag;
extern NSString *kUserDefaultsIsAlreadyLogined;

extern NSString *kUserDefaultsKey;

extern const NSTimeInterval kConnectionInterval;
extern const NSTimeInterval kConnectionTimeout;

@end
