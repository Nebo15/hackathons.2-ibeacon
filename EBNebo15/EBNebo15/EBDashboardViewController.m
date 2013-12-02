//
//  EBDashboardViewController.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/25/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBDashboardViewController.h"
#import "EBLoginManager.h"
#import "EBMembersManager.h"
#import <FBProfilePictureView.h>
#import "ArrayDataSource.h"
#import "EBMemberCell.h"
#import "EBNebo15APIClient.h"
@import CoreLocation;

static NSString* const kMemberCellIdentifier = @"kMemberCellIdentifier";

@interface EBDashboardViewController ()<CLLocationManagerDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet FBProfilePictureView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *userListLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITableView *pv_membersTableView;
@property (strong, nonatomic) ArrayDataSource* membersDataSources;

@end

@implementation EBDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Nebo #15";
    [self setupViewWithRegionState:CLRegionStateOutside];
    [self setupTableView];
    //check for available ibeacons
    if([self locationGeofenceAvailalbe])
    {
        //init location manager
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startMonitoringForRegion:[self officeRegion]];
    }
}

- (void)setupViewWithRegionState:(CLRegionState)state
{
    //setup user profile picture view
    self.userAvatarImageView.profileID = [[EBLoginManager sharedManager] facebookUserId];
    self.userAvatarImageView.pictureCropping = FBProfilePictureCroppingSquare;
    self.userAvatarImageView.layer.cornerRadius = 50.0;
    
    NSString *statusString;
    UIColor *statusColor;
    switch (state) {
        case CLRegionStateOutside:
            statusString = @"Не в офисе :(";
            statusColor = UIColor.redColor;
            break;
        case CLRegionStateInside:
            statusString = @"В офисе :)";
            statusColor = UIColor.greenColor;
            break;
        default:
            statusString = @"Чехлюсь...";
            statusColor = UIColor.grayColor;
            break;
    }

    
    //setup labels
    self.userNameLabel.text = [NSString stringWithFormat:@"Вы вошли как: %@",[[EBLoginManager sharedManager] facebookUserName]];
    self.userNameLabel.preferredMaxLayoutWidth = 200;
    self.userStatusLabel.text = [NSString stringWithFormat:@"Статус: %@",statusString];
    self.userStatusLabel.textColor = statusColor;
    self.userStatusLabel.preferredMaxLayoutWidth = 200;
    self.userListLabel.text  = @"Кто в офисе?";
    
    //save state
    [[EBMembersManager sharedManager] setUserState:CLRegionStateInside];
    
    //reload tableView
    [self setupTableView];
}

- (void)setupTableView
{
    TableViewCellConfigureBlock configureCell = ^(EBMemberCell *cell, EBMember *member) {
        [cell configureCellWithMember:member];
    };
    
    [[EBMembersManager sharedManager] membersListWithCompletion:^(NSArray * members) {
        self.membersDataSources = [[ArrayDataSource alloc] initWithItems:members cellIdentifier:kMemberCellIdentifier configureCellBlock:configureCell];
        self.pv_membersTableView.dataSource = self.membersDataSources;
        self.pv_membersTableView.delegate = self;
        [self.pv_membersTableView registerNib:[EBMemberCell nib] forCellReuseIdentifier:kMemberCellIdentifier];
        [self.pv_membersTableView reloadData];
    }];
}

#pragma mark - Location geofence
- (BOOL)locationGeofenceAvailalbe
{
    if(![CLLocationManager locationServicesEnabled])
    {
        //You need to enable Location Services
        return NO;
    }
    if([CLLocationManager isMonitoringAvailableForClass:self.class])
    {
        //Region monitoring is not available for this Class;
        return NO;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        //You need to authorize Location Services for the APP
        return NO;
    }
    return YES;
}

- (CLRegion*)officeRegion
{
    NSString *identifier = @"Nebo15RegionIdentifier";
    CLLocationDegrees latitude = 50.44589953;   //nebo15 address
    CLLocationDegrees longitude = 30.49678882;
    
//    CLLocationDegrees latitude = 50.43045;   //my home address
//    CLLocationDegrees longitude =  30.48002;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationDistance regionRadius = 200.0;
    
    if(regionRadius > _locationManager.maximumRegionMonitoringDistance)
    {
        regionRadius = _locationManager.maximumRegionMonitoringDistance;
    }
    
    CLRegion *region =  [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                    radius:regionRadius
                                                identifier:identifier];
    return region;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self setupViewWithRegionState:CLRegionStateInside];
    
    //checkin user
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self setupViewWithRegionState:CLRegionStateOutside];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [manager requestStateForRegion:[self officeRegion]];
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    [self setupViewWithRegionState:state];
    if (state == CLRegionStateUnknown) {
        [manager requestStateForRegion:[self officeRegion]];
    }
}

@end