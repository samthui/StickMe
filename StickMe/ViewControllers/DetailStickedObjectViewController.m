//
//  DetailStickedObjectViewController.m
//  StickMe
//
//  Created by admin on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailStickedObjectViewController.h"

#import "BLEDiscoveryHelper.h"
#import "UserDefaultsHelper.h"
#import "Constants.h"
#import "Defines.h"

#import "DiscoveryCell1.h"

#import "StickObjectSummary.h"
#import "Utilities.h"

#define CONFIG_ITEM_TAG 1
#define DISTANCE_LBL_TAG    2

@interface DetailStickedObjectViewController ()
{
    NSString* _UUID;
}

@property (nonatomic, retain) NSString* UUID;

//-(void) switchConnectState:(id)sender;
-(void) switchConnectState;
-(void) light:(id)sender;
-(void) ring:(id)sender;
-(void) noticeInRange:(id)sender;
-(void) noticeOutRange:(id)sender;
-(void) setupDistance:(id)sender;

@end

@implementation DetailStickedObjectViewController

@synthesize UUID = _UUID;
@synthesize stickIndex = _stickIndex;

@synthesize detailTable = _detailTable;
@synthesize stickObjectIndex = _stickObjectIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
    self.UUID = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    NSMutableArray* discoveredArray = BLEDiscover.discoveredStickedObjectsList;
    StickObject* stick = [discoveredArray objectAtIndex:_stickObjectIndex];
    self.UUID = [Utilities UUIDofPeripheral:stick.peripheral];
    
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

#pragma mark - Table
//-(int) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString* headerTitle;
//    switch (section) {
//        case 0:
//            headerTitle = nil;
//            break;
//            
//        case 1:
//            headerTitle = @"Services";
//            break;
//            
//        default:
//            headerTitle = nil;
//            break;
//    }
//    return headerTitle;
//}
//
//-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    int numbRow;
//    switch (section) {
//        case 0:
//            numbRow = 1;
//            break;
//          
//        case 1:
//            numbRow = 3;
//            break;
//            
//        default:
//            numbRow = 0;
//            break;
//    }
//    
//    return numbRow;
//}

//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString* cellID = @"Cell_With_Switch";
//    if (indexPath.section == 1 && indexPath.row == 2) {//distance cell
//        cellID = @"Cell_With_Slider";
//    }
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    
//    BOOL hadConfigItem = NO;
//    UIView* subview = [cell viewWithTag:CONFIG_ITEM_TAG];
//    if (subview) {
//        hadConfigItem = YES;
//    }
//    
//    switch (indexPath.section) {
//        case 0:{
//            switch (indexPath.row) {
//                case 0:{
////                    NSLog(@"_stickObjectIndex");
//                    if (_stickObjectIndex >= 0) {     
////                        NSLog(@"======= %i", _stickObjectIndex);
//                        NSMutableArray* usersDevicesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//                        StickObjectSummary* stickSummary = (StickObjectSummary*)[usersDevicesList objectAtIndex:_stickObjectIndex];
//                        NSString* deviceName = stickSummary.name;
//                        [cell.textLabel setText:deviceName];
//                        
//                        if (!hadConfigItem) {
//                            CGSize switchSize = CGSizeMake(80, 20);
//                            UISwitch* connectStateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
//                            connectStateSwitch.tag = CONFIG_ITEM_TAG;
//                            [connectStateSwitch addTarget:self action:@selector(switchConnectState) forControlEvents:UIControlEventValueChanged];
//                            
//                            //set state
//                            NSMutableArray* discoveredSticksList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
//                            //                    NSLog(@"....... 9 .......");
//                            StickObject* stick = (StickObject*)[discoveredSticksList objectAtIndex:_stickObjectIndex];
//                            //                    NSLog(@"....... 10 .......");
//                            CBPeripheral* peripheral = stick.peripheral;
//                            [connectStateSwitch setOn: ([peripheral isConnected] ? YES : NO)];
//                            
//                            [cell addSubview:connectStateSwitch];
//                            [connectStateSwitch release];
//                        }                    
//                    }
//                    else {
////                        NSLog(@"======= blaablaa");
//                        UISwitch* connectStateSwitch = (UISwitch*) subview;
//                        [connectStateSwitch setOn:NO];
//                    }
//                
//                    break;
//                 }   
//                default:
//                    break;
//            }
//            break;
//        } 
//        case 1:
//            switch (indexPath.row) {
//                case 0:{
//                    [cell.textLabel setText:@"Light"];
//              
//                    if (!hadConfigItem) {
//                        CGSize switchSize = CGSizeMake(80, 20);
//                        UISwitch* lightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
//                        lightSwitch.tag = CONFIG_ITEM_TAG;
//                        [lightSwitch addTarget:self action:@selector(light:) forControlEvents:UIControlEventValueChanged];
//                        
//                        //set state
//                        if(_stickObjectIndex >= 0)
//                        {
//                            NSMutableArray* discoveredSticksList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
//                            StickObject* stick = (StickObject*)[discoveredSticksList objectAtIndex:_stickObjectIndex];
//                            [lightSwitch setOn: (stick.isBlinking ? YES : NO)];
//                        }
//                        
//                        [cell addSubview:lightSwitch];
//                        [lightSwitch release];
//                    }
//                    
//                    break;
//                }
//                    
//                case 1:{
//                    [cell.textLabel setText:@"Ring"];
//                    
//                    if (!hadConfigItem) {
//                        CGSize switchSize = CGSizeMake(80, 20);
//                        UISwitch* ringSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
//                        ringSwitch.tag = CONFIG_ITEM_TAG;
//                        [ringSwitch addTarget:self action:@selector(ring:) forControlEvents:UIControlEventValueChanged];
//                        
//                        //set state
//                        if(_stickObjectIndex >= 0)
//                        {
//                            NSMutableArray* discoveredSticksList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
//                            StickObject* stick = (StickObject*)[discoveredSticksList objectAtIndex:_stickObjectIndex];
//                            [ringSwitch setOn: (stick.isRinging ? YES : NO)];
//                        }
//                        
//                        [cell addSubview:ringSwitch];
//                        [ringSwitch release];
//                    }
//                    
//                    break;
//                }
//                    
//                case 2:{
//                    [cell.textLabel setText:@"Distance"];
//                
//                    if (!hadConfigItem) {
//                        CGSize slideSize = CGSizeMake(80, 20);
//                        UISlider* distanceSlider = [[UISlider alloc] initWithFrame:CGRectMake(cell.frame.size.width - slideSize.width - 11, (cell.frame.size.height - slideSize.height)/2, slideSize.width, slideSize.height)];
//                        distanceSlider.tag = CONFIG_ITEM_TAG;
//                        [distanceSlider addTarget:self action:@selector(setupDistance:) forControlEvents:UIControlEventValueChanged];
//                        
//                        //set state
//                        if(_stickObjectIndex >= 0)
//                        {
//                            NSMutableArray* discoveredSticksList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
//                            StickObject* stick = (StickObject*)[discoveredSticksList objectAtIndex:_stickObjectIndex];
//                            distanceSlider.value = stick.setupDistance / MAX_DISTANCE;
//                        }
////                        [distanceSlider setValue:0.0];
//                        //                    StickObject* stick = (StickObject*)[[[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList] objectAtIndex:_stickObjectIndex];
//                        //                    float distanceRef = -(float)stick.currentDistance / 17.0f;
//                        //                    NSLog(@"WRONG FORMULA distanceRef: %f", distanceRef);
//                        //                    [distanceSlider setValue:distanceRef];
//                        
//                        [cell addSubview:distanceSlider];
//                        [distanceSlider release];
//                    }
//                    
//                    break;
//                }
//                    
//                default:
//                    break;
//            }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return cell;
//}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    switch (section) {
        case 1:
            height = 25;
            break;
            
        default:
            height = 0;
            break;
    }
    
    return height;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* headerTitle;
    switch (section) {
//        case 0:
//            headerTitle = nil;
//            break;
            
        case 1:
            headerTitle = @"Services";
            break;
            
        default:
            headerTitle = nil;
            break;
    }
    return headerTitle;
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numbRow;
    switch (section) {
        case 0:
            numbRow = 1;
            break;
            
        case 1:
            numbRow = 2;
            break;
            
        case 2:
            numbRow = 1;
            break;
            
        case 3:
            numbRow = 2;
            break;
            
        default:
            numbRow = 0;
            break;
    }
    
    return numbRow;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"Cell_With_Switch";
    if (indexPath.section == 3 && indexPath.row == 2) {//distance cell
        cellID = @"Cell_With_Slider";
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    BOOL hadConfigItem = NO;
    UIView* subview = [cell viewWithTag:CONFIG_ITEM_TAG];
    if (subview) {
        hadConfigItem = YES;
    }
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    //                    NSLog(@"_stickObjectIndex");
                    if (_stickObjectIndex >= 0) {     
                        //                        NSLog(@"======= %i", _stickObjectIndex);
                        NSMutableArray* usersDevicesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
                        StickObjectSummary* stickSummary = (StickObjectSummary*)[usersDevicesList objectAtIndex:_stickObjectIndex];
                        NSString* deviceName = stickSummary.name;
                        [cell.textLabel setText:deviceName];
                        
                        if (!hadConfigItem) {
                            CGSize switchSize = CGSizeMake(80, 20);
                            UISwitch* connectStateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
                            connectStateSwitch.tag = CONFIG_ITEM_TAG;
                            [connectStateSwitch addTarget:self action:@selector(switchConnectState) forControlEvents:UIControlEventValueChanged];
                            
                            //set state
                            NSMutableArray* discoveredSticksList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
                            //                    NSLog(@"....... 9 .......");
                            StickObject* stick = (StickObject*)[discoveredSticksList objectAtIndex:_stickObjectIndex];
                            //                    NSLog(@"....... 10 .......");
                            CBPeripheral* peripheral = stick.peripheral;
                            [connectStateSwitch setOn: ([peripheral isConnected] ? YES : NO)];
                            
                            [cell addSubview:connectStateSwitch];
                            [connectStateSwitch release];
                        }                    
                    }
                    else {
                        //                        NSLog(@"======= blaablaa");
                        UISwitch* connectStateSwitch = (UISwitch*) subview;
                        [connectStateSwitch setOn:NO];
                    }
                    
                    break;
                }   
                default:
                    break;
            }
            break;
        } 
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    [cell.textLabel setText:@"Light"];
                    
                    if (!hadConfigItem) {
                        CGSize switchSize = CGSizeMake(80, 20);
                        UISwitch* lightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
                        lightSwitch.tag = CONFIG_ITEM_TAG;
                        [lightSwitch addTarget:self action:@selector(light:) forControlEvents:UIControlEventValueChanged];
                        
                        //set state
                        if(_stickObjectIndex >= 0)
                        {
                            NSMutableArray* discoveredSticksList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
                            StickObject* stick = (StickObject*)[discoveredSticksList objectAtIndex:_stickObjectIndex];
                            [lightSwitch setOn: (stick.isBlinking ? YES : NO)];
                        }
                        
                        [cell addSubview:lightSwitch];
                        [lightSwitch release];
                    }
                    
                    break;
                }
                    
                case 1:{
                    [cell.textLabel setText:@"Ring"];
                    
                    if (!hadConfigItem) {
                        CGSize switchSize = CGSizeMake(80, 20);
                        UISwitch* ringSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
                        ringSwitch.tag = CONFIG_ITEM_TAG;
                        [ringSwitch addTarget:self action:@selector(ring:) forControlEvents:UIControlEventValueChanged];
                        
                        //set state
                        if(_stickObjectIndex >= 0)
                        {
                            NSMutableArray* discoveredSticksList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
                            StickObject* stick = (StickObject*)[discoveredSticksList objectAtIndex:_stickObjectIndex];
                            [ringSwitch setOn: (stick.isRinging ? YES : NO)];
                        }
                        
                        [cell addSubview:ringSwitch];
                        [ringSwitch release];
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    [cell.textLabel setText:@"Notice In Range"];
                    
                    if (!hadConfigItem) {
                        CGSize switchSize = CGSizeMake(80, 20);
                        UISwitch* noticeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
                        noticeSwitch.tag = CONFIG_ITEM_TAG;
                        [noticeSwitch addTarget:self action:@selector(noticeInRange:) forControlEvents:UIControlEventValueChanged];
                        
                        //set state
                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
                        [noticeSwitch setOn:stickSummary.noticeInRange];
                        
                        [cell addSubview:noticeSwitch];
                        [noticeSwitch release];
                    }
                    else {
                        UISwitch* noticeSwitch = (UISwitch*)subview;
                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
                        [noticeSwitch setOn:stickSummary.noticeInRange];
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    [cell.textLabel setText:@"Notice Out Range"];
                    
                    if (!hadConfigItem) {
                        CGSize switchSize = CGSizeMake(80, 20);
                        UISwitch* noticeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
                        noticeSwitch.tag = CONFIG_ITEM_TAG;
                        [noticeSwitch addTarget:self action:@selector(noticeOutRange:) forControlEvents:UIControlEventValueChanged];
                        
                        //set state
                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
                        [noticeSwitch setOn:stickSummary.noticeOutRange];
                        
                        [cell addSubview:noticeSwitch];
                        [noticeSwitch release];
                    }
                    else {
                        UISwitch* noticeSwitch = (UISwitch*)subview;
                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
                        [noticeSwitch setOn:stickSummary.noticeOutRange];
                    }
                    
                    break;
                }
                
                case 1:{
                    [cell.textLabel setText:@"Distance"];
                    
                    if (!hadConfigItem) {
                        CGSize slideSize = CGSizeMake(80, 20);
                        UISlider* distanceSlider = [[UISlider alloc] initWithFrame:CGRectMake(cell.frame.size.width - slideSize.width - 11, (cell.frame.size.height - slideSize.height)/2, slideSize.width, slideSize.height)];
                        distanceSlider.tag = CONFIG_ITEM_TAG;
                        [distanceSlider addTarget:self action:@selector(setupDistance:) forControlEvents:UIControlEventValueChanged];
                        
                        //set state
                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
                        [distanceSlider setValue:stickSummary.setupDistance / MAX_DISTANCE];
                        
                        [cell addSubview:distanceSlider];
                        [distanceSlider release];
                        
                        //setupDistanceLbl
                        UILabel* setupDistanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 50 - 80 - 2*11, 0, 50, cell.frame.size.height)];
                        [setupDistanceLbl setTextAlignment:UITextAlignmentRight];
                        [setupDistanceLbl setBackgroundColor:[UIColor clearColor]];
                        setupDistanceLbl.tag = DISTANCE_LBL_TAG;
                        [setupDistanceLbl setText:[NSString stringWithFormat:@"%im", stickSummary.setupDistance]];
                        [cell addSubview:setupDistanceLbl];
                        [setupDistanceLbl release];
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - private methods
//-(void) switchConnectState:(id)sender
//{
//    UISwitch* connectStatusSwitch = (UISwitch*) sender;
//    
//    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
//    CBPeripheral* peripheral = (CBPeripheral*)[[BLEDiscover foundPeripherals] objectAtIndex:_stickObjectIndex];
//    if([connectStatusSwitch isOn]){
//        [BLEDiscover.centralManager connectPeripheral:peripheral options:nil];
//    }else {
//        [BLEDiscover.centralManager cancelPeripheralConnection:peripheral];
//    }
//}

//-(void) switchConnectState
//{ BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
//    CBPeripheral* peripheral = (CBPeripheral*)[[BLEDiscover foundPeripherals] objectAtIndex:_stickObjectIndex];
//    if([peripheral isConnected]){
//        [BLEDiscover.centralManager cancelPeripheralConnection:peripheral];
//    }else {
//        [BLEDiscover.centralManager connectPeripheral:peripheral options:nil];
//    }
//}

-(void) switchConnectState
{ 
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    StickObject* stick = (StickObject*)[[BLEDiscover discoveredStickedObjectsList] objectAtIndex:_stickObjectIndex];
    CBPeripheral* peripheral = stick.peripheral;
    if([peripheral isConnected]){
//        NSLog(@"detail cancelConnect");
        [stick cancelConnection];
    }else {
//        NSLog(@"detail Connect");
        [stick connectPeripheral];
    }
}

-(void)light:(id)sender
{
    if (_stickObjectIndex < 0) {
        return;
    }
    
    UISwitch* lightSwitch = (UISwitch*) sender;
    
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    StickObject* stick = (StickObject*)[[BLEDiscover discoveredStickedObjectsList] objectAtIndex:_stickObjectIndex];
    
    stick.isBlinking = lightSwitch.isOn;
    
    [stick sendCommand:k_command_lock];
}

-(void)ring:(id)sender
{
    if (_stickObjectIndex < 0) {
        return;
    }
    
    UISwitch* ringSwitch = (UISwitch*) sender;
    
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    StickObject* stick = (StickObject*)[[BLEDiscover discoveredStickedObjectsList] objectAtIndex:_stickObjectIndex];
    
    stick.isRinging = ringSwitch.isOn;
}

-(void) noticeInRange:(id)sender
{
    UISwitch* noticeSwitch = (UISwitch*) sender;
    
    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
    
    stickSummary.noticeInRange = noticeSwitch.isOn;
    
    [UserDefaultsHelper saveToUserDefaultWithKey:(NSString*)kUUIDsList forArray:stickSummariesList];
}

-(void) noticeOutRange:(id)sender
{
    UISwitch* noticeSwitch = (UISwitch*) sender;
    
    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
    
    stickSummary.noticeOutRange = noticeSwitch.isOn;
    
    [UserDefaultsHelper saveToUserDefaultWithKey:(NSString*)kUUIDsList forArray:stickSummariesList];
}

//-(void)setupDistance:(id)sender
//{
//    if (_stickObjectIndex < 0)
//    {
//        return;
//    }
//    UISlider* distanceSlider = (UISlider*) sender;
//
//    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
//    StickObject* stick = (StickObject*)[[BLEDiscover discoveredStickedObjectsList] objectAtIndex:_stickObjectIndex];
//
//    stick.setupDistance = distanceSlider.value * MAX_DISTANCE;
////    NSLog(@"stick.setupDistance: %i", stick.setupDistance);
//}

-(void)setupDistance:(id)sender
{
    UISlider* distanceSlider = (UISlider*) sender;
    
    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
    
    stickSummary.setupDistance = distanceSlider.value * MAX_DISTANCE;
    //    NSLog(@"stick.setupDistance: %i", stick.setupDistance);
    
    //set distance text
    UITableViewCell* cell = (UITableViewCell*)[distanceSlider superview];
    UIView* setupDistanceLbl = [cell viewWithTag:DISTANCE_LBL_TAG];
    if (setupDistanceLbl && [setupDistanceLbl isKindOfClass:[UILabel class]]) {
        [(UILabel*)setupDistanceLbl setText:[NSString stringWithFormat:@"%im", stickSummary.setupDistance]];
    }
    
    [UserDefaultsHelper saveToUserDefaultWithKey:(NSString*)kUUIDsList forArray:stickSummariesList];
}

-(void) reloadBluetoothDeviceUUID:(NSString *)UUID
{
    if (!self.UUID || ![_UUID isEqual:UUID]) {
        return;
    }
    
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    NSMutableArray* discoveredObjectList = BLEDiscover.discoveredStickedObjectsList;
    
    int foundIndex = 0;
    BOOL found = NO;
    for (StickObject* stick in discoveredObjectList) {
        NSString* pUUID = [Utilities UUIDofPeripheral:stick.peripheral];
        if (self.UUID && [_UUID isEqual:pUUID]) {
            found = YES;
            _stickObjectIndex = foundIndex;
            break;
        }
        
        foundIndex ++;
    }
    
    if (!found) {
        _stickObjectIndex = -1;
    }
    
    [self.detailTable reloadData];
}

-(void) reloadBluetoothDevice
{    
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    NSMutableArray* discoveredObjectList = BLEDiscover.discoveredStickedObjectsList;
    
    int foundIndex = 0;
    BOOL found = NO;
    for (StickObject* stick in discoveredObjectList) {
        NSString* pUUID = [Utilities UUIDofPeripheral:stick.peripheral];
        if (self.UUID && [_UUID isEqual:pUUID]) {
            found = YES;
//            NSLog(@"reloadBluetoothDevice _stickObjectIndex: %i", foundIndex);
            _stickIndex = foundIndex;
            _stickObjectIndex = foundIndex;
            break;
        }
        
        foundIndex ++;
    }
    
    if (!found) {
        _stickObjectIndex = -1;
    }
    
    [self.detailTable reloadData];
}

@end
