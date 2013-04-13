//
//  ViewController.m
//  WCAlertViewDemo
//
//  Created by Jesse Squires on 4/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//

#import "ViewController.h"
#import "WCAlertView.h"

@interface ViewController ()
@end



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)buttonPressed:(UIButton *)sender
{
    WCAlertView *alert = [WCAlertView alertWithTitle:@"Alert Title"
                                             message:@"This is a message body. This is a message body. This is a message body. This is a message body."
                                            delegate:nil
                                   cancelButtonTitle:@"Cancel"
                                  customizationBlock:^(WCAlertView *alertView) {
                                      alertView.style = sender.tag;
                                  }
                                   otherButtonTitles:@"Other1", @"Other2", nil];
    
    [alert show];
}

@end