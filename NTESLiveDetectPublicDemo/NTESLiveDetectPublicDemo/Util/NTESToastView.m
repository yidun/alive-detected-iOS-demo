//
//  NTESToastView.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/30.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESToastView.h"
#import "LDDemoDefines.h"
#import <Masonry/Masonry.h>
#import "UIColor+NTESLiveDetect.h"

@implementation NTESToastView

+ (void)showNotice:(NSString *)notice {
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.backgroundColor = [UIColor ntes_colorWithHexString:@"#000000"];
    noticeLabel.font = [UIFont systemFontOfSize:13 *KWidthScale];
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.numberOfLines = 1;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.layer.cornerRadius = 22;
    noticeLabel.layer.masksToBounds = YES;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:noticeLabel];
    noticeLabel.text = notice;
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(window);
        make.centerY.equalTo(window).mas_offset(100);
        make.size.mas_equalTo(CGSizeMake(191 * KWidthScale, 44 * KWidthScale));
    }];
       
    noticeLabel.alpha = 0;
    [UIView animateWithDuration:.5f animations:^{
        noticeLabel.alpha = 1;
    } completion:^(BOOL finished) {
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:.5f animations:^{
                noticeLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [noticeLabel removeFromSuperview];
            }];
        });
    }];
}

@end
