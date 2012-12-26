//
//  RadarViewController.h
//  StickMe
//
//  Created by admin on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCalloutView.h"

@interface RadarViewController : UIViewController<SMCalloutViewDelegate>

//@property (nonatomic, retain) IBOutlet UIImageView* userPoint;

-(void)reloadBluetoothDevicesList;

@end
