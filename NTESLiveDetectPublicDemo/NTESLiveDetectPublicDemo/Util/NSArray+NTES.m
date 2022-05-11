//
//  NSArray+NTES.m
//  NTESLiveDetectPublicDemo
//
//  Created by 罗礼豪 on 2022/4/13.
//  Copyright © 2022 Ke Xu. All rights reserved.
//

#import "NSArray+NTES.h"

@implementation NSArray (NTES)

- (id)ntes_objectAtIndex: (NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
   
}

@end
