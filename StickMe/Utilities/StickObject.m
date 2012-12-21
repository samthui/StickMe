//
//  StickObject.m
//  StickMe
//
//  Created by admin on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StickObject.h"

#import "Defines.h"
#import "Constants.h"
#import "BLEDiscoveryHelper.h"
#import "Utilities.h"

#define NUMB_SAMPLES 2

@interface StickObject ()
{
    NSTimer* _averageRSSITimer;
//    NSTimer* _readRSSITimer;
    unsigned int _counterReadRSSI;
//    NSMutableArray* _RSSIsArray;
}

@property (nonatomic, retain) NSTimer* cancelConnectionTimer;
//@property (nonatomic, retain) NSTimer* readRSSITimer;
@property (nonatomic, retain) NSTimer* averageRSSITimer;

-(void) cancelConnectionByTimer;

//-(void) averageRSSI;

@end

@implementation StickObject

@synthesize peripheral = _peripheral;
@synthesize readCharacteristic = _readCharacteristic;
@synthesize writeCharacteristic = _writeCharacteristic;
@synthesize isBlinking = _isBlinking;
@synthesize isRinging = _isRinging;
@synthesize range = _range;
@synthesize currentDistance = _currentDistance;
@synthesize setupDistance = _setupDistance;

@synthesize cancelConnectionTimer = _cancelConnectionTimer;
//@synthesize readRSSITimer = _readRSSITimer;
@synthesize averageRSSITimer = _averageRSSITimer;

@synthesize RSSIsArray = _RSSIsArray;

-(id) initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        self.peripheral = peripheral;
        [_peripheral setDelegate:self];
        _readCharacteristic = nil;
        _writeCharacteristic = nil;
        _isBlinking = NO;
        _isRinging = NO;
        _range = NSMakeRange(NSNotFound, 0);
        _currentDistance = 0;
        _setupDistance = 50;
        _counterReadRSSI = 0;
        
        _RSSIsArray = [[NSMutableArray array] retain];
        
        //start readRSSI
//        self.readRSSITimer = [NSTimer scheduledTimerWithTimeInterval:kReadRSSIInterval target:self.peripheral selector:@selector(readRSSI) userInfo:nil repeats:YES];        
        
        //start readRSSI
//        self.averageRSSITimer = [NSTimer scheduledTimerWithTimeInterval:kAverageRSSI target:self selector:@selector(averageRSSI) userInfo:nil repeats:YES];
    }
    return self;
}

-(void) dealloc
{
    _peripheral.delegate = nil;
    self.peripheral = nil;
    self.readCharacteristic = nil;
    self.writeCharacteristic = nil;

    if(self.cancelConnectionTimer){
        if([_cancelConnectionTimer isValid]){
            [_cancelConnectionTimer invalidate];
        }
    }
    self.cancelConnectionTimer = nil;

//    if (self.readRSSITimer) {
//        if ([_readRSSITimer isValid]) {
//            [_readRSSITimer invalidate];
//        }
//    }
//    self.readRSSITimer = nil;
    
    if (_RSSIsArray) {
        [_RSSIsArray release];
    }
    _RSSIsArray = nil;

    [super dealloc];
}

#pragma mark - public methods CBPeripheralDelegate
-(void) sendCommand:(int)command
{
    if (self.peripheral && [_peripheral isConnected]) {
        [(BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance] sendCommand:command toStickObject:self];
    }
}

-(void) connectPeripheral
{
//    NSLog(@"connect");
    [(BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance] connectPeripheral:self.peripheral];
    
    //fire cancelConnectTimer
    if (self.cancelConnectionTimer) {
        if ([_cancelConnectionTimer isValid]) {
            [_cancelConnectionTimer invalidate];
        }
    }    
    self.cancelConnectionTimer = [NSTimer scheduledTimerWithTimeInterval:kConnectionTimeout target:self selector:@selector(cancelConnectionByTimer) userInfo:nil repeats:NO];

    //start readRSSI
//    if (self.readRSSITimer) {
//        if ([_readRSSITimer isValid]) {
//            [_readRSSITimer invalidate];
//        }
//    }
//    self.readRSSITimer = [NSTimer scheduledTimerWithTimeInterval:kReadRSSIInterval target:self.peripheral selector:@selector(readRSSI) userInfo:nil repeats:YES];
}

-(void) cancelConnection
{
//    NSLog(@"cancelConnection");  
    
    [(BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance] disconnectPeripheral:self.peripheral];
    
//    if (self.readRSSITimer) {
//        if ([_readRSSITimer isValid]) {
//            [_readRSSITimer invalidate];
//        }
//        self.readRSSITimer = nil;
//    }
}

#pragma mark - private methods
-(void) cancelConnectionByTimer
{
//    NSLog(@"cancelConnectionByTimer");
    if (![self.peripheral isConnected]){  
//        NSLog(@"timeOut!!!!!");  
        [(BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance] disconnectPeripheral:self.peripheral];
        
//        if (self.readRSSITimer) {
//            if ([_readRSSITimer isValid]) {
//                [_readRSSITimer invalidate];
//            }
//            self.readRSSITimer = nil;
//        }
    } 
}

-(void) averageRSSI
{
    int averageRSSI = [Utilities averageOfInts:_RSSIsArray];
    self.range = [Utilities convertToRangeDistanceFromRSSI:averageRSSI];
    self.currentDistance = averageRSSI;
//    NSLog(@"average : %i", averageRSSI);
    
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    [BLEDiscover.BLEDiscoveryHelperDelegate discoveryDidRefresh];
    
    //reset array
    [_RSSIsArray release];
    _RSSIsArray = [[NSMutableArray array] retain];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"++ didDiscoverServices");
    if (error) {
        NSLog(@"Error:%@", [error description]);
    }
    NSArray *services = peripheral.services;
    if ([services count] > 0) {
        for (CBService *service in services) {
//            NSLog(@"serviceUUID:%@", [service.UUID description]);
            if ([service.UUID isEqual:[CBUUID UUIDWithString:LOCK_SERVICE_UUID]]) {
//                NSLog(@"had LockService");
                [peripheral discoverCharacteristics:service.characteristics forService:service];
                break;
            }
        }
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"++ didDiscoverCharacteristicsForService");
    NSArray *characteristics = service.characteristics;
    if ([characteristics count] > 0) {
        for (CBCharacteristic *characteristic in characteristics) {
//            NSData *data = characteristic.value;
//            NSLog(@"=====didDiscoverCharacteristicsForService read=====");
//            NSLog(@"%@:%@", [characteristic.UUID description], [data description]);
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:READ_CHARACTERISTIC_UUID]]) {
                //                self.readCharacteristic = characteristic;
                self.readCharacteristic = characteristic;
                //read character at uuid 0xFFF1
                [peripheral readValueForCharacteristic:characteristic];
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRITE_CHARACTERISTIC_UUID]]) {
//                NSLog(@"=====didDiscoverCharacteristicsForService write=====");
                //                self.writeCharacteristic = characteristic;
                self.writeCharacteristic = characteristic;
            }
        }
    }
}

/*samthui7*/
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"++ didUpdateValueForCharacteristic");
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:READ_CHARACTERISTIC_UUID]]) {
        //        [self writeValueForCommand];
        //        [self writeValueForCommand:k_command_lock toPeripheral:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
NSLog(@"++ didWriteValueForCharacteristic");
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRITE_CHARACTERISTIC_UUID]]) {
        if (error) {
            NSLog(@"%@", [error description]);
            
        } else {
        }
        unsigned char byteData[IO_CHARACTERISTIC_LENGTH];
        [characteristic.value getBytes:&byteData length:IO_CHARACTERISTIC_LENGTH];
        NSLog(@"%s", byteData);
    }
}

//-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
//{
//    NSLog(@"++ peripheralDidUpdateRSSI: %i", [peripheral.RSSI intValue]);
//    
//    //write to file
//    [Utilities addData:[NSString stringWithFormat:@"RSSI: %i", [peripheral.RSSI intValue]]];
//    
//    if (error) {
//        NSLog(@"%@", [error description]);
//    }else {
//        self.range = [Utilities convertToRangeDistanceFromRSSI:[peripheral.RSSI intValue]];
//        NSLog(@"range 3: %@", NSStringFromRange(self.range));
//        self.currentDistance = [peripheral.RSSI intValue];
//        
//        BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
//        [BLEDiscover.BLEDiscoveryHelperDelegate discoveryDidRefresh];
//    }
//}

//-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
//{
////    NSLog(@"++ peripheralDidUpdateRSSI: %i", [peripheral.RSSI intValue]);    
//    
//    if (error) {
////        NSLog(@"%@", [error description]);
//    }else {
//        if (_counterReadRSSI <= NUMB_SAMPLES) {
//            _counterReadRSSI ++;
////            NSLog(@"+++");
//        }
//        else {
//            _counterReadRSSI = 0;
//            
////            self.range = [Utilities convertToRangeDistanceFromRSSI:[peripheral.RSSI intValue]];
////            NSLog(@"range 3: %@", NSStringFromRange(self.range));
////            self.currentDistance = [peripheral.RSSI intValue];
//            int averageRSSI = [Utilities averageOfInts:_RSSIsArray];
//            self.range = [Utilities convertToRangeDistanceFromRSSI:averageRSSI];
//            self.currentDistance = averageRSSI;
////            NSLog(@"average 2: %i", averageRSSI);
//            
//            BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
//            [BLEDiscover.BLEDiscoveryHelperDelegate discoveryDidRefresh];
//            
//            //reset array
//            [_RSSIsArray release];
//            _RSSIsArray = [[NSMutableArray array] retain];;
//        }
//        
//        NSNumber* RSSI = [NSNumber numberWithInt:[peripheral.RSSI intValue]];
//        [_RSSIsArray addObject:RSSI];
//        
//        //write to file
//        [Utilities addData:[NSString stringWithFormat:@"RSSI: %i", [peripheral.RSSI intValue]]];
//    }
//}


-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //write to file
    [Utilities addData:[NSString stringWithFormat:@"RSSI: %i", [peripheral.RSSI intValue]]];
    //    NSLog(@"++ peripheralDidUpdateRSSI: %i", [peripheral.RSSI intValue]);   
    [[BLEDiscoveryHelper sharedInstance] addToInRangeDevicesList:[Utilities UUIDofPeripheral:peripheral]];
    
    if (error) {
        //        NSLog(@"%@", [error description]);
    }else {        
        [_RSSIsArray addObject:peripheral.RSSI];
        
        //write to file
//        [Utilities addData:[NSString stringWithFormat:@"RSSI: %i", [peripheral.RSSI intValue]]];
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
NSLog(@"++ didWriteValueForDescriptor");
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
NSLog(@"++ didUpdateValueForDescriptor");
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
NSLog(@"++ didUpdateNotificationStateForCharacteristic");
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
NSLog(@"++ didDiscoverIncludedServicesForService");
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
NSLog(@"++ didDiscoverDescriptorsForCharacteristic");
}

@end
