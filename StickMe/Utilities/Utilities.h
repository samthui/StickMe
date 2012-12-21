//
//  Utilities.h
//  StickMe
//
//  Created by admin on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define STEP_0_5m    1
#define RANGE_5m    5
#define STEP_5_20m    5
#define RANGE_20m    20
#define STEP_20_30m    10
#define RANGE_30m    30

@interface Utilities : NSObject
+(BOOL) randBool;

+(NSString*) UUIDfromCFUUID:(NSString*)CFUUID;
+(NSString*) UUIDofPeripheral:(CBPeripheral*)peripheral;

+(float) convertToDistanceFromRSSI:(int)RSSI;
+(NSString*) describeDistanceFromRSSI:(int)RSSI;
+(NSRange) convertToRangeDistanceFromRSSI:(int)RSSI;
+(NSString*) describeDistanceFromRange:(NSRange)range;

+(void) createStoredRSSIFile;
+(void) addData:(NSString*)data;

+(int) averageOfInts:(NSMutableArray*)integersArray;

@end
