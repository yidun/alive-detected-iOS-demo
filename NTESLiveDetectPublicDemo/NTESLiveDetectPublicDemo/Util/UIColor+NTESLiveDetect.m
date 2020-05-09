//
//  UIColor+NTESLiveDetect.m
//  NTESLiveDetectPublicDemo
//
//  Created by 罗礼豪 on 2020/4/21.
//  Copyright © 2020 Ke Xu. All rights reserved.
//

#import "UIColor+NTESLiveDetect.h"

@implementation UIColor (NTESLiveDetect)

+ (nullable UIColor *)ntes_colorWithHexString:(NSString *)string {
    return [self ntes_colorWithHexString:string alpha:1.0f];
}

+ (nullable UIColor *)ntes_colorWithHexString:(NSString *)string alpha:(CGFloat)alpha {
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([pureHexString hasPrefix:[@"#" uppercaseString]] || [pureHexString hasPrefix:[@"#" lowercaseString]]) {
        pureHexString = [pureHexString substringFromIndex:1];
    }
    
    CGFloat r, g, b, a;
    if (ntes_hexStrToRGBA(string, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

static BOOL ntes_hexStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    str = [[str stringByTrimmingCharactersInSet:set] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = ntes_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = ntes_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = ntes_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4) {
            *a = ntes_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        } else {
            *a = 1;
        }
    } else {
        *r = ntes_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = ntes_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = ntes_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) {
            *a = ntes_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        } else {
            *a = 1;
        }
    }
    return YES;
}

static inline NSUInteger ntes_hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

@end
