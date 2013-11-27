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
    EBMember* member1 = [[EBMember alloc] initWithMemberID:0 name:[[EBLoginManager sharedManager] facebookUserName] statusID:_userState updateDate:[NSDate date] facebookID:[[EBLoginManager sharedManager] facebookUserId]];
    return @[member1];
}

- (void)setUserState:(CLRegionState)userState
{
    _userState = userState;
}

@end
