//
//  EBMembersManager.h
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/27/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface EBMembersManager : NSObject

@property (nonatomic, readonly, assign) CLRegionState userState;
+ (EBMembersManager*)sharedManager;
- (NSArray*)fakeMembers;
- (void)setUserState:(CLRegionState)userState;
- (void)membersListWithCompletion:(void(^)(NSArray*))members;

@end
