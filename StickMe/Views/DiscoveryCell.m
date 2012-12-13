//
//  DiscoveryCell.m
//  StickMe
//
//  Created by admin on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscoveryCell.h"

@implementation DiscoveryCell

@synthesize deviceName = _deviceName;
@synthesize connectStatusBtn = _connectStatusBtn;
@synthesize lightBtn = _lightBtn;

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
-(IBAction)connect:(id)sender
{}

-(IBAction)light:(id)sender
{}

@end
