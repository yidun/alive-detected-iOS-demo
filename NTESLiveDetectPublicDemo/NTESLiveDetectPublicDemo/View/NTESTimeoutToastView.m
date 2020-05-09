//
//  NTESTimeoutToastView.m
//  NTESLiveDetectPublicDemo
//
//  Created by 罗礼豪 on 2020/4/21.
//  Copyright © 2020 Ke Xu. All rights reserved.
//

#import "NTESTimeoutToastView.h"
#import "UIColor+NTESLiveDetect.h"
#import <Masonry/Masonry.h>
#import "LDDemoDefines.h"

@interface NTESTimeoutToastView()<UIGestureRecognizerDelegate>;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation NTESTimeoutToastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTipped)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    _bottomView.layer.cornerRadius = 7;
    _bottomView.layer.masksToBounds = YES;
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(270 * KWidthScale, 135 *KWidthScale));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"检测超时";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18 * KWidthScale];
    titleLabel.textColor = [UIColor ntes_colorWithHexString:@"#222222"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).mas_offset(21 *KWidthScale);
        make.centerX.equalTo(self.bottomView);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"请在规定时间内完成动作";
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14 * KWidthScale];
    contentLabel.textColor = [UIColor ntes_colorWithHexString:@"#888888"];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).mas_offset(8 *KWidthScale);
        make.centerX.equalTo(self.bottomView);
    }];
    
    UIView *landLine = [[UIView alloc] init];
    landLine.backgroundColor = [UIColor ntes_colorWithHexString:@"#DDDDDD"];
    [_bottomView addSubview:landLine];
    [landLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView).mas_offset(-50 * KWidthScale);
        make.left.right.equalTo(self.bottomView);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *protraitLine = [[UIView alloc] init];
    protraitLine.backgroundColor = [UIColor ntes_colorWithHexString:@"#DDDDDD"];
    [_bottomView addSubview:protraitLine];
    [protraitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView);
        make.top.equalTo(landLine.mas_bottom);
        make.centerX.equalTo(self.bottomView);
        make.width.mas_equalTo(0.5);
    }];
    
    UIButton *backHomePageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backHomePageButton addTarget:self action:@selector(backHomePageButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [backHomePageButton setTitle:@"返回首页" forState:UIControlStateNormal];
    backHomePageButton.titleLabel.textColor = [UIColor ntes_colorWithHexString:@"#222222"];
    backHomePageButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16 * KWidthScale];
    [_bottomView addSubview:backHomePageButton];
    [backHomePageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomView);
        make.right.equalTo(protraitLine.mas_left);
        make.top.equalTo(landLine.mas_bottom);
    }];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [retryButton addTarget:self action:@selector(retryButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [retryButton setTitle:@"重试" forState:UIControlStateNormal];
    retryButton.titleLabel.textColor = [UIColor ntes_colorWithHexString:@"#222222"];
    retryButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16 * KWidthScale];
    [_bottomView addSubview:retryButton];
    [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.bottom.equalTo(self.bottomView);
         make.left.equalTo(protraitLine.mas_right);
         make.top.equalTo(landLine.mas_bottom);
     }];
}

- (void)viewDidTipped {
    [self hidden];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hidden {
    if (self) {
        [self removeFromSuperview];
    }
}

- (void)retryButtonDidTipped:(UIButton *)sender {
    [self hidden];
    if (_delegate && [_delegate respondsToSelector:@selector(retryButtonDidTipped:)]) {
        [_delegate retryButtonDidTipped:sender];
    }
}

- (void)backHomePageButtonDidTipped:(UIButton *)sender {
    [self hidden];
    if (_delegate && [_delegate respondsToSelector:@selector(backHomePageButtonDidTipped:)]) {
        [_delegate backHomePageButtonDidTipped:sender];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view isDescendantOfView:self.bottomView]) {
        return NO;
    }
    return YES;
}

@end
