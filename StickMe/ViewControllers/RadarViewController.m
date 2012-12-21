//
//  RadarViewController.m
//  StickMe
//
//  Created by admin on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadarViewController.h"
#import "RadarView.h"

#import "BLEDiscoveryHelper.h"
#import "Utilities.h"
#import "AppDelegate.h"

#define FIRST_DEVICE_TAG    1000

@interface RadarViewController ()
{
    int _maxDistance;
}

-(int) maxDistance;
-(CGPoint) generateRandomPointObjectRange:(NSRange)range;
-(void) updateRangesArray;
-(void) drawCircles;

-(void)reScan;

@end

@implementation RadarViewController

@synthesize userPoint = _userPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Radar", @"Radar");
        self.tabBarItem.image = [UIImage imageNamed:@"Discovery"];
        _maxDistance = 0;
        
        //
        UIBarButtonItem* reScanBtn = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleBordered target:self action:@selector(reScan)];
        [reScanBtn setTitle:@"Re-Scan"];
        [self.navigationItem setLeftBarButtonItem:reScanBtn];
        [reScanBtn release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //User with accelerometer

    //load devices
//    [self reloadBluetoothDevicesList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - public methods
-(void) reloadBluetoothDevicesList
{   
    //NSLog(@"Radar reloadBluetoothDevicesList");
    //calculate maxDistance
    _maxDistance = [self maxDistance];

    //update rangesArray of RadarView
    [self updateRangesArray];
    
    //draw circles
    [self drawCircles];
    
    NSMutableArray* discoveredStickedObjectsList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
    
    for (int i = 0; i < discoveredStickedObjectsList.count; i++) {        
        StickObject* stick = (StickObject*)[discoveredStickedObjectsList objectAtIndex:i];
        if (stick.range.location == NSNotFound) {
            NSLog(@"stick.range NSNotFound continue");
            continue;
        }
        CGPoint stickPoint = [self generateRandomPointObjectRange:stick.range];
        
        UIView* searchView = [self.view viewWithTag:i + FIRST_DEVICE_TAG];
        if (!searchView)
        {
            UIImageView* obj = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Discovery"]];
            [obj setTag:i + FIRST_DEVICE_TAG];
            obj.center = CGPointMake(0.5, 0.5);
            [obj setFrame:CGRectMake(stickPoint.x, stickPoint.y, 20, 20)];
            [self.view addSubview:obj];
            [obj release];
        }
        else {            
            [UIView beginAnimations:@"Calibrate position" context:nil];
            [searchView setFrame:CGRectMake(stickPoint.x, stickPoint.y, 20, 20)];
            [UIView commitAnimations];
        }
    }
}

#pragma mark - private methods
//-(void) updateRangesArray
//{
//    RadarView* radarView = (RadarView*)self.view;
//    radarView.rangesArray = [NSMutableArray array];
//
//    float maxRadius = (float)self.view.frame.size.width/2.0;
//
//    NSMutableArray* discoveredStickedObjectsList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
//
//    for (int i = 0; i < discoveredStickedObjectsList.count; i++){
//        StickObject* stick = (StickObject*)[discoveredStickedObjectsList objectAtIndex:i];
//        NSRange stickRange = stick.range;
//        float radius = (float)(stickRange.location + stickRange.length)*maxRadius/_maxDistance;
//        
////        NSString* rangeString = [NSString stringWithFormat:@"%f", radius];        
////        if (![radarView.rangesArray containsObject:rangeString])
////        {
////            [radarView.rangesArray addObject:rangeString];
////        }
//        
//        NSNumber* radiusOfRange = [NSNumber numberWithFloat:radius];
//        if (![radarView.rangesArray containsObject:radiusOfRange])
//        {
//            [radarView.rangesArray addObject:radiusOfRange];
//        }
//    }
//}

-(void) updateRangesArray
{
    RadarView* radarView = (RadarView*)self.view;
    radarView.maxDistance = _maxDistance;
}

-(void)drawCircles
{
    [self.view setNeedsDisplay];

    //biggest
//    CGRect viewFrame = self.view.frame;
//    CGSize viewSize = viewFrame.size;
//    int radius = MAX(viewSize.width/2, viewSize.height/2);
//    CGSize boundOfCircleSize = CGSizeMake(radius, radius);
////    [self.view drawRect:CGRectMake((viewSize.width - boundOfCircleSize.width)/2, (viewSize.height - boundOfCircleSize.height)/2, boundOfCircleSize.width, boundOfCircleSize.height)];
////  [self.view setNeedsDisplay];
//    [self.view setNeedsDisplayInRect:CGRectMake((viewSize.width - boundOfCircleSize.width)/2, (viewSize.height - boundOfCircleSize.height)/2, boundOfCircleSize.width, boundOfCircleSize.height)];
}

-(int) maxDistance
{
    int maxDistance = 0;

    NSMutableArray* discoveredStickedObjectsList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];

    for (int i = 0; i < discoveredStickedObjectsList.count; i++){
        StickObject* stick = (StickObject*)[discoveredStickedObjectsList objectAtIndex:i];
        
        int tempMaxDistance = stick.range.location + stick.range.length;
        if (tempMaxDistance > maxDistance)
        {
            maxDistance = tempMaxDistance;
        }
    }

    return maxDistance;
}

-(CGPoint) generateRandomPointObjectRange:(NSRange)stickRange
{
    //random distance in range
    float randDistance = rand() % stickRange.length + stickRange.location;

    //calculate maxDistance
//    int maxDistance = [self maxDistance];

    //random position with this distance.
    CGRect viewFrame = self.view.frame;
    int maxDistanceInView = viewFrame.size.width / 2.0;

    //convert randDistance into view
    float randDistanceInView = (float)randDistance * (float)maxDistanceInView /(float)_maxDistance ;

    //random sign
    BOOL negative = [Utilities randBool];
    int sign = negative ? -1 : 1;
    //random x in range
    int randXInView = sign*(rand() % maxDistanceInView);  
    while (abs(randXInView) > abs(randDistanceInView)) {//to follow condition of sqrt(x) --> x >= 0 ==>> randDistanceInView >= randXInView
        randXInView = sign*(rand() % maxDistanceInView);
    }
    int x = maxDistanceInView + randXInView;
    //calculate correspond y
    //random sign
    negative = [Utilities randBool];
    sign = negative ? -1 : 1;
    float y = viewFrame.size.height/2 + sign*pow(pow(randDistanceInView, 2) - pow(randXInView, 2), 0.5) ;

//    NSLog(@"{%f, %f}", (float)x, y);
    return CGPointMake(x, y);
}

#pragma mark - Bluetooth actions
-(void) reScan
{
//    AppDelegate* appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDel scan];    
    
    BLEDiscoveryHelper* bluetoothDiscovery = [BLEDiscoveryHelper sharedInstance];
    [bluetoothDiscovery reScan];
}

@end
