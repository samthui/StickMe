//
//  StickObject.m
//  StickMe
//
//  Created by admin on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StickObject.h"

#import "Defines.h"
#import "BLEDiscoveryHelper.h"

@implementation StickObject

@synthesize peripheral = _peripheral;
@synthesize readCharacteristic = _readCharacteristic;
@synthesize writeCharacteristic = _writeCharacteristic;

-(id) initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        self.peripheral = peripheral;
        [_peripheral setDelegate:self];
    }
    return self;
}

-(void) dealloc
{
    _peripheral.delegate = nil;
    self.peripheral = nil;
    self.readCharacteristic = nil;
    self.writeCharacteristic = nil;
    
    [super dealloc];
}

#pragma mark - public methods CBPeripheralDelegate
-(void) sendCommand:(int)command
{
    if (self.peripheral && [_peripheral isConnected]) {
        [(BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance] sendCommand:command toStickObject:self];
    }
}

#pragma mark -


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"kekekeke didDiscoverServices");
    if (error) {
        NSLog(@"Error:%@", [error description]);
    }
    NSArray *services = peripheral.services;
    if ([services count] > 0) {
        for (CBService *service in services) {
            NSLog(@"serviceUUID:%@", [service.UUID description]);
            if ([service.UUID isEqual:[CBUUID UUIDWithString:LOCK_SERVICE_UUID]]) {
                NSLog(@"had LockService");
                [peripheral discoverCharacteristics:service.characteristics forService:service];
                break;
            }
        }
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"++ didDiscoverCharacteristicsForService ++");
    NSArray *characteristics = service.characteristics;
    if ([characteristics count] > 0) {
        for (CBCharacteristic *characteristic in characteristics) {
            NSData *data = characteristic.value;
            NSLog(@"=====didDiscoverCharacteristicsForService read=====");
            NSLog(@"%@:%@", [characteristic.UUID description], [data description]);
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:READ_CHARACTERISTIC_UUID]]) {
                //                self.readCharacteristic = characteristic;
                self.readCharacteristic = characteristic;
                //read character at uuid 0xFFF1
                [peripheral readValueForCharacteristic:characteristic];
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRITE_CHARACTERISTIC_UUID]]) {
                NSLog(@"=====didDiscoverCharacteristicsForService write=====");
                //                self.writeCharacteristic = characteristic;
                self.writeCharacteristic = characteristic;
            }
        }
    }
}

/*samthui7*/
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateValueForCharacteristic");
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:READ_CHARACTERISTIC_UUID]]) {
        //        [self writeValueForCommand];
        //        [self writeValueForCommand:k_command_lock toPeripheral:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
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

@end
