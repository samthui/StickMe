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
//#define DISTANCE_LBL_TAG    2
#define DISTANCE_PICKER_TAG    2
#define NAME_TEXTFIELD_TAG  3

@interface DetailStickedObjectViewController ()
{
    NSString* _UUID;
    
    BOOL _isEditingName;
}

@property (nonatomic, retain) NSString* UUID;

//-(void) switchConnectState:(id)sender;
-(void) switchConnectState;
-(void) light:(id)sender;
-(void) ring:(id)sender;
-(void) noticeInRange:(id)sender;
-(void) noticeOutRange:(id)sender;
-(void) setupDistance:(id)sender;

-(void) hideKeyboard:(id)sender;

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

-(void) viewWillDisappear:(BOOL)animated
{
    [self hideKeyboard:nil];

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BLEDiscoveryHelper* BLEDiscover = [BLEDiscoveryHelper sharedInstance];
    NSMutableArray* discoveredArray = BLEDiscover.discoveredStickedObjectsList;
    StickObject* stick = [discoveredArray objectAtIndex:_stickObjectIndex];
    self.UUID = [Utilities UUIDofPeripheral:stick.peripheral];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];   
    gestureRecognizer.cancelsTouchesInView = NO;// For selecting cell.
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    
    _isEditingName = NO;
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
                        if(_isEditingName)
                        {
                            [cell.textLabel setText:@""];
                        }
                        else {
                            StickObjectSummary* stickSummary = (StickObjectSummary*)[usersDevicesList objectAtIndex:_stickObjectIndex];
                            NSString* deviceName = stickSummary.name;
                            [cell.textLabel setText:deviceName];
                        }
                        
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
                    
//                    if (!hadConfigItem) {
//                        CGSize slideSize = CGSizeMake(80, 20);
//                        UISlider* distanceSlider = [[UISlider alloc] initWithFrame:CGRectMake(cell.frame.size.width - slideSize.width - 11, (cell.frame.size.height - slideSize.height)/2, slideSize.width, slideSize.height)];
//                        distanceSlider.tag = CONFIG_ITEM_TAG;
//                        [distanceSlider addTarget:self action:@selector(setupDistance:) forControlEvents:UIControlEventValueChanged];
//                        
//                        //set state
//                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
//                        [distanceSlider setValue:stickSummary.setupDistance / MAX_DISTANCE];
//                        
//                        [cell addSubview:distanceSlider];
//                        [distanceSlider release];
//                        
//                        //setupDistanceLbl
//                        UILabel* setupDistanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 50 - 80 - 2*11, 0, 50, cell.frame.size.height)];
//                        [setupDistanceLbl setTextAlignment:UITextAlignmentRight];
//                        [setupDistanceLbl setBackgroundColor:[UIColor clearColor]];
//                        setupDistanceLbl.tag = DISTANCE_LBL_TAG;
//                        [setupDistanceLbl setText:[NSString stringWithFormat:@"%im", stickSummary.setupDistance]];
//                        [cell addSubview:setupDistanceLbl];
//                        [setupDistanceLbl release];
//                    }
//                    else {
//                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
//                        
//                        UILabel* setupDistanceLbl = (UILabel*)[cell viewWithTag:DISTANCE_LBL_TAG];
//                        
//                        [setupDistanceLbl setText:[NSString stringWithFormat:@"%im", stickSummary.setupDistance]];
//                    }
                    
                    if (!hadConfigItem) {
                        CGSize btnSize = CGSizeMake(80, 20);
                        UIButton* setupDistanceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [setupDistanceBtn setFrame:CGRectMake(cell.frame.size.width - btnSize.width - 11, (cell.frame.size.height - btnSize.height)/2, btnSize.width, btnSize.height)];
                        setupDistanceBtn.tag = CONFIG_ITEM_TAG;
                        [setupDistanceBtn addTarget:self action:@selector(setupDistance:) forControlEvents:UIControlEventTouchUpInside];
                        
                        //set state
                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
                        [setupDistanceBtn setTitle:[NSString stringWithFormat:@"%i m", stickSummary.setupDistance] forState:UIControlStateNormal];
                        
                        [cell addSubview:setupDistanceBtn];
                    }
                    else {
                        NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
                        StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
                        
                        UIButton* setupDistanceBtn = (UIButton*)[cell viewWithTag:CONFIG_ITEM_TAG];
                        
                        [setupDistanceBtn setTitle:[NSString stringWithFormat:@"%i m", stickSummary.setupDistance] forState:UIControlStateNormal];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect cellFrame = cell.frame;
            CGSize cellSize = cellFrame.size;
            
            UIView* subView = [self.view viewWithTag:NAME_TEXTFIELD_TAG];
            if (!subView){
                UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(cellFrame.origin.x + 20, cellFrame.origin.y + 10, cellSize.width - 2*10 - 80, cellSize.height)];
                textField.tag = NAME_TEXTFIELD_TAG;
                textField.delegate = self;
                [textField setReturnKeyType:UIReturnKeyDone];
                [textField setTextAlignment:UITextAlignmentLeft];
                [self.view addSubview:textField];
                
                [textField becomeFirstResponder];
                [textField release];
            }
            else {
                UITextField* nameTextField = (UITextField*) subView;
                
                [nameTextField becomeFirstResponder];
            }
        }
    }
//    else if (indexPath.section == 3) {
//        if(indexPath.row == 1){
//            [self setupDistance:nil];
//        }
//    }
}

#pragma mark - Touch Events
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan:withEvent:");
//    [self.view endEditing:YES];
//    [super touchesBegan:touches withEvent:event];
//}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{   
    if ([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _isEditingName = YES;
    [self.detailTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    NSString* name = textField.text;

    [textField removeFromSuperview];
    
    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
    stickSummary.name = name;
    [UserDefaultsHelper saveToUserDefaultWithKey:(NSString*)kUUIDsList forArray:stickSummariesList];
        
    [self setTitle:name];

    _isEditingName = NO;
    [self.detailTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    return YES;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)componen{
    //save to UserDefault
    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
    stickSummary.setupDistance = row;
    [UserDefaultsHelper saveToUserDefaultWithKey:(NSString*)kUUIDsList forArray:stickSummariesList];
    
    [self.detailTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = MAX_DISTANCE + 1;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%i m", row];
}

// tell the picker the width of each row for a given component
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    int sectionWidth = 300;
//    
//    return sectionWidth;
//}

#pragma mark - private methods
-(void)hideKeyboard:(id)sender
{
    if(_isEditingName)
    {
        [self.view endEditing:YES];
        
        UITextField* subView = (UITextField*)[self.view viewWithTag:NAME_TEXTFIELD_TAG];
        if(subView)
        {
            [subView removeFromSuperview];
        }
        
        _isEditingName = NO;
        [self.detailTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else  {
        UIView* subView = [self.view viewWithTag:DISTANCE_PICKER_TAG];
        if(subView)
        {
            [subView removeFromSuperview];
        }
    }
}

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

//-(void)setupDistance:(id)sender
//{
//    UISlider* distanceSlider = (UISlider*) sender;
//    
//    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
//    StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
//    
//    stickSummary.setupDistance = distanceSlider.value * MAX_DISTANCE;
//    //    NSLog(@"stick.setupDistance: %i", stick.setupDistance);
//    
//    //set distance text
//    UITableViewCell* cell = (UITableViewCell*)[distanceSlider superview];
//    UIView* setupDistanceLbl = [cell viewWithTag:DISTANCE_LBL_TAG];
//    if (setupDistanceLbl && [setupDistanceLbl isKindOfClass:[UILabel class]]) {
//        [(UILabel*)setupDistanceLbl setText:[NSString stringWithFormat:@"%im", stickSummary.setupDistance]];
//    }
//    
//    [UserDefaultsHelper saveToUserDefaultWithKey:(NSString*)kUUIDsList forArray:stickSummariesList];
//}


-(void)setupDistance:(id)sender
{
    CGSize viewSize = self.view.frame.size;
    CGSize pickerSize = CGSizeMake(85, 177);
    int rightOffset = 10;
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(viewSize.width - pickerSize.width - rightOffset, viewSize.height - pickerSize.height + 10, pickerSize.width, pickerSize.height)];
    myPickerView.tag = DISTANCE_PICKER_TAG;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;

    NSMutableArray* stickSummariesList = [UserDefaultsHelper arrayFromUserDefaultWithKey:(NSString*)kUUIDsList];
    StickObjectSummary* stickSummary = [stickSummariesList objectAtIndex:_stickIndex];
    [myPickerView selectRow:stickSummary.setupDistance inComponent:0 animated:NO];

    [self.view addSubview:myPickerView];
    [myPickerView release];
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
