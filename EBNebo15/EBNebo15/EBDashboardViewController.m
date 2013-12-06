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
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reloadMembersList:)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
}

- (void)setupViewWithRegionState:(CLRegionState)state
{
    //setup user profile picture view
    _userAvatarImageView.profileID = [[EBLoginManager sharedManager] facebookUserId];
    _userAvatarImageView.pictureCropping = FBProfilePictureCroppingSquare;
    _userAvatarImageView.layer.cornerRadius = 50.0;
    
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
    _userNameLabel.text = [NSString stringWithFormat:@"Вы вошли как: %@",[[EBLoginManager sharedManager] facebookUserName]];
    _userNameLabel.preferredMaxLayoutWidth = 200;
    _userStatusLabel.text = [NSString stringWithFormat:@"Статус: %@",statusString];
    _userStatusLabel.textColor = statusColor;
    _userStatusLabel.preferredMaxLayoutWidth = 200;
    _userListLabel.text  = @"Кто в офисе?";
    
    //save state
    [[EBMembersManager sharedManager] setUserState:state completion:^(BOOL finished) {
        //reload tableView
        if (state != CLRegionStateUnknown) {
            [self setupTableView];
        }
    }];
}

- (void)setupTableView
{
    TableViewCellConfigureBlock configureCell = ^(EBMemberCell *cell, EBMember *member) {
        [cell configureCellWithMember:member];
    };
    
    [[EBMembersManager sharedManager] membersListWithCompletion:^(NSArray * members) {
        _membersDataSources = [[ArrayDataSource alloc] initWithItems:members cellIdentifier:kMemberCellIdentifier configureCellBlock:configureCell];
        _pv_membersTableView.dataSource = self.membersDataSources;
        _pv_membersTableView.delegate = self;
        [_pv_membersTableView registerNib:[EBMemberCell nib] forCellReuseIdentifier:kMemberCellIdentifier];
        [_pv_membersTableView reloadData];
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

- (IBAction)reloadMembersListClicked:(id)sender
{
    UIButton *btn = sender;
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 1;
    fullRotation.repeatCount = 3;
    [btn.layer addAnimation:fullRotation forKey:@"360"];
    [self setupTableView];
}

#pragma mark - Notifications

- (void)reloadMembersList:(NSNotification *)ntf
{
    [self setupTableView];
}

@end