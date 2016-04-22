//
//  CommenMethod.m
//  YXWealth
//
//  Created by yixin on 16/4/13.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "CommenMethod.h"

@implementation CommenMethod


+ (NSString *)getCurrentTime
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //[dateformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateformatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    NSString * locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

@end
