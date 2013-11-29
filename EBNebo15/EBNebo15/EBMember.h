//
//  EBMember.h
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/27/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>

@interface EBMember : MTLModel

- (id)initWithMemberID:(NSUInteger)memberID name:(NSString*)name statusID:(NSUInteger)statusID updateDate:(NSDate*)date facebookID:(NSString*)facebookID facebookLink:(NSString*)facebookLink userPicLink:(NSString*)userPicLink userEmail:(NSString*)userEmail;;

@property (nonatomic, assign) NSUInteger memberID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger statusID;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *facebookID;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *userpic;
@property (nonatomic, copy) NSString *email;

@end
