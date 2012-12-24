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

@interface DetailStickedObjectViewController ()
{
    NSString* _UUID;
}

@property (nonatomic, retain) NSString* UUID;

//-(void) switchConnectState:(id)sender;
-(void) switchConnectState;
-(void) light:(id)sender;
-(void) ring:(id)sender;
-(void) vibrate:(id)sender;

@end

@implementation DetailStickedObjectViewController

@synthesize UUID = _UUID;

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
-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* headerTitle;
    switch (section) {
        case 0:
            headerTitle = nil;
            break;
            
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
            numbRow = 3;
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
    if (indexPath.section == 1 && indexPath.row == 2) {//distance cell
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
                    NSLog(@"_stickObjectIndex");
                    if (_stickObjectIndex >= 0) {     
                        NSLog(@"======= %i", _stickObjectIndex);
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
                        NSLog(@"======= blaablaa");
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
        case 1:
            switch (indexPath.row) {
                case 0:{
                    [cell.textLabel setText:@"Light"];
                    
                    if (!hadConfigItem) {
                        CGSize switchSize = CGSizeMake(80, 20);
                        UISwitch* lightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - switchSize.width - 11, (cell.frame.size.height - switchSize.height)/2, switchSize.width, switchSize.height)];
                        lightSwitch.tag = CONFIG_ITEM_TAG;
                        [lightSwitch addTarget:self action:@selector(light:) forControlEvents:UIControlEventValueChanged];
                        
                        //set state
                        
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
                        
                        [cell addSubview:ringSwitch];
                        [ringSwitch release];
                    }
                    
                    break;
                }
                    
                case 2:{
                    [cell.textLabel setText:@"Distance"];
                    
                    if (!hadConfigItem) {
                        CGSize slideSize = CGSizeMake(80, 20);
                        UISlider* distanceSlider = [[UISlider alloc] initWithFrame:CGRectMake(cell.frame.size.width - slideSize.width - 11, (cell.frame.size.height - slideSize.height)/2, slideSize.width, slideSize.height)];
                        distanceSlider.tag = CONFIG_ITEM_TAG;
                        
                        //set state
                        [distanceSlider setValue:0.0];
                        //                    StickObject* stick = (StickObject*)[[[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList] objectAtIndex:_stickObjectIndex];
                        //                    float distanceRef = -(float)stick.currentDistance / 17.0f;
                        //                    NSLog(@"WRONG FORMULA distanceRef: %f", distanceRef);
                        //                    [distanceSlider setValue:distanceRef];
                        
                        [cell addSubview:distanceSlider];
                        [distanceSlider release];
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
            
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
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    StickObject* stick = (StickObject*)[[BLEDiscover discoveredStickedObjectsList] objectAtIndex:_stickObjectIndex];
    
    [stick sendCommand:k_command_lock];
}

-(void)ring:(id)sender
{}

-(void)vibrate:(id)sender
{}

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
