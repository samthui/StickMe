//
//  DiscoveryViewController.m
//  Stick'n'Find
//
//  Created by admin on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "BLEDiscoveryHelper.h"
#import "Defines.h"

@interface DiscoveryViewController ()

-(void) connect:(id) sender;
-(void) blinkLed:(id) sender;

@end

@implementation DiscoveryViewController

@synthesize bluetoothDevicesTable = _bluetoothDevicesTable;
@synthesize bluetoothDevicesArray = _bluetoothDevicesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Discovery", @"Discovery");
        self.tabBarItem.image = [UIImage imageNamed:@"Discovery"];
    }
    return self;
}

-(void) dealloc
{
    self.bluetoothDevicesTable = nil;
    self.bluetoothDevicesArray = nil;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bluetoothDevicesArray.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    static NSString *cellID = @"BluetoothDeviceCell";
    
	cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID] autorelease];
    
    CBPeripheral* peripheral = (CBPeripheral*)[_bluetoothDevicesArray objectAtIndex:indexPath.row];
    NSString* pUUID = (NSString*)peripheral.UUID;
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"No.%i", indexPath.row]];
    [cell.detailTextLabel setText:pUUID];
    
    CGRect cellFrame = cell.frame;
    CGSize cellSize = cellFrame.size;
    CGSize btnSize = CGSizeMake(50, 30);
    int distanceBetween2Btns = 10;
    //connectBtn
    UIButton* connectBtn = [[UIButton alloc] initWithFrame:CGRectMake(cellSize.width - 2*distanceBetween2Btns - 2* btnSize.width, (cellSize.height - btnSize.height)/2, btnSize.width, btnSize.height)];
    [connectBtn setTag:indexPath.row];
    [connectBtn setTitle:@"Connect" forState:UIControlStateNormal];
[connectBtn addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:connectBtn];
    [connectBtn release];

    //blinkLedBtn
    UIButton* blinkLedBtn = [[UIButton alloc] initWithFrame:CGRectMake(cellSize.width - distanceBetween2Btns - btnSize.width, (cellSize.height - btnSize.height)/2, btnSize.width, btnSize.height)];
    [blinkLedBtn setTag:indexPath.row];
    [blinkLedBtn setTitle:@"Connect" forState:UIControlStateNormal];
    [blinkLedBtn addTarget:self action:@selector(blinkLed:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:blinkLedBtn];
    [blinkLedBtn release];

	return cell;
}

#pragma mark -
-(void) reloadBluetoothDevicesList
{
    self.bluetoothDevicesArray = ((BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance]).foundPeripherals;
    [self.bluetoothDevicesTable reloadData];
}

-(void) reloadBluetoothDevicesList:(NSArray *)bluetoothDeviceArray
{
    self.bluetoothDevicesArray = bluetoothDeviceArray;
    
    [self.bluetoothDevicesTable reloadData];
}

#pragma mark - private methods
-(void) connect:(id)sender
{
    int index = ((UIButton*)sender).tag;

    CBPeripheral* peripheral = (CBPeripheral*)[_bluetoothDevicesArray objectAtIndex:index];
    if (![peripheral isConnected]) {
        [((BLEDiscoveryHelper*)[BLEDiscoveryHelper sharedInstance]).centralManager connectPeripheral:peripheral options:nil];
    }
}

-(void) blinkLed:(id)sender
{
    int index = ((UIButton*)sender).tag;

    [[BLEDiscoveryHelper sharedInstance] sendCommand:k_command_lock];
}

@end
