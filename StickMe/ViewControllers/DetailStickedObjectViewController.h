//
//  DetailStickedObjectViewController.h
//  StickMe
//
//  Created by admin on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailStickedObjectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView* detailTable;
@property (nonatomic, assign) unsigned short stickObjectIndex;

@end
