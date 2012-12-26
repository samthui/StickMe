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
#import "UserDefaultsHelper.h"
#import "Utilities.h"
#import "Constants.h"
#import "Defines.h"

#import "AppDelegate.h"
#import "StickObjectSummary.h"

#import "ButtonWithCallOut.h"

#define ARC4RANDOM_MAX      0x100000000

#define FIRST_DEVICE_TAG    1000

@interface RadarViewController ()
{
    int _maxDistance;
    unsigned short _numbPoints;
    
}

-(int) maxDistance;
-(CGPoint) generateRandomPointObjectRange:(NSRange)range;
-(void) updateRangesArray;
-(void) drawCircles;

-(void)reScan;

-(void)objectTapped:(id)sender;

@end

@implementation RadarViewController

//@synthesize userPoint = _userPoint;

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
//-(void) reloadBluetoothDevicesList
//{   
//    //NSLog(@"Radar reloadBluetoothDevicesList");
//    //calculate maxDistance
//    _maxDistance = [self maxDistance];
//
//    //update rangesArray of RadarView
//    [self updateRangesArray];
//    
//    //draw circles
//    [self drawCircles];
//    
//    NSMutableArray* discoveredStickedObjectsList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
//    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//    
//    for (int i = 0; i < discoveredStickedObjectsList.count; i++) {        
//        StickObject* stick = (StickObject*)[discoveredStickedObjectsList objectAtIndex:i];
//        if (stick.range.location == NSNotFound) {
//            NSLog(@"stick.range NSNotFound continue");
//            continue;
//        }
//        CGPoint stickPoint = [self generateRandomPointObjectRange:stick.range];
//        
//        UIView* searchView = [self.view viewWithTag:i + FIRST_DEVICE_TAG];
//        if (!searchView)
//        {
////            UIImageView* obj = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Discovery"]];
////            
////            [obj addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(objectTapped)]];              
//            
////            [obj setTag:i + FIRST_DEVICE_TAG];
////            obj.center = CGPointMake(0.5, 0.5);
////            [obj setFrame:CGRectMake(stickPoint.x, stickPoint.y, 20, 20)];
////            [self.view addSubview:obj];
////            [obj release];
//            
//            UIButton* obj = [[UIButton alloc] initWithFrame:CGRectMake(stickPoint.x, stickPoint.y, 20, 20)];
//            [obj setTag:i + FIRST_DEVICE_TAG];
//            [obj addTarget:self action:@selector(objectTapped) forControlEvents:UIControlEventTouchUpInside];
//            obj.center = CGPointMake(0.5, 0.5);
//            [obj setImage:[UIImage imageNamed:@"Discovery"] forState:UIControlStateNormal];
//            [self.view addSubview:obj];
//            [obj release];
//            
//            UIButton *topDisclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [topDisclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disclosureTapped)]];
//            
//            StickObjectSummary* stickSummary = (StickObjectSummary*)[stickSummariesList objectAtIndex:i];
//            calloutView = [SMCalloutView new];
//            calloutView.delegate = self;
//            calloutView.title = stickSummary.name;
//            calloutView.rightAccessoryView = topDisclosure;
//            calloutView.calloutOffset = CGPointMake(10, 0);
//            
//        }
//        else {            
//            [UIView beginAnimations:@"Calibrate position" context:nil];
//            [searchView setFrame:CGRectMake(stickPoint.x, stickPoint.y, 20, 20)];
//            [UIView commitAnimations];
//        }
//    }
//
//    //remove unDiscoveredDevices
//    for(int i = discoveredStickedObjectsList.count; i < _numbPoints; i ++)
//    {
//        int tag = FIRST_DEVICE_TAG + i;
////        NSLog(@"tag: %i", FIRST_DEVICE_TAG + tag);
//        UIView* searchView = [self.view viewWithTag:tag];
//        if (searchView)
//        {
////            NSLog(@"remove subview");
//            [searchView removeFromSuperview];
//        }
//    }
//
//    _numbPoints = discoveredStickedObjectsList.count;
//}


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
    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];

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
            ButtonWithCallOut* obj = [[ButtonWithCallOut alloc] initWithFrame:CGRectMake(stickPoint.x, stickPoint.y, OBJ_ICON_SIZE, OBJ_ICON_SIZE)];
            [obj setTag:i + FIRST_DEVICE_TAG];
            [obj addTarget:self action:@selector(objectTapped:) forControlEvents:UIControlEventTouchUpInside];
            obj.center = CGPointMake(0.5, 0.5);
            [obj setImage:[UIImage imageNamed:@"Discovery"] forState:UIControlStateNormal];
            
            StickObjectSummary* stickSummary = (StickObjectSummary*)[stickSummariesList objectAtIndex:i];            
            obj.callOut.delegate = self;
            obj.callOut.title = stickSummary.name;            
            
            [self.view addSubview:obj];
            [obj release];            
        }
        else {            
            StickObjectSummary* stickSummary = (StickObjectSummary*)[stickSummariesList objectAtIndex:i];
            ButtonWithCallOut* objBtn = (ButtonWithCallOut*)searchView;
            objBtn.callOut.title = stickSummary.name;
            [UIView beginAnimations:@"Calibrate position" context:nil];
            [objBtn setFrame:CGRectMake(stickPoint.x, stickPoint.y, OBJ_ICON_SIZE, OBJ_ICON_SIZE)];
            if(objBtn.callOut.window)
            {
    //            NSLog(@"bla");
                [objBtn.callOut presentCalloutFromRect:CGRectMake(objBtn.frame.origin.x, objBtn.frame.origin.y, 1, 1) inView:self.view constrainedToView:self.view permittedArrowDirections:SMCalloutArrowDirectionDown animated:NO];
            }
            [UIView commitAnimations];
        }
    }

    //remove unDiscoveredDevices
    for(int i = discoveredStickedObjectsList.count; i < _numbPoints; i ++)
    {
        int tag = FIRST_DEVICE_TAG + i;
        //        NSLog(@"tag: %i", FIRST_DEVICE_TAG + tag);
        UIView* searchView = [self.view viewWithTag:tag];
        if (searchView)
        {
            //            NSLog(@"remove subview");
            [searchView removeFromSuperview];
            
            //dismiss its callOut
            [((ButtonWithCallOut*)searchView).callOut dismissCalloutAnimated:NO];
        }
    }

    _numbPoints = discoveredStickedObjectsList.count;
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
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    while(val > 0.5){val = ((double)arc4random() / ARC4RANDOM_MAX);}
    float randDistance = rand() % stickRange.length + stickRange.location + val;

    //calculate maxDistance
//    int maxDistance = [self maxDistance];

    //random position with this distance.
    CGRect viewFrame = self.view.frame;
    int maxDistanceInView = viewFrame.size.width / 2.0 - BOUND_MARGIN;

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

#pragma mark - SMCallout
- (void)objectTapped:(id)sender {
    ButtonWithCallOut* objBtn = (ButtonWithCallOut*)sender;
    [objBtn onTapped];
}

#pragma mark - SMCalloutViewDelegate
- (NSTimeInterval)calloutView:(SMCalloutView *)theCalloutView delayForRepositionWithSize:(CGSize)offset {
    return kSMCalloutViewRepositionDelayForUIScrollView;
}

- (void)disclosureTapped {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap!" message:@"You tapped the disclosure button."
                                                   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Whatevs",nil];
    [alert show];
}

- (void)dismissCallout {
//[calloutView dismissCalloutAnimated:NO];
}

@end
