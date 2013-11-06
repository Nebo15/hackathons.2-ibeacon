//
//  EBLoginManager.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 10/31/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBLoginManager.h"
#import "EBAppDelegate.h"
#import <Facebook.h>
@import Accounts;
@import Social;

@interface EBLoginManager()
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccount *facebookAccount;
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
                                               options:@{ACFacebookAppIdKey: fbAppId, ACFacebookPermissionsKey: @[@"email"]}
                                            completion:^(BOOL granted, NSError *error) {
                                                if(granted){
                                                    NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                    _facebookAccount = [accounts lastObject];
                                                    NSLog(@"Success");
                                                    
                                                    [self loginWithGraph];
                                                }else{
                                                    // ouch
                                                    NSLog(@"Fail");
                                                    NSLog(@"Error: %@", error);
                                                    [self performSelectorOnMainThread:@selector(loginWithApp) withObject:nil waitUntilDone:NO];
                                                }
                                            }];
        
    }
    else
    {
        [self loginWithApp];
    }

}

- (void)loginWithApp
{
  if (FBSessionStateOpen != FBSession.activeSession.state)
  {
      EBAppDelegate *appDelegate = (EBAppDelegate*)[[UIApplication sharedApplication] delegate];
      [appDelegate openSessionWithAllowLoginUI:YES];
      return;
  }
  [[FBRequest requestForMe] startWithCompletionHandler:
   ^(FBRequestConnection *connection,
     NSDictionary<FBGraphUser> *user,
     NSError *error) {
       if (!error) {
           //login with user
       }
   }];
}
    
- (void)loginWithGraph
{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = _facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSError* err;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              
                              options:kNilOptions 
                              error:&err];
        
        if (!json[@"email"]) {
            return;
        }
        else
        {
            NSLog(@"%@", json);
            if (error || [json objectForKey:@"error"]) {
                //Login user there
            }
        }
    }];
}
    
@end
