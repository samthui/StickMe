//
//  UserDefaultsHelper.h
//  MasterLocking
//
//  Created by Phien Tram on 11/15/12.
//  Copyright (c) 2012 Golden Key. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsHelper : NSObject

+ (NSString *)getStoredDeviceUUID;
+ (void)setStoredDeviceUUID:(NSString *)uuidString;

+ (NSInteger)getMaxLockDistance;
+ (void)setMaxLockDistance:(NSInteger)distance;

+ (CGFloat)getLocationLatitude;
+ (void)setLocationLatitude:(CGFloat)lat;
+ (CGFloat)getLocationLongitude;
+ (void)setLocationLongitude:(CGFloat)longitude;


+ (NSString *)getLoginUsername;
+ (void)setLoginUsername:(NSString *)usernameString;
+ (NSString *)getLoginPassword;
+ (void)setLoginPassword:(NSString *)passwordString;

//+ (NSString *)getFlag;
//+ (void)setFlag:(NSString *)flag;

+ (NSString *)getIsAlreadyLogined;
+ (void)setIsAlreadyLogined:(NSString *)isAlreadyLogined;

+ (NSString *)getKey;
+ (void)setKey:(NSString *)key;

@end
