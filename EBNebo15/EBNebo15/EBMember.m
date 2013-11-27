//
//  EBMember.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/27/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBMember.h"

@implementation EBMember

- (id)initWithMemberID:(NSUInteger)memberID name:(NSString *)name statusID:(NSUInteger)statusID updateDate:(NSDate *)date facebookID:(NSString*)facebookID
{
    if (self = [super init]) {
        _memberID = memberID;
        _name = name;
        _statusID = statusID;
        _date = date;
        _facebookID = facebookID;
    }
    return self;
}

@end
