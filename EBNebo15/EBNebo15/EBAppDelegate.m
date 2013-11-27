
//
//  EBAppDelegate.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 10/31/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBAppDelegate.h"
#import "EBLoginViewController.h"
#import "EBDashboardViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <Facebook.h>

@implementation EBAppDelegate
{
    CLLocationManager* _locationManager;
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // Override point for customization after application launch.
    [FBProfilePictureView class];
    
    // This location manager will be used to notify the user of region state transitions.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[EBLoginViewController new]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

- (void)setDashboardToRootViewController
{
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[EBDashboardViewController new]];
    self.navigationController.navigationBar.translucent = NO;
    self.window.rootViewController = self.navigationController;
}

#pragma mark - CoreLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    // A user can transition in or out of a region while the application is not running.
    // When this happens CoreLocation will launch the application momentarily, call this delegate method
    // and we will let the user know via a local notification.
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(state == CLRegionStateInside)
    {
        notification.alertBody = @"You're inside the region";
    }
    else if(state == CLRegionStateOutside)
    {
        notification.alertBody = @"You're outside the region";
    }
    else
    {
        return;
    }
    
    // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
    // If its not, iOS will display the notification to the user.
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
    
#pragma mark - FBSession managment
    
    /*
     * Opens a Facebook session and optionally shows the login UX.
     */
- (void)openSessionWithAllowLoginUI:(BOOL)allowLoginUI completion:(void(^)(BOOL))completion
{
        NSArray *permissions = @[@"email"];
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI
                                             completionHandler:^(FBSession *session,
                                                                 FBSessionState state,
                                                                 NSError *error) {
                                                 [self sessionStateChanged:session
                                                                     state:state
                                                                     error:error];
                                                 completion(!error);
                                             }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        if (!error)
        {
            [FBSession setActiveSession:session];
            NSLog(@"User session found");
        }
        break;
        case FBSessionStateClosed:
        break;
        case FBSessionStateClosedLoginFailed:
        {
            //[FBSession.activeSession closeAndClearTokenInformation];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No permission"
                                      
                                                                message:nil
                                      
                                                               delegate:self
                                      
                                                      cancelButtonTitle:@"OK"
                                      
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];
        }
        break;
        default:
        break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
}

@end
