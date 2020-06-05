//
//  LDDemoDefines.h
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/10.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#ifndef LDDemoDefines_h
#define LDDemoDefines_h

//#define TEST_ENV

#ifndef __OPTIMIZE__
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) {}
#endif

#define WeakSelf(type) __weak __typeof__(type) weakSelf = type;
#define StrongSelf(type) __strong __typeof__(type) strongSelf = type;

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define statusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define IS_IPHONE_X ((statusBarHeight == 44) ? YES : NO)

#define KWidthScale ((SCREEN_WIDTH) / 375.0)
#define KHeightScale ((SCREEN_HEIGHT) / 667.0)

#define UIColorFromHexA(hexValue, a)     [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:a]
#define UIColorFromHex(hexValue)        UIColorFromHexA(hexValue, 1.0f)

#define bottomCopyRightText         @"© 1997-2020 网易公司"
#define imageViewWidth              (300 * KWidthScale)
// 传入imageView的宽高比应为3:4
#define imageViewHeight             (imageViewWidth * 4 / 3)
#define cameraViewRadius            (130 * KWidthScale)

#endif /* LDDemoDefines_h */
