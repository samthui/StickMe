//
//  DiscoveryCell1.m
//  StickMe
//
//  Created by admin on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscoveryCell1.h"

@implementation DiscoveryCell1

@synthesize deviceName = _deviceName;
@synthesize distanceLbl = _distanceLbl;
@synthesize connectStatusBtn = _connectStatusBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions
-(IBAction)connectClicked:(id)sender
{
    [self.connectStatusBtn setTitle:@"..." forState:UIControlStateNormal];    
}

@end
