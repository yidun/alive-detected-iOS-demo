//
//  NSString+NTESLiveDetect.m
//  NTESLiveDetectPublicDemo
//
//  Created by 罗礼豪 on 2022/3/16.
//  Copyright © 2022 Ke Xu. All rights reserved.
//

#import "NSString+NTESLiveDetect.h"

@implementation NSString (NTESLiveDetect)

+ (BOOL)firstIsRGB:(NSString *)strValue
{
    if (strValue == nil || [strValue length] <= 0)
    {
        return NO;
    }
    
    NSString *first = [strValue substringWithRange:NSMakeRange(0, 1)];
    if ([@"r" isEqualToString:first] || [@"g" isEqualToString:first] || [@"b" isEqualToString:first]) {
        return YES;
    } else {
        return NO;
    }
}

 
@end
