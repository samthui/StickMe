//
//  UserDefaultsHelper.m
//  MasterLocking
//
//  Created by Phien Tram on 11/15/12.
//  Copyright (c) 2012 Golden Key. All rights reserved.
//

#import "UserDefaultsHelper.h"
#import "Constants.h"

@implementation UserDefaultsHelper


+ (NSString *)getStoredDeviceUUID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUserDefaultsStoredDeviceUUID];
}

+ (void)setStoredDeviceUUID:(NSString *)uuidString
{
    [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:(NSString *)kUserDefaultsStoredDeviceUUID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getMaxLockDistance
{
    CGFloat distance = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsMaxLockDistance];
    if (distance == NSNotFound) {
        distance = 15;
        [UserDefaultsHelper setMaxLockDistance:distance];
    }
    return distance;
}

+ (void)setMaxLockDistance:(NSInteger)distance
{
    [[NSUserDefaults standardUserDefaults] setInteger:distance forKey:kUserDefaultsMaxLockDistance];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)getLocationLatitude
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:kUserDefaultsLocationLatitude];
}

+ (void)setLocationLatitude:(CGFloat)lat
{
    [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:kUserDefaultsLocationLatitude];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)getLocationLongitude
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:kUserDefaultsLocationLongitude];
}

+ (void)setLocationLongitude:(CGFloat)longitude
{
    [[NSUserDefaults standardUserDefaults] setFloat:longitude forKey:kUserDefaultsLocationLongitude];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLoginUsername
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUserDefaultsLoginUsername];
}

+ (void)setLoginUsername:(NSString *)usernameString
{
    [[NSUserDefaults standardUserDefaults] setObject:usernameString forKey:(NSString *)kUserDefaultsLoginUsername];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLoginPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUserDefaultsLoginPassword];
}

+ (void)setLoginPassword:(NSString *)passwordString
{
    [[NSUserDefaults standardUserDefaults] setObject:passwordString forKey:(NSString *)kUserDefaultsLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*
 + (NSString *)getFlag
 {
 return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUserDefaultsFlag];
 }
 
 + (void)setFlag:(NSString *)flag
 {
 [[NSUserDefaults standardUserDefaults] setObject:flag forKey:(NSString *)kUserDefaultsFlag];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 */
+ (NSString *)getIsAlreadyLogined
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUserDefaultsIsAlreadyLogined];
}

+ (void)setIsAlreadyLogined:(NSString *)isAlreadyLogined
{
    [[NSUserDefaults standardUserDefaults] setObject:isAlreadyLogined forKey:kUserDefaultsIsAlreadyLogined];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kUserDefaultsKey];
}

+ (void)setKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:kUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
