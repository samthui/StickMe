//
//  DetailStickedObjectViewController.h
//  StickMe
//
//  Created by admin on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailStickedObjectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) IBOutlet UITableView* detailTable;
@property (nonatomic, assign) int stickObjectIndex;
@property (nonatomic, assign) int stickIndex;

-(void) reloadBluetoothDeviceUUID: (NSString*) UUID;
-(void) reloadBluetoothDevice;

@end
