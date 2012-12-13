//
//  DiscoveryCell.h
//  StickMe
//
//  Created by admin on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiscoveryCell;

@interface DiscoveryCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel* deviceName;
@property (nonatomic, retain) IBOutlet UIButton* connectStatusBtn;
@property (nonatomic, retain) IBOutlet UIButton* lightBtn;

-(IBAction)connect:(id)sender;
-(IBAction)light:(id)sender;

@end
