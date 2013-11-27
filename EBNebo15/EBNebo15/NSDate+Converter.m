//
//  NSDate+Converter.m
//  ECommpay
//
//  Created by Evgen Bakumenko on 10/10/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "NSDate+Converter.h"

@implementation NSDate (Converter)

+ (NSString*)shortDateWithTimeInterval:(NSString *)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
   // [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd MMMM"];
    return [[formatter stringFromDate:date] lowercaseString];
}

+ (NSString*)longDateWithTimeInterval:(NSString *)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    return [formatter stringFromDate:date];
}

+ (NSString*)dateWithTimeInterval:(NSString *)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    return [formatter stringFromDate:date];
}

+ (NSString*)timeWithTimeInterval:(NSString *)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:date];
}

+ (NSString*)monthWithTimeInterval:(NSString *)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    return [formatter stringFromDate:date];
}

+ (NSString*)dayAndTimeWithTimeInterval:(NSString *)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE, HH:mm"];
    return [formatter stringFromDate:date];
}

+ (NSString*)dayAndTimeWithDate:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE, HH:mm"];
    return [formatter stringFromDate:date];
}

@end
