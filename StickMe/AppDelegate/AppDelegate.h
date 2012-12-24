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

#define RADAR_TAB_INDEX     0
#define DISCOVERY_TAB_INDEX 1
#define SETTINGS_TAB_INDEX  2

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, BLEDiscoveryHelperDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) NSTimer* refreshViewsTimer;

//-(void) scan;
-(void) refreshViews;

-(void) noticeAction;
-(void) noticeStickedObjectInRange;
-(void) noticeInRangeObjectAtIndex:(int)index;
-(void) noticeStickedObjectOutRange;
-(void) noticeOutRangeObjectAtIndex:(int)index;

@end
