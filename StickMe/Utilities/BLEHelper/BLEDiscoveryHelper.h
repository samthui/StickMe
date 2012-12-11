//
//  BLEDiscoveryHelper.h
//  MasterLocking
//
//  Created by Phien Tram on 11/15/12.
//  Copyright (c) 2012 Golden Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>




/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol BLEDiscoveryHelperDelegate <NSObject>
- (void) discoveryDidRefresh;
- (void) discoveryStatePoweredOff;
@end

@interface BLEDiscoveryHelper : NSObject

@property (nonatomic, assign) id <BLEDiscoveryHelperDelegate> BLEDiscoveryHelperDelegate;

@property (nonatomic, readonly)CBCentralManager* centralManager;

extern NSString *kLockingServiceEnteredBackgroundNotification;
extern NSString *kLockingServiceEnteredForegroundNotification;

+ (id) sharedInstance;



/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) startScanning;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral *)peripheral;
- (void) disconnectPeripheral:(CBPeripheral *)peripheral;
- (void) disconnectCurrentPeripheral;

- (void)sendCommand:(int)command;
- (void)sendCommand:(int)command toPeripheral:(CBPeripheral*)peripheral;

/* Behave properly when heading into and out of the background */
- (void)enteredBackground;
- (void)enteredForeground;

- (void)startAutoUnlock;
- (void)stopAutoUnlock;

/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
//@property (nonatomic, retain) CBPeripheral *foundPeripheral;
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;

@end
