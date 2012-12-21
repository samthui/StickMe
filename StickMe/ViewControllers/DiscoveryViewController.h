//
//  DiscoveryViewController.h
//  Stick'n'Find
//
//  Created by admin on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView* bluetoothDevicesTable;

//@property (nonatomic, retain) NSArray* bluetoothDevicesArray;

-(void) reloadBluetoothDevicesList;
-(void) reloadBluetoothDevicesList:(NSArray*) bluetoothDeviceArray;

@end
