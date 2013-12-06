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
#import <Mantle/MTLJSONAdapter.h>

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
    EBMember* member1 = [[EBMember alloc] initWithMemberID:0 name:[[EBLoginManager sharedManager] facebookUserName] statusID:_userState updateDate:nil facebookID:[[EBLoginManager sharedManager] facebookUserId]facebookLink:nil userPicLink:nil userEmail:nil];
    return @[member1];
}

- (void)setUserState:(CLRegionState)userState completion:(void(^)(BOOL))completion
{
    _userState = userState;
    
    if (userState == CLRegionStateInside) {
        [[EBNebo15APIClient sharedClient] checkInWithMember:[[EBLoginManager sharedManager] currentMember] completion:^(BOOL success) {
            completion(success);
        }];
    }
    else
    {
        [[EBNebo15APIClient sharedClient] checkOutWithMember:[[EBLoginManager sharedManager] currentMember] completion:^(BOOL success) {
            completion(success);
        }];
    }
}

- (void)membersListWithCompletion:(void(^)(NSArray*))members
{
    [[EBNebo15APIClient sharedClient] getUserListWithCompletion:^(BOOL success, NSArray *membersArray) {
        if(membersArray)
        {
            NSMutableArray *memberModels = [NSMutableArray array];
            [membersArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error = nil;
                EBMember *member = [MTLJSONAdapter modelOfClass:EBMember.class fromJSONDictionary:obj error:&error];
                if (!error) {
                    [memberModels addObject:member];
                }
            }];
            members(memberModels);
        }
        else members(nil);
    }];
}

@end
