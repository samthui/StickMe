//
//  StickObject.h
//  StickMe
//
//  Created by admin on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface StickObject : NSObject <CBPeripheralDelegate>

@property (nonatomic, retain) CBPeripheral* peripheral;
@property (nonatomic, retain) CBCharacteristic* readCharacteristic;
@property (nonatomic, retain) CBCharacteristic* writeCharacteristic;
@property (nonatomic, assign) BOOL isBlinking;
@property (nonatomic, assign) BOOL isRinging;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) int currentDistance;
@property (nonatomic, assign) int setupDistance;

@property (nonatomic, retain) NSMutableArray* RSSIsArray;

-(id) initWithPeripheral: (CBPeripheral*)peripheral;

-(void) sendCommand:(int)command;

-(void) connectPeripheral;
-(void) cancelConnection;

-(void) startReadRSSI;
-(void) stopReadRSSI;
-(void) averageRSSI;

@end
