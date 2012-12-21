//
//  Utilities.m
//  StickMe
//
//  Created by admin on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+(BOOL) randBool
{
    int tmp = (arc4random() % 30)+1;
    if(tmp % 5 == 0)
        return YES;
    return NO;
}

+(NSString*) UUIDfromCFUUID:(NSString*)CFUUID
{ 
    return [[CFUUID componentsSeparatedByString:@"> "] objectAtIndex:1];
}

+(NSString*) UUIDofPeripheral:(CBPeripheral *)peripheral
{
    NSString* pUUID = [NSString stringWithFormat:@"%@", (NSString*)peripheral.UUID];
    
    return [Utilities UUIDfromCFUUID:pUUID];
}

+(NSString*) describeDistanceFromRSSI:(int)RSSI
{
    NSString* distance;
    if (RSSI > -40) {
        distance = @"< 1m";
    }
    else if (RSSI > -46) {
        distance = @"1 - 2m";
    }
    else if (RSSI > -52) {
        distance = @"2 - 4m";
    }
    else if (RSSI > -58) {
        distance = @"4 - 8m";
    }
    else if (RSSI > -64) {
        distance = @"8 - 16m";
    }
    else  if (RSSI > -66){
        distance = @"> 16m";
    }
    else {
        distance = @"<>";
    }
    
    return distance;
}

//+(NSRange) convertToRangeDistanceFromRSSI:(int)RSSI
//{
//    NSRange range;
//    if (RSSI > -40) {
//        range = NSMakeRange(0, 1);
//    }
//    else if (RSSI > -46) {
//        range = NSMakeRange(1, 1);
//    }
//    else if (RSSI > -52) {
//        range = NSMakeRange(2, 2);
//    }
//    else if (RSSI > -58) {
//        range = NSMakeRange(4, 4);
//    }
//    else if (RSSI > -64) {
//        range = NSMakeRange(8, 8);
//    }
//    else if (RSSI > -66){
//        range = NSMakeRange(16, 16);
//    }
//    else {
//        range = NSMakeRange(NSNotFound, 0);
//    }
//    
//    return range;
//}

//+(NSRange)convertToRangeDistanceFromRSSI:(int)RSSI
//{
//    //formula: RSSI = a* (-log(d)) + b , with a~6.25 && b~-77
//    float a = 6.25;
//    int b = -77;
//    float delta = 0.5;
//    
//    NSRange range;
//    
//    int distance = pow(10, (float)(b - RSSI)/a);
//    range = NSMakeRange(distance - delta, 2*delta);
//    
//    return range;
//}

+(NSRange)convertToRangeDistanceFromRSSI:(int)RSSI
{
    NSRange range;
    
    if (RSSI > -62) {
        range = NSMakeRange(0, STEP_0_5m);
    }
    else if (RSSI > - 67) {
        range = NSMakeRange(1, STEP_0_5m);
    }
    else if (RSSI > - 72) {
        range = NSMakeRange(2, STEP_0_5m);
    }
    else if (RSSI > - 77) {
        range = NSMakeRange(3, STEP_0_5m);
    }
    else if (RSSI > - 82) {
        range = NSMakeRange(4, STEP_0_5m);
    }
    else {
        range = NSMakeRange(RANGE_5m, STEP_5_20m);
    }
    
    return range;
}

//+(NSString*) describeDistanceFromRange:(NSRange )range
//{
//    NSString* distance;
//    if (range.location == 0) {
//        distance = @"< 1m";
//    }
//    else if (range.location == 1) {
//        distance = @"1 - 2m";
//    }
//    else if (range.location == 2) {
//        distance = @"2 - 4m";
//    }
//    else if (range.location == 4) {
//        distance = @"4 - 8m";
//    }
//    else if (range.location == 8) {
//        distance = @"8 - 16m";
//    }
//    else if (range.location == 16){
//        distance = @"> 16m";
//    }
//    else {
//        distance = @"<>";
//    }
//    
//    return distance;
//}

+(NSString*) describeDistanceFromRange:(NSRange )range
{
    NSString* description = [NSString stringWithFormat:@"%i - %im", range.location, range.location + range.length];
    if (range.location == 5) {
        description = @"> 5m";
    }
//    NSLog(@"describeDistance %@", description);
    return description;
}

+(float) convertToDistanceFromRSSI:(int)RSSI
{
    float distance = 0.0;
    
    return distance;
}

+(void) createStoredRSSIFile
{  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"RSSI.txt"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        NSError* error;
        if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil])
        {// success
            if (![@"********************* hello *********************\n" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
                NSLog(@"ERROR: error write file %@", error);
            }
        }
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create file maybe out of disk space?");
        }
    }
    else {
        NSString* content = [NSString stringWithContentsOfFile:filePath
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        NSLog(@"%@", content);
        
        //        NSError* error;
        //        [@"********************* hello *********************\n" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[@"********************* hello *********************\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandler closeFile];
    }
}

+(void) addData:(NSString *)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"RSSI.txt"];
    
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[[NSString stringWithFormat:@"%@\n", data] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}

+(void) reScanTimer:(NSString *)data
{	
    [Utilities addData:data];
}

+(int)averageOfInts:(NSMutableArray *)integersArray
{
    int count = integersArray.count;
    
    double total = 0;
    for (int i = 0; i < count; i++) {
        float item = [[integersArray objectAtIndex:i] floatValue];
        
        total += item;
    }
    
    int result = total/count;
    return result;
}

@end
