//
//  TLViewController.m
//  TLAlertView
//
//  Created by Ash Furrow on 2013-07-11.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import "TLViewController.h"
#import "TLAlertView.h"
#import "TLDemoViewController.h"

@interface TLViewController ()

@property (nonatomic, strong) id ownedViewController;

@end

@implementation TLViewController

-(IBAction)showSystemAlert:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

-(IBAction)showAlert:(id)sender {
    TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Title" message:@"Message" buttonTitle:@"OK"];
    [alertView show];
}

-(IBAction)showAlertCustomView:(id)sender {
    TLDemoViewController *demoVC = [[TLDemoViewController alloc] initWithNibName:@"TLDemoViewController" bundle:[NSBundle mainBundle]];
    TLAlertView *alertView = [[TLAlertView alloc] initWithView:demoVC.view outsideClose:YES];
    [alertView show];
    self.ownedViewController = demoVC;
}

@end