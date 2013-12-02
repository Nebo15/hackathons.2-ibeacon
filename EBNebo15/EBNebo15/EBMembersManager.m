//
//  EBMembersManager.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/27/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBMembersManager.h"
#import "EBLoginManager.h"
#import "EBMember.h"
#import "EBNebo15APIClient.h"

@implementation EBMembersManager

+(EBMembersManager*)sharedManager
{
    static EBMembersManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[EBMembersManager alloc] init];
    });
    return _sharedManager;
}

- (NSArray*)fakeMembers
{
    EBMember* member1 = [[EBMember alloc] initWithMemberID:0 name:[[EBLoginManager sharedManager] facebookUserName] statusID:_userState updateDate:[NSDate date] facebookID:[[EBLoginManager sharedManager] facebookUserId]facebookLink:nil userPicLink:nil userEmail:nil];
    return @[member1];
}

- (void)setUserState:(CLRegionState)userState
{
    _userState = userState;
    
    [[EBNebo15APIClient sharedClient] checkInWithMember:[[EBLoginManager sharedManager] currentMember] completion:^(BOOL success) {
        
    }];
}

- (void)membersListWithCompletion:(void(^)(NSArray*))members
{
    [[EBNebo15APIClient sharedClient] getUserListWithCompletion:^(BOOL success, NSArray *membersArray) {
        if(membersArray)
            members(membersArray);
    }];
}

@end
