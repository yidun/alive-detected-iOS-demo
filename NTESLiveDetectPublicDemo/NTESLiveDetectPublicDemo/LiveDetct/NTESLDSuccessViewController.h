//
//  NTESLDSuccessViewController.h
//  NTESLiveDetectPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESBaseViewController.h"

typedef NS_ENUM(NSUInteger, NTESLoginType) {
    NTESQuickLoginTypeSeccess = 1,
    NTESQuickLoginTypeFailure,
};

@interface NTESLDSuccessViewController : NTESBaseViewController

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NTESLoginType loginType;

@end


