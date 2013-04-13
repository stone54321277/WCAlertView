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

#pragma mark - View lifecyle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions
- (void)buttonPressed:(UIButton *)sender
{
    WCAlertView *alert = [WCAlertView alertWithTitle:@"Alert Title"
                                             message:@"This is a message body. This is a message body. This is a message body. This is a message body."
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                                  customizationBlock:^(WCAlertView *alertView) {
                                      alertView.style = sender.tag;
                                  }
                                   otherButtonTitles:@"Other1", @"Other2", nil];
    
    [alert show];
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex");
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"willPresentAlertView");
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"didPresentAlertView");
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismissWithButtonIndex");
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");
}

@end