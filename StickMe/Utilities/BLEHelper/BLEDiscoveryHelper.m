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
#import "Utilities.h"

#import "AppDelegate.h"
#import "StickObject.h"
#import "StickObjectSummary.h"


static BLEDiscoveryHelper *shareBLEDiscoveryHelper = nil;

@interface BLEDiscoveryHelper () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
//    int currentCommand;
//    
//    BOOL isFirstLostConnection;
    
    NSMutableArray* _inRangeDevices;
}

@property (nonatomic, retain) NSTimer *timeoutToStopTimer;
@property (nonatomic, retain) NSTimer *reScanTimer;
@property (nonatomic, retain) NSTimer *wakeupTimer;

@property (nonatomic, retain) NSMutableArray* inRangeDevices;

-(void) reScan;

@end

@implementation BLEDiscoveryHelper
@synthesize wakeupTimer = _wakeupTimer;
@synthesize timeoutToStopTimer = _timeoutToStopTimer;
@synthesize reScanTimer = _reScanTimer;

//@synthesize foundPeripherals = _foundPeripherals;
@synthesize inRangeDevices = _inRangeDevices;
@synthesize discoveredStickedObjectsList = _discoveredStickedObjectsList;

@synthesize centralManager = centralManager;

@synthesize BLEDiscoveryHelperDelegate = _BLEDiscoveryHelperDelegate;

const NSString *kLockingServiceEnteredBackgroundNotification = @"LockingServiceEnteredBackgroundNotification";
const NSString *kLockingServiceEnteredForegroundNotification = @"LockingServiceEnteredForegroundNotification";

//@synthesize readCharacteristic, writeCharacteristic;

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
//        currentCommand = k_command_wakeup;
//		_foundPeripherals = [[NSMutableArray alloc] init];
        _inRangeDevices = [NSMutableArray new];
        _discoveredStickedObjectsList = [NSMutableArray new];
    }
    return self;
}

-(void)dealloc
{
    self.BLEDiscoveryHelperDelegate = nil;
    [self.centralManager release];
//    self.foundPeripherals = nil;
    self.discoveredStickedObjectsList = nil;
    
    if (self.timeoutToStopTimer) {
        if ([_timeoutToStopTimer isValid]) {
            [_timeoutToStopTimer invalidate];
        }
        self.timeoutToStopTimer = nil;
    } 
    
    if (self.reScanTimer) {
        if ([_reScanTimer isValid]) {
            [_reScanTimer invalidate];
        }
        self.reScanTimer = nil;
    } 
    
    if (self.wakeupTimer) {
        if ([_wakeupTimer isValid]) {
            [_wakeupTimer invalidate];
        }
        self.wakeupTimer = nil;
    }
    
    [super dealloc];
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
//- (void) loadSavedDevice
//{
//	NSString *deviceUUIDString	= [UserDefaultsHelper getStoredDeviceUUID];
//    
//	if (deviceUUIDString == nil) {
//        NSLog(@"No stored array to load");
//        return;
//    }
//    
//    CFUUIDRef uuid = CFUUIDCreateFromString(NULL, (CFStringRef)deviceUUIDString);
//    if (uuid != NULL) {
//        [centralManager retrievePeripherals:[NSArray arrayWithObject:(id)uuid]];
//    }
//    CFRelease(uuid);
//}
//
- (void) removeSavedDevice:(CFUUIDRef) uuid
{
//	NSString *deviceUUIDString	= [UserDefaultsHelper getStoredDeviceUUID];
//    if (deviceUUIDString == nil) {
//        NSLog(@"No stored array to load");
//        return;
//    }
//    
//    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
//    if (uuidString) {
//        if ([[UserDefaultsHelper getStoredDeviceUUID] isEqualToString:(NSString *)uuidString]) {
//            [UserDefaultsHelper setStoredDeviceUUID:@""];
//        }
//        CFRelease(uuidString);
//    }
}
//
//- (void)saveDevice:(CFUUIDRef) uuid
//{
//    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
//    if (uuidString) {
//        [UserDefaultsHelper setStoredDeviceUUID:(NSString *)uuidString];
//        CFRelease(uuidString);
//    }
//}

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

/*samthui7*/
- (void)writeValueForCommand:(int)command toPeripheral:(CBPeripheral*)peripheral
{
//    if (peripheral==nil || peripheral.readCharacteristic==nil || peripheral.writeCharacteristic==nil) {
//        NSLog(@"peripheral or characteristic is null");
//        [self startScanning]; //retry to scan
//        return;
//    }
//
//    unsigned char byteData[IO_CHARACTERISTIC_LENGTH];
//    [peripheral.readCharacteristic.value getBytes:&byteData length:IO_CHARACTERISTIC_LENGTH];
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
//    generatedData[0] = (generatedData[0] & 0xFC) | command;
//
//    //try to send command
//    NSData *data = [NSData dataWithBytes:generatedData length:IO_CHARACTERISTIC_LENGTH];
//    [peripheral writeValue:data forCharacteristic:peripheral.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

/*samthui7*/
- (void)writeValueForCommand:(int)command toStickObject:(StickObject *)stick
{
    if (stick.peripheral==nil || stick.readCharacteristic==nil || stick.writeCharacteristic==nil) {
        NSLog(@"peripheral or characteristic is null");
//        [self startScanning]; //retry to scan
        return;
    }
    
    unsigned char byteData[IO_CHARACTERISTIC_LENGTH];
    [stick.readCharacteristic.value getBytes:&byteData length:IO_CHARACTERISTIC_LENGTH];
    
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
    [stick.peripheral writeValue:data forCharacteristic:stick.writeCharacteristic type:CBCharacteristicWriteWithResponse];
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
-(void) reScan
{
//    NSLog(@"reScan");
    [self stopScanning];
    
    [self startScanning];
}

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
//    self.timeoutToStopTimer = [NSTimer scheduledTimerWithTimeInterval:kScanInterval target:self selector:@selector(stopScanning) userInfo:nil repeats:NO];
    
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
    
    //stopTimer??
//    self.timeoutToStopTimer = [NSTimer scheduledTimerWithTimeInterval:kScanInterval target:self selector:@selector(stopScanning) userInfo:nil repeats:NO];
    
    if (self.reScanTimer) {
        if ([_reScanTimer isValid]) {
            [_reScanTimer invalidate];
        }
    }
    self.reScanTimer = [NSTimer scheduledTimerWithTimeInterval:kScanInterval target:self selector:@selector(reScan) userInfo:nil repeats:NO];
    
    //start scanning
	[centralManager scanForPeripheralsWithServices:nil options:options];
}

- (void) stopScanning
{
	[centralManager stopScan];
}

- (void)sendCommand:(int)command
{
//    currentCommand = command;
//    [self writeValueForCommand];
//    switch (command) {
//        case k_command_lock:
//        {
//            [self stopAutoUnlock];
//        }
//            break;
//        case k_command_unlock:
//        {
//            [self startAutoUnlock];
//        }
//            break;
//        default:
//            break;
//    }
}

/*samthui7*/
- (void)sendCommand:(int)command toPeripheral:(CBPeripheral *)peripheral
{
    [self writeValueForCommand:command toPeripheral:peripheral];
}

/*samthui7*/
- (void)sendCommand:(int)command toStickObject:(StickObject *)stick
{
    [self writeValueForCommand:command toStickObject:stick];
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
//    if ([_wakeupTimer isValid]) {
//        [_wakeupTimer invalidate];
//    }
//    self.wakeupTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendAutoUnlockCommand) userInfo:nil repeats:YES];
}

- (void)stopAutoUnlock
{
//    if ([_wakeupTimer isValid]) {
//        [_wakeupTimer invalidate];
//    }
}

//samthui7
-(void) checkOutOfRangeDevices
{
    NSMutableArray* outRangeDevices = [NSMutableArray array];
    
    int index = 0;
    
    NSMutableArray* UUIDsList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    for(StickObject* stick in self.discoveredStickedObjectsList)
    {
        NSString* stickUUID = [Utilities UUIDofPeripheral:stick.peripheral];
        if (![self.inRangeDevices containsObject:stickUUID]) {
            [outRangeDevices addObject:stick];
//            NSLog(@"out %i", index);
            
            //re-order
            StickObjectSummary* tempStickSummary = [[UUIDsList objectAtIndex:index] retain];
            [UUIDsList removeObjectAtIndex:index];
            [UUIDsList insertObject:tempStickSummary atIndex:0];
            [tempStickSummary release];
        }
        index ++;
    }
    //save to NSUserDefault 
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:UUIDsList] forKey:(NSString*)kUUIDsList];
    [userDefault synchronize]; 
    
//    NSLog(@"discovered 1: %i", self.discoveredStickedObjectsList.count);
    [self.discoveredStickedObjectsList removeObjectsInArray:(NSArray*)outRangeDevices];
//    NSLog(@"discovered 2: %i", self.discoveredStickedObjectsList.count);
    
    if (self.BLEDiscoveryHelperDelegate && [_BLEDiscoveryHelperDelegate respondsToSelector:@selector(discoveryDidRefresh)]) {
        [_BLEDiscoveryHelperDelegate discoveryDidRefresh];
    }
    
    self.inRangeDevices = [NSMutableArray array];
}

-(void) addToInRangeDevicesList:(NSString *)UUID
{
    if (![self.inRangeDevices containsObject:UUID]) {
        [self.inRangeDevices addObject:UUID];
    }
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
//            self.foundPeripherals = nil;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:(NSString*)kUsersStickedObjectList];
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
			NSLog(@"PoweredOn");
//            [self loadSavedDevice];
//			[centralManager retrieveConnectedPeripherals];
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
//            self.foundPeripherals = nil;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:(NSString*)kUsersStickedObjectList];
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

/*samthui7*/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    NSLog(@"Advert:%@", advertisementData);
//    CBUUID *uuid = [[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0];
//    NSLog(@"uuid:%@", uuid.description);
    NSString* pUUID = [Utilities UUIDofPeripheral:peripheral];
//    NSLog(@"pUUID:%@", pUUID);  
    
    //save to inRangeDevices list
    [self addToInRangeDevicesList:pUUID];
    
    //save to NSUserDefault 
     NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray* UUIDsList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    BOOL existed = NO;
    int index;
    StickObjectSummary* seekStickObjectSummary;
    for (index = 0; index < UUIDsList.count; index++) {
        seekStickObjectSummary = (StickObjectSummary*)[UUIDsList objectAtIndex:index];
//        NSLog(@"seek: %@", seekStickObjectSummary.UUID);
        if ([seekStickObjectSummary.UUID isEqual:pUUID]) {
            existed = YES;
            break;
        }
    }
    if (!existed) {
//        NSLog(@"not existed :D ^^");
        StickObjectSummary* newItem = [[StickObjectSummary alloc] init];
        newItem.name = [NSString stringWithFormat:@"NoName %i", UUIDsList.count];
        newItem.UUID = pUUID;
        [UUIDsList addObject:newItem];
        [newItem release];
        
        StickObject* stick = [[StickObject alloc] initWithPeripheral:peripheral];
        stick.range = [Utilities convertToRangeDistanceFromRSSI:[RSSI intValue]];
//        NSLog(@"range 1: %@", NSStringFromRange(stick.range));
        stick.currentDistance = [RSSI intValue];
        [_discoveredStickedObjectsList addObject:stick];
        [stick release]; 
    }
    else {
        //Update this founded object and put it at top of 2 arrays DiscoveredStickedObject + UUIDsList
        
//        NSLog(@"found at index: %i!!!", index);
        
        BOOL existed = NO;
        for (int i = 0; i < _discoveredStickedObjectsList.count; i++) {
            StickObject* stick = (StickObject*)[_discoveredStickedObjectsList objectAtIndex:i];
            NSString* tempUUID = [Utilities UUIDofPeripheral:stick.peripheral];
            if ([tempUUID isEqual:pUUID]) {
                existed = YES;
                 
                if (!stick.RSSIsArray) {
                    stick.RSSIsArray = [NSMutableArray array];
                }
                [stick.RSSIsArray addObject:RSSI];
                break;
            }
        }
        if (!existed) {            
//            NSLog(@"not discovered yet");
            StickObject* stick = [[StickObject alloc] initWithPeripheral:peripheral];
            stick.range = [Utilities convertToRangeDistanceFromRSSI:[RSSI intValue]];
//            NSLog(@"range 2: %@", NSStringFromRange(stick.range));
            stick.currentDistance = [RSSI intValue];
            
            [_discoveredStickedObjectsList insertObject:stick atIndex:0];
            [stick release];
            
            
            //re-order
            StickObjectSummary* tempStickSummary = [[UUIDsList objectAtIndex:index] retain];
            [UUIDsList removeObjectAtIndex:index];
            [UUIDsList insertObject:tempStickSummary atIndex:0];
            [tempStickSummary release];  
        }   
        else {
            return;
        }
    }
    
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:UUIDsList] forKey:(NSString*)kUUIDsList];
    [userDefault synchronize];    
    
    if (self.BLEDiscoveryHelperDelegate && [_BLEDiscoveryHelperDelegate respondsToSelector:@selector(discoveryDidRefresh)]) {
        [_BLEDiscoveryHelperDelegate discoveryDidRefresh];
    }
}

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrieveConnectedPeripherals");
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
    NSLog(@"didConnectPeripheral");
    NSLog(@"pUUID: %@", (NSString*)peripheral.UUID);
    NSArray	*serviceArray	= [NSArray arrayWithObjects:
                               [CBUUID UUIDWithString:LOCK_SERVICE_UUID],
                               nil];
    
    [peripheral discoverServices:serviceArray];
    
    int index;
    for (index = 0; index < _discoveredStickedObjectsList.count; index++) {
        StickObject* stick = (StickObject*)[_discoveredStickedObjectsList objectAtIndex:index];
        if ([stick.peripheral isEqual:peripheral]) {
//            [Utilities createStoredRSSIFile];
            //            NSLog(@"found disconnect");
            [stick connectPeripheral];
            break;
        }
    }
    
    [_BLEDiscoveryHelperDelegate discoveryDidRefresh];
}

/*samthui7*/
- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    self.foundPeripherals = nil;
    NSLog(@"didDisconnectPeripheral");
//    [_BLEDiscoveryHelperDelegate discoveryDidRefresh];
    int index;
    for (index = 0; index < _discoveredStickedObjectsList.count; index++) {
        StickObject* stick = (StickObject*)[_discoveredStickedObjectsList objectAtIndex:index];
        if ([stick.peripheral isEqual:peripheral]) {
//            [Utilities createStoredRSSIFile];
//            NSLog(@"found disconnect");
            [stick cancelConnection];
            break;
        }
    }
    if (self.BLEDiscoveryHelperDelegate && [_BLEDiscoveryHelperDelegate respondsToSelector:@selector(updateStickedObjectAtIndex:)]) {
        [_BLEDiscoveryHelperDelegate updateStickedObjectAtIndex:index];
    }
}

-(void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral");
//    int index;
//    for (index = 0; index < _discoveredStickedObjectsList.count; index++) {
//        StickObject* stick = (StickObject*)[_discoveredStickedObjectsList objectAtIndex:index];
//        if ([stick.peripheral isEqual:peripheral]) {
//            //            NSLog(@"found disconnect");
//            break;
//        }
//    }
//    if (self.BLEDiscoveryHelperDelegate && [_BLEDiscoveryHelperDelegate respondsToSelector:@selector(updateStickedObjectAtIndex:)])
//    {
//        [_BLEDiscoveryHelperDelegate updateStickedObjectAtIndex:index];
//    }
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrievePeripherals");
}

@end
