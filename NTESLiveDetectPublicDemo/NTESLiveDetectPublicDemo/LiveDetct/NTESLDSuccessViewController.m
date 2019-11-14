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

@interface NTESLDSuccessViewController ()

@property (nonatomic, strong) UIImageView *successImageView;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UIButton *backToRootButton;

@end

@implementation NTESLDSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitSubViews];
}

- (void)customInitSubViews
{
    [self __initSuccessImageView];
    [self __initThemeLabel];
    [self __initBackToRootButton];
    [self startTime];
}

- (void)__initSuccessImageView
{
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] init];
        [_successImageView setImage:[UIImage imageNamed:@"Group"]];
        [self.view addSubview:_successImageView];
        [_successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(128*KHeightScale);
            make.height.equalTo(@(103.5*KWidthScale));
            make.width.equalTo(@(191*KWidthScale));
        }];
    }
}

- (void)__initThemeLabel
{
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:21*KWidthScale];
        _themeLabel.text = @"活体检测通过";
        [self.view addSubview:_themeLabel];
        [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.successImageView.mas_bottom).offset(6*KHeightScale);
            make.centerX.equalTo(self.view);
        }];
    }
}

- (void)__initBackToRootButton
{
    if (!_backToRootButton) {
        _backToRootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backToRootButton.titleLabel.textColor = [UIColor whiteColor];
        _backToRootButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _backToRootButton.layer.cornerRadius = 44.0*KHeightScale/2;
        _backToRootButton.layer.masksToBounds = YES;
        [_backToRootButton addTarget:self action:@selector(doBackToRoot) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backToRootButton];
        [_backToRootButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.themeLabel.mas_bottom).offset(36*KHeightScale);
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

- (void)startTime
{
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

- (void)doBackToRoot
{
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[NTESLDHomePageViewController class]]) {
            NTESLDHomePageViewController *mainVC = (NTESLDHomePageViewController *)vc;
            [self.navigationController popToViewController:mainVC animated:YES];
        }
    }
}

@end
