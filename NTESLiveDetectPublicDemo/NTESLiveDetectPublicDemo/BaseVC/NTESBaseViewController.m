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

@interface NTESBaseViewController ()

@property (nonatomic, strong) UIButton *backBarButton;

@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation NTESBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self __initBackBarButton];
    [self __initLogo];
}

- (void)shouldHideLogoView:(BOOL)hide
{
    self.logoImageView.alpha = hide ? 0.0 : 1.0;
}

- (void)__initBackBarButton
{
    if (!_backBarButton) {
        _backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBarButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
        [_backBarButton setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
        [_backBarButton setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateHighlighted];
        [self.view addSubview:_backBarButton];
        [_backBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20*KWidthScale);
            make.top.equalTo(self.view).offset(IS_IPHONE_X ? 33+statusBarHeight : 27+statusBarHeight);
            make.width.equalTo(@(24*KWidthScale));
            make.height.equalTo(@(24*KWidthScale));
        }];
    }
}

- (void)__initLogo
{
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

- (void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
