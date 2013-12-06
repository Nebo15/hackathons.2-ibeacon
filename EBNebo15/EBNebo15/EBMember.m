//
//  EBMember.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/27/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBMember.h"
#import <Mantle/MTLValueTransformer.h>

static NSString *const EBMemberFacebookIDJSONTransformer = @"facebookIDJSONTransformer";

@implementation EBMember

- (id)initWithMemberID:(NSUInteger)memberID name:(NSString *)name statusID:(NSUInteger)statusID updateDate:(NSString *)dateTimeInteval facebookID:(NSString *)facebookID facebookLink:(NSString *)facebookLink userPicLink:(NSString *)userPicLink userEmail:(NSString *)userEmail
{
    if (self = [super init]) {
        _memberID = memberID;
        _name = name;
        _statusID = statusID;
        _dateTimeInteval = dateTimeInteval;
        _facebookID = facebookID;
        _link = facebookLink;
        _userpic = userPicLink;
        _email = userEmail;
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"dateTimeInteval": @"last_login_stamp",
             @"name": @"name",
             @"userpic": @"userpic",
             @"link": @"website"
             };
}

@end
