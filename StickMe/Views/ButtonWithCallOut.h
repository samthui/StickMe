//
//  ButtonWithCallOut.h
//  StickMe
//
//  Created by admin on 12/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCalloutView.h"

@interface ButtonWithCallOut : UIButton

@property (nonatomic, retain) SMCalloutView* callOut;

-(void) onTapped;

@end
