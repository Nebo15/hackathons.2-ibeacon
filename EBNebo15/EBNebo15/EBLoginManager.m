//
//  EBLoginManager.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 10/31/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBLoginManager.h"
#import "EBKeychianManager.h"
#import "EBAppDelegate.h"
#import <Facebook.h>
@import Accounts;
@import Social;

static NSString *const EBFacebookGraphLoginURL  = @"https://graph.facebook.com/me";
static NSString *const kFacebookLoginEmail = @"email";
static NSString *const kFacebookLoginError = @"error";
static NSString *const kFacebookName = @"name";
static NSString *const kFacebookUserId = @"id";

@interface EBLoginManager()
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccount *facebookAccount;
@property (nonatomic, strong) NSDictionary *user;
@end

@implementation EBLoginManager

+(EBLoginManager*)sharedManager
{
    static EBLoginManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[EBLoginManager alloc] init];
    });
    return _sharedManager;
}
    
- (void)loginWithFacebookWithCompletion:(void(^)(BOOL))completion
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString* fbAppId = dict[@"FacebookAppID"];
    
    if(!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    if (facebookTypeAccount) {
        [_accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                               options:@{ACFacebookAppIdKey: fbAppId, ACFacebookPermissionsKey: @[kFacebookLoginEmail]}
                                            completion:^(BOOL granted, NSError *error) {
                                                if(granted){
                                                    NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                    _facebookAccount = [accounts lastObject];
                                                    NSLog(@"Success");
                                                    
                                                    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                                                              requestMethod:SLRequestMethodGET
                                                                                                        URL:[NSURL URLWithString:EBFacebookGraphLoginURL]
                                                                                                 parameters:nil];
                                                    
                                                    merequest.account = _facebookAccount;
                                                    
                                                    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                                        NSError* err;
                                                        NSDictionary* json = [NSJSONSerialization
                                                                              JSONObjectWithData:responseData
                                                                              
                                                                              options:kNilOptions
                                                                              error:&err];
                                                        if (!json[kFacebookLoginEmail]) {
                                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                [self loginUsingNativeAppWithCompletion:^(BOOL success) {
                                                                    completion(success);
                                                                }];
                                                            }];
                                                        }
                                                        else
                                                        {
                                                            NSLog(@"%@", json);
                                                            _user = json;
                                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                //save email to keychain
                                                                [[EBKeychianManager sharedManager] addAccountWithName:json[kFacebookLoginEmail] serviceName:@"Facebook"  withSuccess:^(BOOL success) {
                                                                    NSLog(@"Login success: %@", success?@"YES":@"NO");
                                                                }];
                                                                
                                                                completion(YES);
                                                            }];
                                                        }
                                                    }];
                                                    
                                                }else{
                                                    // ouch
                                                    NSLog(@"Fail");
                                                    NSLog(@"Error: %@", error);
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                        [self loginUsingNativeAppWithCompletion:^(BOOL success) {
                                                            completion(success);
                                                        }];
                                                    }];
                                                }
                                            }];
        
    }
    else
    {
        [self loginUsingNativeAppWithCompletion:^(BOOL success) {
            completion(success);
        }];
    }
}

//login using Facebook SDK or Native app
- (void)loginUsingNativeAppWithCompletion:(void(^)(BOOL))completion
{
  if (FBSessionStateOpen != FBSession.activeSession.state)
  {
      EBAppDelegate *appDelegate = (EBAppDelegate*)[[UIApplication sharedApplication] delegate];
      [appDelegate openSessionWithAllowLoginUI:YES completion:^(BOOL success) {
          [[FBRequest requestForMe] startWithCompletionHandler:
           ^(FBRequestConnection *connection,
             NSDictionary<FBGraphUser> *user,
             NSError *error) {
               if (!error) {
                   _user = user;
                   [[EBKeychianManager sharedManager] addAccountWithName:user[kFacebookLoginEmail] serviceName:@"Facebook"  withSuccess:^(BOOL success) {
                       NSLog(@"Login success: %@", success?@"YES":@"NO");
                   }];
                   completion(YES);
               }
           }];
      }];
  }
}

- (NSString*)facebookUserId
{
    if (!_user) {
        return nil;
    }
    else return _user[kFacebookUserId];
}

- (NSString*)facebookUserName
{
    if (!_user) {
        return nil;
    }
    else return _user[kFacebookName];
}

- (BOOL)isUserLogined
{
    return [[EBKeychianManager sharedManager] isFacebookAccountExist];
}

@end
