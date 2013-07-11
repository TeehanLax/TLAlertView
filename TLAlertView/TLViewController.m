//
//  TLViewController.m
//  TLAlertView
//
//  Created by Ash Furrow on 2013-07-11.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import "TLViewController.h"
#import "TLAlertView.h"

@interface TLViewController ()

@end

@implementation TLViewController

-(IBAction)showAlert:(id)sender {
    TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Title" message:@"Message" buttonTitle:@"OK"];
    [alertView show];
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alertView show];
}

@end