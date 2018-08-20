//
//  NSDate+DateString.m
//  AutoUploadTools
//
//  Created by shun on 2018/6/12.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "NSDate+DateString.h"
#import "NSDate+Utilities.h"

@implementation NSDate (DateString)

- (NSString *)getOffTime {
    if (self.isToday && [self isEarlierThanDate:[[NSDate alloc] init]]) {
        NSInteger delta = [self minutesBeforeDate:[NSDate date]];
        if (delta == 0) {
            return @"刚刚";
        } else if (delta < 60) {
            return [NSString stringWithFormat:@"%ld分钟前",(long)delta];
        } else {
            return [NSString stringWithFormat:@"%ld小时前",(long)[self hoursBeforeDate:[NSDate date]]];
        }
        
    }
    
    if (self.isYesterday) {
        return [self stringWithFormat:@"昨天 hh:mm"];
    }
    
    if (self.isInPast) {
        return self.shortDateString;
    }
    
    return nil;
}
@end
