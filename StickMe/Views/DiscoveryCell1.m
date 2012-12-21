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
@synthesize waveView = _waveView;
@synthesize connectStatusBtn = _connectStatusBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"WaveStrengthView" owner:self options:nil];
//        self.waveView = [nib objectAtIndex:0];
//        [self.waveView setFrame:CGRectMake(175, 0, 40, 44)];
//        [self addSubview:_waveView];
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
