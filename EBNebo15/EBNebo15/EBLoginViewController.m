//
//  EBLoginViewController.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 10/31/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBLoginViewController.h"
#import "EBLoginManager.h"

@interface EBLoginViewController ()
@property (strong, nonatomic) IBOutlet UILabel *pv_helloLbl;
@property (strong, nonatomic) IBOutlet UIButton *pv_FBLoginBtn;

@end

@implementation EBLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupView];
}

- (void)setupView
{
    self.pv_helloLbl.text = @"Йоу, йоу, йоу\nТебя приветствует аппликуха Nebo #15!\nЗалогинся без напряга :)";
    
    [self.pv_FBLoginBtn setTitle:@"Логин юзинг Facebook" forState:UIControlStateNormal];
}

- (IBAction)loginButtonClicked:(id)sender {
    [[EBLoginManager sharedManager] loginWithFacebookWithCompletion:^(BOOL success) {
        
    }];
}
@end
