//
//  EBLoginViewController.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 10/31/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBLoginViewController.h"
#import "EBLoginManager.h"
#import "EBKeychianManager.h"
#import "EBDashboardViewController.h"
#import "EBAppDelegate.h"

@interface EBLoginViewController ()

@property (strong, nonatomic) IBOutlet UILabel *pv_helloLbl;
@property (strong, nonatomic) IBOutlet UIButton *pv_FBLoginBtn;

@end

@implementation EBLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[EBLoginManager sharedManager] isUserLogined]) {
        [self tryFacebookLogin];
    }
    else
    {
        [self setupView];
    }
}

- (void)setupView
{
    self.pv_helloLbl.text = @"Йоу, йоу, йоу\nТебя приветствует аппликуха Nebo #15!\nЗалогинся без напряга :)";
    
    [self.pv_FBLoginBtn setTitle:@"Логин юзинг Facebook" forState:UIControlStateNormal];
    [self.pv_FBLoginBtn setHidden:NO];
}

- (void)tryFacebookLogin
{
    [[EBLoginManager sharedManager] loginWithFacebookWithCompletion:^(BOOL success) {
        if (success) {
            [(EBAppDelegate*)[[UIApplication sharedApplication] delegate] setDashboardToRootViewController];
        }
    }];
}

- (IBAction)loginButtonClicked:(id)sender {
    [self tryFacebookLogin];
}
@end
