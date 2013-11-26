//
//  EBKeychianManager.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/25/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBKeychianManager.h"
#import <SSKeychain/SSKeychain.h>

@interface EBKeychianManager()

@end

@implementation EBKeychianManager

+(EBKeychianManager*)sharedManager
{
    static EBKeychianManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[EBKeychianManager alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Accounts without password

- (void)addAccountWithName:(NSString *)account serviceName:(NSString *)service withSuccess:(void (^)(BOOL))success
{
    success([SSKeychain setPassword:@"1234" forService:service account:account]);
}

- (BOOL)isFacebookAccountExist
{
    return [[SSKeychain accountsForService:@"Facebook"] count] > 0;
}

@end
