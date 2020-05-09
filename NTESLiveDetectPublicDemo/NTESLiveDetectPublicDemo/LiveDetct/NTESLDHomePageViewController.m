//
//  NTESLDHomePageViewController.m
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/10.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#import "NTESLDHomePageViewController.h"
#import "LDDemoDefines.h"
#import <Masonry.h>
#import "NTESLDSuccessViewController.h"
#import "NTESLDMainViewController.h"
#import "UIColor+NTESLiveDetect.h"

@implementation NTESLDHomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self customInitSubViews];
}

- (void)customInitSubViews {
    [self __initBackgroundView];
    [self __initBottomView];
}

- (void)startLiveDetect {
    NTESLDMainViewController *vc = [[NTESLDMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)__initBackgroundView {
    UIImageView *personImageView = [[UIImageView alloc] init];
    personImageView.image = [UIImage imageNamed:@"pic_demo"];
    [self.view addSubview:personImageView];
    [personImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(IS_IPHONE_X ? 73 : 36);
        make.right.equalTo(self.view).mas_offset(-(32*KWidthScale));
        make.width.equalTo(@(160*KWidthScale));
        make.height.equalTo(@(160*KWidthScale));
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"ico_logo_bar"];
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personImageView.mas_bottom).mas_offset(12*KHeightScale);
        make.left.equalTo(self.view).mas_offset(28*KWidthScale);
        make.width.equalTo(@(30*KWidthScale));
        make.height.equalTo(@(30*KWidthScale));
    }];
    
    UILabel *firstLineTitleLable = [[UILabel alloc] init];
    firstLineTitleLable.text = @"欢迎体验，";
    firstLineTitleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:28*KWidthScale];
    firstLineTitleLable.textColor = UIColorFromHex(0x464646);
    [self.view addSubview:firstLineTitleLable];
    [firstLineTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(32*KWidthScale);
    }];
    
    UILabel *secondLineTitleLable = [[UILabel alloc] init];
    secondLineTitleLable.text = @"易盾活体检测Demo";
    secondLineTitleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24*KWidthScale];
    secondLineTitleLable.textColor = UIColorFromHex(0x464646);
    [self.view addSubview:secondLineTitleLable];
    [secondLineTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLineTitleLable.mas_bottom).offset(4);
        make.left.equalTo(firstLineTitleLable);
    }];
    
    UIImageView *firstGreenIconView = [[UIImageView alloc] init];
    firstGreenIconView.image = [UIImage imageNamed:@"ico_green"];
    [self.view addSubview:firstGreenIconView];
    [firstGreenIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineTitleLable.mas_bottom).mas_offset(40);
        make.left.equalTo(self.view).mas_offset(29*KWidthScale);
        make.width.equalTo(@(20*KWidthScale));
        make.height.equalTo(@(20*KWidthScale));
    }];
    
    UILabel *firstGreenTitleLable = [[UILabel alloc] init];
    firstGreenTitleLable.text = @"明亮的光线环境下使用";
    firstGreenTitleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*KWidthScale];
    firstGreenTitleLable.textColor = UIColorFromHex(0x8A8A99);
    [self.view addSubview:firstGreenTitleLable];
    [firstGreenTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstGreenIconView);
        make.left.equalTo(firstGreenIconView.mas_right).mas_offset(9*KWidthScale);
    }];
    
    UIImageView *secondGreenIconView = [[UIImageView alloc] init];
    secondGreenIconView.image = [UIImage imageNamed:@"ico_green"];
    [self.view addSubview:secondGreenIconView];
    [secondGreenIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstGreenIconView.mas_bottom).mas_offset(18);
        make.left.equalTo(firstGreenIconView);
        make.width.equalTo(firstGreenIconView);
        make.height.equalTo(firstGreenIconView);
    }];
    
    UILabel *secondGreenTitleLable = [[UILabel alloc] init];
    secondGreenTitleLable.text = @"不要遮挡面部";
    secondGreenTitleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*KWidthScale];
    secondGreenTitleLable.textColor = UIColorFromHex(0x8A8A99);
    [self.view addSubview:secondGreenTitleLable];
    [secondGreenTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secondGreenIconView);
        make.left.equalTo(firstGreenTitleLable);
    }];
    
    UIImageView *thirdGreenIconView = [[UIImageView alloc] init];
    thirdGreenIconView.image = [UIImage imageNamed:@"ico_green"];
    [self.view addSubview:thirdGreenIconView];
    [thirdGreenIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondGreenIconView.mas_bottom).mas_offset(18);
        make.left.equalTo(firstGreenIconView);
        make.width.equalTo(firstGreenIconView);
        make.height.equalTo(firstGreenIconView);
    }];
    
    UILabel *thirdGreenTitleLable = [[UILabel alloc] init];
    thirdGreenTitleLable.text = @"正握手机，人脸正对屏幕";
    thirdGreenTitleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*KWidthScale];
    thirdGreenTitleLable.textColor = UIColorFromHex(0x8A8A99);
    [self.view addSubview:thirdGreenTitleLable];
    [thirdGreenTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(thirdGreenIconView);
        make.left.equalTo(firstGreenTitleLable);
    }];
    
    UIButton *startDetectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startDetectButton setTitle:@"开始活体检测" forState:UIControlStateNormal];
    [startDetectButton setTitle:@"开始活体检测" forState:UIControlStateHighlighted];
    [startDetectButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
    [startDetectButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateHighlighted];
    startDetectButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*KWidthScale];
    startDetectButton.layer.cornerRadius = 44.0*KHeightScale/2;
    startDetectButton.layer.masksToBounds = YES;
    [startDetectButton addTarget:self action:@selector(startLiveDetect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startDetectButton];
    [startDetectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdGreenIconView.mas_bottom).offset(76*KHeightScale);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(44*KHeightScale));
        make.width.equalTo(@(311*KWidthScale));
    }];
   
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 311*KWidthScale, 44*KHeightScale);
    gradientLayer.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    [startDetectButton.layer insertSublayer:gradientLayer atIndex:0];
    
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    gradientLayer1.colors = @[(id)[UIColor ntes_colorWithHexString:@"#FFFFFF"].CGColor, (id)[UIColor ntes_colorWithHexString:@"#EEEFF6"].CGColor];
    gradientLayer1.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer1.endPoint = CGPointMake(1.0, 0.5);
    [self.view.layer insertSublayer:gradientLayer1 atIndex:0];
}

- (void)__initBottomView {
    UILabel *bottomCopyRightLabel = [[UILabel alloc] init];
    bottomCopyRightLabel.text = bottomCopyRightText;
    bottomCopyRightLabel.font = [UIFont systemFontOfSize:12.0*KHeightScale];
    bottomCopyRightLabel.textColor = UIColorFromHex(0x999999);
    [self.view addSubview:bottomCopyRightLabel];
    [bottomCopyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(IS_IPHONE_X ? -40 : -20);
    }];
}

@end


