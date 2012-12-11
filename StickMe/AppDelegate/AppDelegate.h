//
//  AppDelegate.h
//  Stick'n'Find
//
//  Created by admin on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BLEDiscoveryHelper.h"

#import "DiscoveryViewController.h"

#define ShareCoordinate [((AppDelegate *)[[UIApplication sharedApplication] delegate]) getCoordinate]
#define ShareCurrentLocation [((AppDelegate *)[[UIApplication sharedApplication] delegate]) currentLocation]

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, BLEDiscoveryHelperDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
