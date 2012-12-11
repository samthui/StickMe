//
//  AppDelegate.m
//  Stick'n'Find
//
//  Created by admin on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "DiscoveryViewController.h"

#import "SettingsViewController.h"

void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"CRASH: %@", exception);
    
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    
    // Internal error reporting
    
}

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[DiscoveryViewController alloc] initWithNibName:@"DiscoveryViewController" bundle:nil] autorelease];
    UIViewController *viewController2 = [[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    BLEDiscoveryHelper* bluetoothDiscovery = [BLEDiscoveryHelper sharedInstance];
    bluetoothDiscovery.BLEDiscoveryHelperDelegate = self;
    //[_bluetoothDiscovery startScanningForUUIDString:@"00000000-0000-0000-0000-000000001804"];
    [bluetoothDiscovery startScanning];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

#pragma mark - BLEDiscoveryHelperDelegate
-(void) discoveryDidRefresh
{ 
    DiscoveryViewController* discoveryViewController = (DiscoveryViewController*)[[self.tabBarController viewControllers] objectAtIndex:0];
//    [discoveryViewController reloadBluetoothDevicesList];
    [discoveryViewController reloadBluetoothDevicesList:((BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance]).foundPeripherals];
}

-(void) discoveryStatePoweredOff
{
    NSLog(@"Appdelegate discoveryStatePoweredOff");
}

@end
