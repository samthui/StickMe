//
//  DiscoveryViewController.m
//  Stick'n'Find
//
//  Created by admin on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "BLEDiscoveryHelper.h"
#import "UserDefaultsHelper.h"
#import "Defines.h"
#import "Constants.h"
#import "Utilities.h"

#import "StickObject.h"
#import "StickObjectSummary.h"
#import "DiscoveryCell1.h"

#import "DetailStickedObjectViewController.h"

@interface DiscoveryViewController ()
{
//    NSArray* _stickObjectsArray;
}

//@property (nonatomic, retain) NSArray* stickObjectsArray;

-(void) connect:(id) sender;
-(void) connectToPeripheralAtIndex:(int)index;
-(void) blinkLed:(id) sender;

-(void) createStickObjectsArrayFromPeripheralsList:(NSArray*) peripheralsArray;

@end

@implementation DiscoveryViewController

@synthesize bluetoothDevicesTable = _bluetoothDevicesTable;
//@synthesize bluetoothDevicesArray = _bluetoothDevicesArray;
//@synthesize stickObjectsArray = _stickObjectsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Discovery", @"Devices");
        self.tabBarItem.image = [UIImage imageNamed:@"Discovery"];
    }
    return self;
}

-(void) dealloc
{
    self.bluetoothDevicesTable = nil;
//    self.bluetoothDevicesArray = nil;
//    self.stickObjectsArray = nil;
    
    [super dealloc];
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //Test
//    NSMutableArray* UUIDsList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//    NSLog(@"=====UUIDsList=====");
//    for (int i = 0; i < UUIDsList.count; i++) {
//        StickObjectSummary* stickSummary = (StickObjectSummary*)[UUIDsList objectAtIndex:i];
//        NSLog(@"%i %@ %@", i, stickSummary.UUID, stickSummary.name);
//    }
//    NSLog(@"=====discovered====");
//    NSMutableArray* discoveredList = [(BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
//    for (int i = 0; i < discoveredList.count; i++) {
//        StickObject* stick = (StickObject*)[discoveredList objectAtIndex:i];
//        NSLog(@"%i %@", i, [Utilities UUIDofPeripheral:(CBPeripheral*)stick.peripheral]);
//    }
    
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return _stickObjectsArray.count;
    NSMutableArray* UUIDsList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//    NSLog(@"numb rows: %i", UUIDsList.count);
    return UUIDsList.count;
}

//-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell* cell;
//
//    static NSString *cellID = @"BluetoothDeviceCell";
//
//    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell)
//    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID] autorelease];
//
////    StickObject* stick = (StickObject*)[_stickObjectsArray objectAtIndex:indexPath.row];
////    CBPeripheral* peripheral = stick.peripheral;
////    NSString* pUUID = (NSString*)peripheral.UUID;
//
//    [[cell textLabel] setText:[NSString stringWithFormat:@"No.%i", indexPath.row]];
//    //    [cell.detailTextLabel setText:pUUID];
//
//    CGRect cellFrame = cell.frame;
//    CGSize cellSize = cellFrame.size;
//    CGSize btnSize = CGSizeMake(70, 30);
//    int distanceBetween2Btns = 10;
//    //connectBtn
//    UIButton* connectBtn = [[UIButton alloc] initWithFrame:CGRectMake(cellSize.width - 2*distanceBetween2Btns - 2* btnSize.width, (cellSize.height - btnSize.height)/2, btnSize.width, btnSize.height)];
//    [connectBtn setBackgroundColor:[UIColor greenColor]];
//    [connectBtn setShowsTouchWhenHighlighted:YES];  
//    [connectBtn setTag:indexPath.row];
//    [connectBtn setTitle:@"Connect" forState:UIControlStateNormal];
//    [connectBtn addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:connectBtn];
//    [connectBtn release];
//
//    //blinkLedBtn
//    UIButton* blinkLedBtn = [[UIButton alloc] initWithFrame:CGRectMake(cellSize.width - distanceBetween2Btns - btnSize.width, (cellSize.height - btnSize.height)/2, btnSize.width, btnSize.height)];
//    [blinkLedBtn setBackgroundColor:[UIColor redColor]];
//    [blinkLedBtn setShowsTouchWhenHighlighted:YES];
//    [blinkLedBtn setTag:indexPath.row];
//    [blinkLedBtn setTitle:@"Light" forState:UIControlStateNormal];
//    [blinkLedBtn addTarget:self action:@selector(blinkLed:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:blinkLedBtn];
//    [blinkLedBtn release];
//
//    return cell;
//}


//-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DiscoveryCell1* cell;
//    
//    static NSString *cellID = @"DiscoveryCell1";
//    
//    cell = (DiscoveryCell1*)[tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell)
//    {
//        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DiscoveryCell1" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    
//    StickObject* stick = (StickObject*)[_stickObjectsArray objectAtIndex:indexPath.row];
//    CBPeripheral* peripheral = stick.peripheral;
////    NSString* peripheralName = peripheral.name;
////    NSString* pUUID = (NSString*)peripheral.UUID;
//    
////    [cell.deviceName setText: peripheralName];
//    [cell.deviceName setText:@"test"];
//    if (peripheral.isConnected) {
//        [cell.connectStatusBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
//    }
//    else {
//        [cell.connectStatusBtn setTitle:@"Connect" forState:UIControlStateNormal];
//    }
//
//    [cell.connectStatusBtn setTag:indexPath.row];
//    [cell.connectStatusBtn addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchUpInside];
//    
//    return cell;
//}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoveryCell1* cell;

    static NSString *cellID = @"DiscoveryCell1";

    cell = (DiscoveryCell1*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DiscoveryCell1" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        [cell.waveView removeFromSuperview];
        NSArray* waveNib = [[NSBundle mainBundle] loadNibNamed:@"WaveStrengthView" owner:self options:nil];
        WaveStrengthView* waveView = [waveNib objectAtIndex:0];
        [waveView setFrame:CGRectMake(115, 0, 40, 44)];
        cell.waveView = waveView;
        [cell addSubview:cell.waveView];
    }
    
    NSMutableArray* UUIDsList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    StickObjectSummary* stickSummary = (StickObjectSummary*)[UUIDsList objectAtIndex:indexPath.row];
    
    NSMutableArray* discoveredStickedObjectsList = [[BLEDiscoveryHelper sharedInstance] discoveredStickedObjectsList];
//    NSLog(@"discovered: %i", discoveredStickedObjectsList.count);
    if (indexPath.row < discoveredStickedObjectsList.count)
    {
        //            NSLog(@"UserInteractionEnabled");
        [cell.deviceName setEnabled:YES];
        [cell.distanceLbl setEnabled:YES];
        [cell.connectStatusBtn setEnabled:YES];
        [cell setUserInteractionEnabled:YES];
        
        StickObject* stick = (StickObject*)[discoveredStickedObjectsList objectAtIndex:indexPath.row];
        CBPeripheral* peripheral = stick.peripheral;
        
        [cell.deviceName setText:stickSummary.name];
//        [cell.deviceName setText:[Utilities nameOfPeripheral:stick.peripheral]];
//        [cell.distanceLbl setText:[NSString stringWithFormat:@"%im", stick.currentDistance]];
//        [cell.distanceLbl setText:[Utilities describeDistanceFromRSSI:stick.currentDistance]];
        [cell.distanceLbl setText:[Utilities describeDistanceFromRange:stick.range]];
        
        cell.waveView.range = stick.range.location + stick.range.length;
        [cell.waveView setNeedsDisplay];
        
        if (peripheral.isConnected) {
            [cell.connectStatusBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
        }
        else {
            [cell.connectStatusBtn setTitle:@"Connect" forState:UIControlStateNormal];
        }
        
        [cell.connectStatusBtn setTag:indexPath.row];
        [cell.connectStatusBtn addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        
        //default
//        NSMutableArray* UUIDsList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//        StickObjectSummary* stickSummary = (StickObjectSummary*)[UUIDsList objectAtIndex:indexPath.row];
        
        [cell.deviceName setText: stickSummary.name];
        [cell.deviceName setEnabled:NO];
        
        [cell.distanceLbl setText:@""];
        [cell.distanceLbl setEnabled:NO];
        
        cell.waveView.range = 40;
        [cell.waveView setAlpha:0.5];
        
        [cell.connectStatusBtn setEnabled:NO];        
        [cell.connectStatusBtn setTitle:@"" forState:UIControlStateNormal];
        
        [cell setUserInteractionEnabled:NO];
    }

    return cell;
}

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    NSLog(@"didSelectRowAtIndex: %i", indexPath.row);
//    DetailStickedObjectViewController* detailViewController = [[DetailStickedObjectViewController alloc] initWithNibName:@"DetailStickedObjectViewController" bundle:nil];
//    
//    NSMutableArray* usersDevicesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//    StickObjectSummary* stickSummary = (StickObjectSummary*)[usersDevicesList objectAtIndex:indexPath.row];
//    NSString* deviceName = stickSummary.name;
//    [detailViewController setTitle: deviceName];
//    detailViewController.stickObjectIndex = indexPath.row;
//    
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    
//    [detailViewController release];
//}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"didSelectRowAtIndex: %i", indexPath.row);
    [self connectToPeripheralAtIndex:indexPath.row];

    DetailStickedObjectViewController* detailViewController = [[DetailStickedObjectViewController alloc] initWithNibName:@"DetailStickedObjectViewController" bundle:nil];

    NSMutableArray* usersDevicesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    StickObjectSummary* stickSummary = (StickObjectSummary*)[usersDevicesList objectAtIndex:indexPath.row];
    NSString* deviceName = stickSummary.name;
    [detailViewController setTitle: deviceName];
    detailViewController.stickObjectIndex = indexPath.row;

    [self.navigationController pushViewController:detailViewController animated:YES];

    [detailViewController release];
}

#pragma mark -
-(void) reloadBluetoothDevicesList
{
//    self.bluetoothDevicesArray = ((BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance]).foundPeripherals;
//    [self.bluetoothDevicesTable reloadData];
    
    [self.bluetoothDevicesTable reloadData];  
    
    //reload detailStickedObjectView (if existed)
    for (id viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[DetailStickedObjectViewController class]]) {
            DetailStickedObjectViewController* detailVC = (DetailStickedObjectViewController*)viewController;
//            [detailVC.detailTable reloadData];
            [detailVC reloadBluetoothDevice];
        }
    }
}

-(void) reloadBluetoothDevicesList:(NSArray *)bluetoothDeviceArray
{
    [self createStickObjectsArrayFromPeripheralsList:bluetoothDeviceArray];
    
    [self.bluetoothDevicesTable reloadData];
    
    for (id viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[DetailStickedObjectViewController class]]) {
            DetailStickedObjectViewController* detailVC = (DetailStickedObjectViewController*)viewController;
            [detailVC.detailTable reloadData];
        }
    }
}

-(void) reloadBluetoothDeviceAtIndex:(int)index
{
    NSArray* indexesArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil];
    [self.bluetoothDevicesTable reloadRowsAtIndexPaths:indexesArray withRowAnimation:UITableViewRowAnimationFade];    
    
    //reload detailStickedObjectView (if existed)
    for (id viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[DetailStickedObjectViewController class]]) {
            DetailStickedObjectViewController* detailVC = (DetailStickedObjectViewController*)viewController;
            [detailVC.detailTable reloadData];
        }
    }
}

#pragma mark - private methods
//-(void) connect:(id)sender
//{
//    int index = ((UIButton*)sender).tag;
//
//    StickObject* stick = (StickObject*)[_stickObjectsArray objectAtIndex:index];
//    CBPeripheral* peripheral = stick.peripheral;
//    if (![peripheral isConnected]) {
//        [((BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance]).centralManager connectPeripheral:peripheral options:nil];
//    }
//    else {
//        [((BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance]).centralManager cancelPeripheralConnection:peripheral];
//    }
//}
//
//-(void) blinkLed:(id)sender
//{
//    int index = ((UIButton*)sender).tag;
//
//    //    [[BLEDiscoveryHelper sharedInstance] sendCommand:k_command_lock];
//
//    StickObject* stick = (StickObject*)[_stickObjectsArray objectAtIndex:index];
//    [stick sendCommand:k_command_lock];
//}

-(void) connect:(id)sender
{
    int index = ((UIButton*)sender).tag;
//    NSLog(@"connect %i", index);
    
    BLEDiscoveryHelper* BLEDiscover = (BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance];
    NSMutableArray* discoveredStickList = BLEDiscover.discoveredStickedObjectsList;
//    NSLog(@"discoveredStickList count: %i", discoveredStickList.count);
    StickObject* stick = (StickObject*)[discoveredStickList objectAtIndex:index];
    CBPeripheral* peripheral = stick.peripheral;
    if (![peripheral isConnected]) {
//        NSLog(@"discovery Connect");
        [stick connectPeripheral];
    }
    else {
//         NSLog(@"discovery cancelConnect");
        [stick cancelConnection];
    }
}

-(void) connectToPeripheralAtIndex:(int)index
{
    BLEDiscoveryHelper* BLEDiscover = (BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance];
    NSMutableArray* discoveredStickList = BLEDiscover.discoveredStickedObjectsList;
    //    NSLog(@"discoveredStickList count: %i", discoveredStickList.count);
    StickObject* stick = (StickObject*)[discoveredStickList objectAtIndex:index];
    CBPeripheral* peripheral = stick.peripheral;
    if (![peripheral isConnected]) {
//      NSLog(@"discovery Connect");
        [stick connectPeripheral];
    }
}

-(void) blinkLed:(id)sender
{
    int index = ((UIButton*)sender).tag;

    //    [[BLEDiscoveryHelper sharedInstance] sendCommand:k_command_lock];

    NSMutableArray* usersDevicesList = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:(NSString*)kUsersStickedObjectList];
    StickObject* stick = (StickObject*)[usersDevicesList objectAtIndex:index];
    [stick sendCommand:k_command_lock];
}

-(void)createStickObjectsArrayFromPeripheralsList:(NSArray *)peripheralsArray
{
//    NSMutableArray* tempStickObjectsArray = [NSMutableArray array];
//    for(CBPeripheral* peripheral in peripheralsArray)
//    {
//        StickObject* stick = [[StickObject alloc] initWithPeripheral:peripheral];
//        
//        [tempStickObjectsArray addObject:stick];
//        [stick release];
//    }
//
//    self.stickObjectsArray = tempStickObjectsArray;
}

@end
