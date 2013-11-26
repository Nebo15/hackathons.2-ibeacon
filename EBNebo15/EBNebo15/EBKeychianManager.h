//
//  EBKeychianManager.h
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/25/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBKeychianManager : NSObject

+ (EBKeychianManager*)sharedManager;
- (void)addAccountWithName:(NSString*)account serviceName:(NSString*)service withSuccess:(void(^)(BOOL))success;
- (BOOL)isFacebookAccountExist;

@end
