//
//  ButtonWithCallOut.m
//  StickMe
//
//  Created by admin on 12/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ButtonWithCallOut.h"
#import "Defines.h"

@interface ButtonWithCallOut ()

-(void)popupCalloutView;

@end

@implementation ButtonWithCallOut

@synthesize callOut = _callOut;

-(id)initWithFrame:(CGRect)frame
{
//    NSLog(@"alo1");
    self = [super initWithFrame:frame];
    if (self) {
//        NSLog(@"alo2");

//        UIButton *topDisclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [topDisclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disclosureTapped)]];

        SMCalloutView* calloutView = [SMCalloutView new];
//        calloutView.rightAccessoryView = topDisclosure;
        calloutView.calloutOffset = CGPointMake(OBJ_ICON_SIZE/2, 5);

        self.callOut = calloutView;
        [calloutView release];
    }
    return self;
}

-(void)dealloc
{
//    NSLog(@"ButtonWithCallOut dealloc");
    [self.callOut dismissCalloutAnimated:NO];
    self.callOut = nil;

    [super dealloc];
}

-(void) onTapped
{
    if (!self.callOut) {
        NSLog(@"no CallOut");
        return;
    }
//    NSLog(@"onTapped");
    if (!_callOut.window)
        [self performSelector:@selector(popupCalloutView) withObject:nil afterDelay:1.0/3.0];
    else {
//        NSLog(@"dismiss %@", self.callOut.title);
        [_callOut dismissCalloutAnimated:YES];
    }
}

- (void)popupCalloutView {
    if (!self.callOut || !_callOut.delegate) {
        NSLog(@"no CallOut / CallOut's delegate");
        return;
    }
//    NSLog(@"popupCalloutView");
    UIViewController* delegateVC = (UIViewController*)_callOut.delegate;
    // This does all the magic.
    [_callOut presentCalloutFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y, 1, 1)
                             inView:delegateVC.view
                  constrainedToView:delegateVC.view
           permittedArrowDirections:SMCalloutArrowDirectionDown
                           animated:YES];
}

@end
