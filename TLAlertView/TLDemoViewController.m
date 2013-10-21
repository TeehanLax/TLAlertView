//
//  TLDemoViewController.m
//  TLAlertView
//
//  Created by Mayoral on 10/21/13.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import "TLDemoViewController.h"

@interface TLDemoViewController ()

@end

@implementation TLDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapTest:(id)sender
{
    NSLog(@"tapped!");
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test button" message:@"tapped!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    //[alert show];
}

@end
