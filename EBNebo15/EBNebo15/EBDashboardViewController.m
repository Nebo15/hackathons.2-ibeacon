//
//  EBDashboardViewController.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/25/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBDashboardViewController.h"
#import "EBLoginManager.h"
#import <FBProfilePictureView.h>
@import CoreLocation;

@interface EBDashboardViewController ()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *userListLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation EBDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self setupTableView];
}

- (void)setupView
{
    //setup user profile picture view
    self.userAvatarImageView.profileID = [[EBLoginManager sharedManager] facebookUserId];
    self.userAvatarImageView.pictureCropping = FBProfilePictureCroppingSquare;
    self.userAvatarImageView.layer.cornerRadius = 50.0;
    
    //setup labels
    self.userNameLabel.text = [NSString stringWithFormat:@"Вы вошли как: %@",[[EBLoginManager sharedManager] facebookUserName]];
    self.userNameLabel.preferredMaxLayoutWidth = 200;
    self.userStatusLabel.text = @"Статус: Не в офисе :(";
    self.userStatusLabel.preferredMaxLayoutWidth = 200;
    self.userListLabel.text  = @"Кто в офисе?";
}

- (void)setupTableView
{
    
}

@end