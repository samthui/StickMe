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

-(id) initWithPeripheral: (CBPeripheral*)peripheral;

-(void) sendCommand:(int)command;

@end
