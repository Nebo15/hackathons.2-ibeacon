//
//  EBLoginManager.h
//  EBNebo15
//
//  Created by Evgen Bakumenko on 10/31/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBLoginManager : NSObject
+(EBLoginManager*)sharedManager;
- (void)loginWithFacebookWithCompletion:(void(^)(BOOL))completion;
- (NSString*)facebookUserId;
- (NSString*)facebookUserName;
- (BOOL)isUserLogined;

@end
