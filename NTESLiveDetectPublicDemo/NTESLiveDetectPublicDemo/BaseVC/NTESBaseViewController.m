//
//  NTESBaseViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "NTESBaseViewController.h"
#import <Masonry.h>
#import "LDDemoDefines.h"
#import "UIColor+NTESLiveDetect.h"
#import "NTESLDHomePageViewController.h"

@interface NTESBaseViewController ()

@property (nonatomic, strong) UIButton *backBarButton;

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UILabel  *navTitleLabel;

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, assign) BOOL shouldPlay;

@end

@implementation NTESBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self __initBackBarButton];
    [self __initLogo];
    [self __initTitle];
    [self __initVoiceButton];
}

- (void)shouldHideLogoView:(BOOL)hide {
    self.logoImageView.alpha = hide ? 0.0 : 1.0;
}

- (void)shouldHiddenTitle:(BOOL)hide
                    title:(NSString *)title
    showHiddenVoiceButton:(BOOL)voiceButton {
    self.navTitleLabel.hidden = hide;
    self.voiceButton.hidden = voiceButton;
    self.navTitleLabel.text = title;
}

- (void)__initBackBarButton {
    if (!_backBarButton) {
        _backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBarButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
        [_backBarButton setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
        [_backBarButton setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateHighlighted];
        [self.view addSubview:_backBarButton];
        [_backBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20*KWidthScale);
            make.top.equalTo(self.view).offset(IS_IPHONE_X ? statusBarHeight : 10+statusBarHeight);
            make.width.equalTo(@(24*KWidthScale));
            make.height.equalTo(@(24*KWidthScale));
        }];
    }
}

- (void)__initLogo {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        [_logoImageView setImage:[UIImage imageNamed:@"ico_logo_bar"]];
        [self.view addSubview:_logoImageView];
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBarButton);
            make.left.equalTo(self.backBarButton.mas_right);
            make.width.equalTo(@(30*KHeightScale));
            make.height.equalTo(@(30*KHeightScale));
        }];
    }
}

- (void)__initTitle {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] init];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:KWidthScale * 16];
        _navTitleLabel.textColor = [UIColor ntes_colorWithHexString:@"#222222"];
        [self.view addSubview:_navTitleLabel];
        [_navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBarButton);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(200));
        }];
    }
}

- (void)__initVoiceButton {
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.hidden = YES;
    if (self.shouldPlay) {
        [self.voiceButton setImage:[UIImage imageNamed:@"ico_voice_open"] forState:UIControlStateNormal];
    } else {
        [self.voiceButton  setImage:[UIImage imageNamed:@"ico_voice_close"] forState:UIControlStateNormal];
    }
    [self.voiceButton addTarget:self action:@selector(openVoiceButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.voiceButton];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-(20*KWidthScale));
        make.centerY.equalTo(self.backBarButton);
        make.width.equalTo(@(24*KWidthScale));
        make.height.equalTo(@(24*KWidthScale));
    }];
}

- (void)openVoiceButton {
    
}

- (void)doBack {
   for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[NTESLDHomePageViewController class]]) {
            NTESLDHomePageViewController *mainVC = (NTESLDHomePageViewController *)vc;
            [self.navigationController popToViewController:mainVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


