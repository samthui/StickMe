//
//  DiscoveryCell1.h
//  StickMe
//
//  Created by admin on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveStrengthView.h"

@interface DiscoveryCell1 : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel* deviceName;
@property (nonatomic, retain) IBOutlet UILabel* distanceLbl;
@property (nonatomic, retain) IBOutlet WaveStrengthView* waveView;
@property (nonatomic, retain) IBOutlet UIButton* connectStatusBtn;

-(IBAction)connectClicked:(id)sender;

@end
