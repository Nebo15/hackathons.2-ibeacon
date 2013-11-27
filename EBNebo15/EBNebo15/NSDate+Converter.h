//
//  NSDate+Converter.h
//  ECommpay
//
//  Created by Evgen Bakumenko on 10/10/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Converter)
+ (NSString*)shortDateWithTimeInterval:(NSString*)interval;  //  DD mm
+ (NSString*)longDateWithTimeInterval:(NSString*)interval;   //  mmmm DD, YYYY
+ (NSString*)dateWithTimeInterval:(NSString *)interval;     // mm dd yyyy
+ (NSString*)timeWithTimeInterval:(NSString *)interval;    //DD
+ (NSString*)monthWithTimeInterval:(NSString *)interval;    //mm
+ (NSString*)dayAndTimeWithTimeInterval:(NSString*)interval;
+ (NSString*)dayAndTimeWithDate:(NSDate*)date;
@end
