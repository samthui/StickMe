//
//  BLEDiscoveryHelper.m
//  MasterLocking
//
//  Created by Phien Tram on 11/15/12.
//  Copyright (c) 2012 Golden Key. All rights reserved.
//

#import "BLEDiscoveryHelper.h"

#import "UserDefaultsHelper.h"
#import "Constants.h"
#import "Defines.h"

#import "AppDelegate.h"


static BLEDiscoveryHelper *shareBLEDiscoveryHelper = nil;

@interface BLEDiscoveryHelper () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
//	CBCentralManager    *centralManager;
    CBCharacteristic *readCharacteristic;
    CBCharacteristic *writeCharacteristic;
    int currentCommand;
    
    BOOL isFirstLostConnection;
}

@property (nonatomic, retain) NSTimer *timeoutToStopTimer;
@property (nonatomic, retain) CBCharacteristic *readCharacteristic;
@property (nonatomic, retain) CBCharacteristic *writeCharacteristic;
@property (nonatomic, retain) NSTimer *wakeupTimer;

@end

@implementation BLEDiscoveryHelper
@synthesize wakeupTimer = _wakeupTimer;
@synthesize timeoutToStopTimer = _timeoutToStopTimer;
//@synthesize foundPeripheral = _foundPeripheral;
@synthesize foundPeripherals = _foundPeripherals;

@synthesize centralManager = centralManager;

@synthesize BLEDiscoveryHelperDelegate = _BLEDiscoveryHelperDelegate;

const NSString *kLockingServiceEnteredBackgroundNotification = @"LockingServiceEnteredBackgroundNotification";
const NSString *kLockingServiceEnteredForegroundNotification = @"LockingServiceEnteredForegroundNotification";

@synthesize readCharacteristic, writeCharacteristic;

+ (id)sharedInstance
{
    @synchronized(self) {
        if (shareBLEDiscoveryHelper == nil) {
            shareBLEDiscoveryHelper = [[super allocWithZone:NULL] init];
        }
    }
    return shareBLEDiscoveryHelper;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release
{
    // never release
}

- (id)autorelease
{
    return self;
}

- (id)init
{
    if (self = [super init]) {
        //custom initialization.
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        currentCommand = k_command_wakeup;
		_foundPeripherals = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Handle background/foreground notification

- (void)enteredBackground
{
    NSLog(@"BLE:enteredBackground");
//    // Find the fishtank service
//    for (CBService *service in [_foundPeripheral services]) {
//        if ([[service UUID] isEqual:[CBUUID UUIDWithString:LOCK_SERVICE_UUID]]) {
//            // Find the lock characteristic
//            for (CBCharacteristic *characteristic in [service characteristics]) {
//                if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:READ_CHARACTERISTIC_UUID]]) {
//                    if (![_wakeupTimer isValid]) {
//                        [self startAutoUnlock];
//                    }
//                }
//            }
//        }
//    }
}

- (void)enteredForeground
{
    NSLog(@"BLE:enteredForeground");
//    // Find the fishtank service
//    for (CBService *service in [_foundPeripheral services]) {
//        if ([[service UUID] isEqual:[CBUUID UUIDWithString:LOCK_SERVICE_UUID]]) {
//            // Find the lock characteristic
//            for (CBCharacteristic *characteristic in [service characteristics]) {
//                if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:READ_CHARACTERISTIC_UUID]]) {
//                     
//                }
//            }
//        }
//    }
}

#pragma mark - Private methods

// Restoring
- (void) loadSavedDevice
{
	NSString *deviceUUIDString	= [UserDefaultsHelper getStoredDeviceUUID];
    
	if (deviceUUIDString == nil) {
        NSLog(@"No stored array to load");
        return;
    }
    
    CFUUIDRef uuid = CFUUIDCreateFromString(NULL, (CFStringRef)deviceUUIDString);
    if (uuid != NULL) {
        [centralManager retrievePeripherals:[NSArray arrayWithObject:(id)uuid]];
    }
    CFRelease(uuid);
}

- (void) removeSavedDevice:(CFUUIDRef) uuid
{
	NSString *deviceUUIDString	= [UserDefaultsHelper getStoredDeviceUUID];
    if (deviceUUIDString == nil) {
        NSLog(@"No stored array to load");
        return;
    }
    
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    if (uuidString) {
        if ([[UserDefaultsHelper getStoredDeviceUUID] isEqualToString:(NSString *)uuidString]) {
            [UserDefaultsHelper setStoredDeviceUUID:@""];
        }
        CFRelease(uuidString);
    }
}

- (void)saveDevice:(CFUUIDRef) uuid
{
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    if (uuidString) {
        [UserDefaultsHelper setStoredDeviceUUID:(NSString *)uuidString];
        CFRelease(uuidString);
    }
}

- (void)writeValueForCommand
{
//    if (_foundPeripheral==nil || readCharacteristic==nil || writeCharacteristic==nil) {
//        NSLog(@"peripheral or characteristic is null");
//        [self startScanning]; //retry to scan
//        return;
//    }
//    /*
//     // generate password
//     password[0] = (character1value[0] * (character1value[3] >> (character1value[2] % 8))) % 256;
//     password[1] = (character1value[1] * (character1value[0] >> (character1value[3] % 8))) % 256;
//     password[2] = (character1value[2] * (character1value[1] >> (character1value[0] % 8))) % 256;
//     password[3] = (character1value[3] * (character1value[2] >> (character1value[1] % 8))) % 256;
//     
//     
//     phone_password[0] = password[0] ^ (~phone_key[0]);
//     phone_password[1] = password[1] ^ (~phone_key[1]);
//     phone_password[2] = password[2] ^ (~phone_key[2]);
//     phone_password[3] = password[3] ^ (~phone_key[3]);
//     
//     
//     phone_key[4] = {'1', '2', '3', '4'};
//     phone_pass[0] = (phone_pass[0] & 0xFC) | command
//     */
//    
//    unsigned char byteData[IO_CHARACTERISTIC_LENGTH];
//    [readCharacteristic.value getBytes:&byteData length:IO_CHARACTERISTIC_LENGTH];
//    
//    unsigned char generatedData[IO_CHARACTERISTIC_LENGTH];
//    generatedData[0] = (byteData[0] * (byteData[3] >> (byteData[2] % 8))) % 256;
//    generatedData[1] = (byteData[1] * (byteData[0] >> (byteData[3] % 8))) % 256;
//    generatedData[2] = (byteData[2] * (byteData[1] >> (byteData[0] % 8))) % 256;
//    generatedData[3] = (byteData[3] * (byteData[2] >> (byteData[1] % 8))) % 256;
//    
//    unsigned char phoneKey[4] = { 0x31, 0x32, 0x33, 0x34 };
//    
//    generatedData[0] = generatedData[0] ^ (~phoneKey[0]);
//    generatedData[1] = generatedData[1] ^ (~phoneKey[1]);
//    generatedData[2] = generatedData[2] ^ (~phoneKey[2]);
//    generatedData[3] = generatedData[3] ^ (~phoneKey[3]);
//
//    generatedData[0] = (generatedData[0] & 0xFC) | currentCommand;
//    
//    //try to send command
//    NSData *data = [NSData dataWithBytes:generatedData length:IO_CHARACTERISTIC_LENGTH];
//    [_foundPeripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)writeValueForCommand:(int)command toPeripheral:(CBPeripheral*)peripheral
{
//    if (_foundPeripheral==nil || readCharacteristic==nil || writeCharacteristic==nil) {
//        NSLog(@"peripheral or characteristic is null");
//        [self startScanning]; //retry to scan
//        return;
//    }

    unsigned char byteData[IO_CHARACTERISTIC_LENGTH];
    [readCharacteristic.value getBytes:&byteData length:IO_CHARACTERISTIC_LENGTH];

    unsigned char generatedData[IO_CHARACTERISTIC_LENGTH];
    generatedData[0] = (byteData[0] * (byteData[3] >> (byteData[2] % 8))) % 256;
    generatedData[1] = (byteData[1] * (byteData[0] >> (byteData[3] % 8))) % 256;
    generatedData[2] = (byteData[2] * (byteData[1] >> (byteData[0] % 8))) % 256;
    generatedData[3] = (byteData[3] * (byteData[2] >> (byteData[1] % 8))) % 256;

    unsigned char phoneKey[4] = { 0x31, 0x32, 0x33, 0x34 };

    generatedData[0] = generatedData[0] ^ (~phoneKey[0]);
    generatedData[1] = generatedData[1] ^ (~phoneKey[1]);
    generatedData[2] = generatedData[2] ^ (~phoneKey[2]);
    generatedData[3] = generatedData[3] ^ (~phoneKey[3]);

    generatedData[0] = (generatedData[0] & 0xFC) | command;

    //try to send command
    NSData *data = [NSData dataWithBytes:generatedData length:IO_CHARACTERISTIC_LENGTH];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)sendAutoUnlockCommand
{
    NSLog(@"sendAutoUnlockCommand");
//    CLLocation *oldLocation = [[CLLocation alloc] initWithLatitude:[UserDefaultsHelper getLocationLatitude] longitude:[UserDefaultsHelper getLocationLongitude]];
//    CGFloat distance = [ShareCurrentLocation distanceFromLocation:oldLocation];
//    if (distance < [UserDefaultsHelper getMaxLockDistance]) {
//        [self sendCommand:k_command_unlock];
//    }
//    [oldLocation release];
}

#pragma mark - Public methods

// Discovery
- (void) startScanningForUUIDString:(NSString *)uuidString
{
	NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    if ([_wakeupTimer isValid]) {
        [_wakeupTimer invalidate];
    }
    
    if ([self.timeoutToStopTimer isValid]) {
        [self.timeoutToStopTimer invalidate];
    }
//    self.timeoutToStopTimer = [NSTimer scheduledTimerWithTimeInterval:kConnectionTimeout target:self selector:@selector(stopScanning) userInfo:nil repeats:NO];
    
    //start scanning
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

- (void)startScanning
{
    NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    if ([_wakeupTimer isValid]) {
        [_wakeupTimer invalidate];
    }
    
    if ([self.timeoutToStopTimer isValid]) {
        [self.timeoutToStopTimer invalidate];
    }
    self.timeoutToStopTimer = [NSTimer scheduledTimerWithTimeInterval:kConnectionTimeout target:self selector:@selector(stopScanning) userInfo:nil repeats:NO];
    
    //start scanning
	[centralManager scanForPeripheralsWithServices:nil options:options];
}

- (void) stopScanning
{
	[centralManager stopScan];
}

- (void)sendCommand:(int)command
{
    currentCommand = command;
    [self writeValueForCommand];
    switch (command) {
        case k_command_lock:
        {
            [self stopAutoUnlock];
        }
            break;
        case k_command_unlock:
        {
            [self startAutoUnlock];
        }
            break;
        default:
            break;
    }
}

- (void)sendCommand:(int)command toPeripheral:(CBPeripheral *)peripheral
{
//    currentCommand = command;
    [self writeValueForCommand];
    switch (command) {
        case k_command_lock:
        {
            [self stopAutoUnlock];
        }
            break;
        case k_command_unlock:
        {
            [self startAutoUnlock];
        }
            break;
        default:
            break;
    }
}

// Connection/Disconnection
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
	if (![peripheral isConnected]) {
		[centralManager connectPeripheral:peripheral options:nil];
	}
}

- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
	[centralManager cancelPeripheralConnection:peripheral];
}

- (void) disconnectCurrentPeripheral
{
//    if (_foundPeripheral) {
//        [centralManager cancelPeripheralConnection:_foundPeripheral];
//    }
}

//auto lock/unlock
- (void)startAutoUnlock
{
    if ([_wakeupTimer isValid]) {
        [_wakeupTimer invalidate];
    }
    self.wakeupTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendAutoUnlockCommand) userInfo:nil repeats:YES];
}

- (void)stopAutoUnlock
{
    if ([_wakeupTimer isValid]) {
        [_wakeupTimer invalidate];
    }
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
//            self.foundPeripheral = nil;
            self.foundPeripherals = nil;
			NSLog(@"PoweredOff");
            break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			NSLog(@"Unauthorized");
            break;
		}
            
		case CBCentralManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
			NSLog(@"Unknown");
            break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
            [self loadSavedDevice];
			[centralManager retrieveConnectedPeripherals];
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
//            self.foundPeripheral = nil;
            self.foundPeripherals = nil;
			NSLog(@"Resetting");
            break;
		}
            
        default: //CBCentralManagerStateUnsupported
        {
            NSLog(@"Unsupported");
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Bluetooth" message:@"BLE is not supported for this device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease];
            [alertView show];
            break;
        }
	}
    
    previousState = [centralManager state];
}

//- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
//{
//    NSLog(@"Advert:%@", advertisementData);
//    CBUUID *uuid = [[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0];
//    NSLog(@"uuid:%@", uuid.description);
//    NSLog(@"pUUID:%@", (NSString *)peripheral.UUID);
//    if ([uuid isEqual:[CBUUID UUIDWithString:LOCK_SERVICE_UUID]]) {
//        if (self.foundPeripheral==nil) {
//            self.foundPeripheral = peripheral;
//            self.foundPeripheral.delegate = self;
//            [self saveDevice:peripheral.UUID];
//            [central connectPeripheral:peripheral options:nil];
//        }
//    }
//	
//}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Advert:%@", advertisementData);
    CBUUID *uuid = [[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0];
    NSLog(@"uuid:%@", uuid.description);
    NSLog(@"pUUID:%@", (NSString *)peripheral.UUID);
//    if ([uuid isEqual:[CBUUID UUIDWithString:LOCK_SERVICE_UUID]]) {
//        if (self.foundPeripheral==nil) {
//            self.foundPeripheral = peripheral;
//            self.foundPeripheral.delegate = self;
//            [self saveDevice:peripheral.UUID];
//            [central connectPeripheral:peripheral options:nil];
//        }
//    }
	
	if (![_foundPeripherals containsObject:peripheral]) {
		[_foundPeripherals addObject:peripheral];
		[_BLEDiscoveryHelperDelegate discoveryDidRefresh];
	}
}

#pragma mark - CBPeripheralDelegate

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
//	CBPeripheral	*peripheral;
//	
//	/* Add to list. */
//	for (peripheral in peripherals) {
//		if (self.foundPeripheral==nil) {
//            self.foundPeripheral = peripheral;
//            self.foundPeripheral.delegate = self;
//            [self saveDevice:peripheral.UUID];
//            [central connectPeripheral:peripheral options:nil];
//        }
//	}
}

- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
//	[central connectPeripheral:peripheral options:nil];
}


- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
	/* Nuke from plist. */
	[self removeSavedDevice:UUID];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSArray	*serviceArray	= [NSArray arrayWithObjects:
                               [CBUUID UUIDWithString:LOCK_SERVICE_UUID],
                               nil];
    
    [peripheral discoverServices:serviceArray];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error:%@", [error description]);
    }
    NSArray *services = peripheral.services;
    if ([services count] > 0) {
        for (CBService *service in services) {
            NSLog(@"serviceUUID:%@", [service.UUID description]);
            if ([service.UUID isEqual:[CBUUID UUIDWithString:LOCK_SERVICE_UUID]]) {
                [peripheral discoverCharacteristics:service.characteristics forService:service];
                break;
            }
        }
       
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSArray *characteristics = service.characteristics;
    if ([characteristics count] > 0) {
        NSArray *characteristics = service.characteristics;
        if ([characteristics count] > 0) {
            for (CBCharacteristic *characteristic in characteristics) {
                NSData *data = characteristic.value;
                NSLog(@"=====didDiscoverCharacteristicsForService read=====");
                NSLog(@"%@:%@", [characteristic.UUID description], [data description]);
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:READ_CHARACTERISTIC_UUID]]) {
                    self.readCharacteristic = characteristic;
                    //read character at uuid 0xFFF1
                    [peripheral readValueForCharacteristic:characteristic];
                } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRITE_CHARACTERISTIC_UUID]]) {
                    NSLog(@"=====didDiscoverCharacteristicsForService write=====");
                    self.writeCharacteristic = characteristic;
                }
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:READ_CHARACTERISTIC_UUID]]) {
        [self writeValueForCommand];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRITE_CHARACTERISTIC_UUID]]) {
        if (error) {
            NSLog(@"%@", [error description]);
            //maybe out of range, store location now
            if (isFirstLostConnection) {
                isFirstLostConnection = NO;
//                CLLocationCoordinate2D coordinate = ShareCoordinate;
//                [UserDefaultsHelper setLocationLatitude:coordinate.latitude];
//                [UserDefaultsHelper setLocationLongitude:coordinate.longitude];
//                
                //TODO: send lat/long to server now
                
            }
            
        } else {
            if (!isFirstLostConnection) {
                isFirstLostConnection = YES;
            }
        }
        unsigned char byteData[IO_CHARACTERISTIC_LENGTH];
        [characteristic.value getBytes:&byteData length:IO_CHARACTERISTIC_LENGTH];
        NSLog(@"%s", byteData);
    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    self.foundPeripheral = nil;
    self.foundPeripherals = nil;
    self.readCharacteristic = nil;
    self.writeCharacteristic = nil;
}

@end
