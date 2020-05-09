//
//  NTESLDSuccessViewController.m
//  NTESLiveDetectPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "NTESLDSuccessViewController.h"
#import <Masonry.h>
#import "LDDemoDefines.h"
#import "NTESLDHomePageViewController.h"
#import "UIColor+NTESLiveDetect.h"
#import "NTESToastView.h"

@interface NTESLDSuccessViewController ()

@property (nonatomic, strong) UIImageView *successImageView;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UIButton *backToRootButton;

@property (nonatomic, strong) UIView *tokenBottomView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation NTESLDSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInitSubViews];
}

- (void)customInitSubViews {
    [self __initSuccessImageView];
    [self __initThemeLabel];
    [self __initBackToRootButton];
    [self __initTokenButtomView];
//    [self startTime];
    [self shouldHiddenTitle:NO title:@"活体检测结果" showHiddenVoiceButton:YES];
    [self shouldHideLogoView:YES];
}

- (void)__initSuccessImageView {
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] init];
        [self.view addSubview:_successImageView];
        if (_loginType == NTESQuickLoginTypeSeccess) {
            [_successImageView setImage:[UIImage imageNamed:@"Group"]];
            [_successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.top.equalTo(self.view).offset(128*KHeightScale);
                make.height.equalTo(@(103.5*KWidthScale));
                make.width.equalTo(@(191*KWidthScale));
            }];
        } else {
            [_successImageView setImage:[UIImage imageNamed:@"pic_fail"]];
            [_successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.top.equalTo(self.view).offset(128*KHeightScale);
                make.height.equalTo(@(130*KWidthScale));
                make.width.equalTo(@(130*KWidthScale));
            }];
        }
    }
}

- (void)__initThemeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:21*KWidthScale];
        _themeLabel.text = self.message;
        _themeLabel.textColor = [UIColor ntes_colorWithHexString:@"#000000"];
        [self.view addSubview:_themeLabel];
        [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.successImageView.mas_bottom).offset(6*KHeightScale);
            make.centerX.equalTo(self.view);
        }];
    }
}

- (void)__initBackToRootButton {
    if (!_backToRootButton) {
        _backToRootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backToRootButton.titleLabel.textColor = [UIColor whiteColor];
        _backToRootButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _backToRootButton.layer.cornerRadius = 44.0*KHeightScale/2;
        _backToRootButton.layer.masksToBounds = YES;
        [_backToRootButton setTitle:@"返回首页" forState:UIControlStateNormal];
        [_backToRootButton addTarget:self action:@selector(doBackToRoot) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backToRootButton];
        [_backToRootButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.themeLabel.mas_bottom).offset(36);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(44*KHeightScale));
            make.width.equalTo(@(311*KWidthScale));
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 311*KWidthScale, 44*KHeightScale);
        gradientLayer.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [_backToRootButton.layer insertSublayer:gradientLayer atIndex:0];
    }
}

- (void)__initTokenButtomView {
    if (!_tokenBottomView) {
        _tokenBottomView  = [[UIView alloc] init];
        _tokenBottomView.layer.cornerRadius = 44.0*KHeightScale/2;
        _tokenBottomView.layer.masksToBounds = YES;
        [self.view addSubview:_tokenBottomView];
        [_tokenBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backToRootButton.mas_bottom).offset(20);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(44*KHeightScale));
            make.width.equalTo(@(311*KWidthScale));
        }];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 311*KWidthScale, 44*KHeightScale);
    gradientLayer.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    [_tokenBottomView.layer insertSublayer:gradientLayer atIndex:0];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.cornerRadius = 44.0*KHeightScale/2;
    bottomView.layer.masksToBounds = YES;
    [_tokenBottomView addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tokenBottomView).mas_offset(1);
        make.top.equalTo(self.tokenBottomView).mas_offset(1);
        make.bottom.equalTo(self.tokenBottomView).mas_offset(-1);
        make.right.equalTo(self.tokenBottomView).mas_offset(-1);
    }];
    
    UILabel *tokenLabel = [[UILabel alloc] init];
    tokenLabel.text = [NSString stringWithFormat:@"Token：%@",self.token];
    tokenLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14 *KWidthScale];
    tokenLabel.textColor = [UIColor ntes_colorWithHexString:@"#000000"];
    [bottomView addSubview:tokenLabel];
    [tokenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);\
        make.left.equalTo(bottomView).mas_offset(24);
        make.right.equalTo(bottomView).mas_offset(-81);
    }];
    
    UILabel *copyLabel = [[UILabel alloc] init];
    copyLabel.text = @"复制";
    copyLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyLabelDidTipped)];
    [copyLabel addGestureRecognizer:tap];
    copyLabel.textColor = [UIColor ntes_colorWithHexString:@"#2C6EFF"];
    copyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14 * KWidthScale];
    [bottomView addSubview:copyLabel];
    [copyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView).mas_offset(-24);
        make.centerY.equalTo(bottomView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.layer.cornerRadius = 2;
    lineView.layer.masksToBounds = YES;
    lineView.backgroundColor = [UIColor ntes_colorWithHexString:@"#CCCCCC"];
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView).mas_offset(-72);
        make.centerY.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(1 * KWidthScale, 18 * KWidthScale));
    }];
}

- (void)copyLabelDidTipped {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.token;
    [NTESToastView showNotice:@"Token复制成功"];
}

- (void)startTime {
    __block int timeout = 2;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timeNew = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timeNew, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timeNew, ^{
        if (timeout >= 0) {
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.backToRootButton setTitle:[NSString stringWithFormat:@"返回首页（%@S）", strTime] forState:UIControlStateNormal];
                [self.backToRootButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
            });
            timeout--;
        } else {
            dispatch_source_cancel(timeNew);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self doBackToRoot];
            });
        }
    });
    dispatch_resume(timeNew);
}

- (void)doBackToRoot {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[NTESLDHomePageViewController class]]) {
            NTESLDHomePageViewController *mainVC = (NTESLDHomePageViewController *)vc;
            [self.navigationController popToViewController:mainVC animated:YES];
        }
    }
}

@end

