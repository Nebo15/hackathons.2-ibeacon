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

@interface EBDashboardViewController ()<CLLocationManagerDelegate>

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
    
    //check for available ibeacons
    if([self locationGeofenceAvailalbe])
    {
        //init location manager
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //create region which include office coordinates
        
    }
    
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

- (CLRegion*)dictToRegion:(NSDictionary*)dictionary
{
    NSString *identifier = @"Nebo15RegionIdentifier";
//    CLLocationDegrees latitude = 50.445604;   //nebo15 address
//    CLLocationDegrees longitude = 30.495987;
    
    CLLocationDegrees latitude = 50.43045;   //my home address
    CLLocationDegrees longitude =  30.48002;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationDistance regionRadius = [[dictionary valueForKey:@"radius"] doubleValue];
    
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
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

@end