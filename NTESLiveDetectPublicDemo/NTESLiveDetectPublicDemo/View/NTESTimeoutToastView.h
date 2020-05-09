//
//  NTESTimeoutToastView.h
//  NTESLiveDetectPublicDemo
//
//  Created by 罗礼豪 on 2020/4/21.
//  Copyright © 2020 Ke Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESTimeoutToastViewDelegate <NSObject>

- (void)retryButtonDidTipped:(UIButton * _Nullable)sender;

- (void)backHomePageButtonDidTipped:(UIButton * _Nullable)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NTESTimeoutToastView : UIView

@property (nonatomic, weak) id<NTESTimeoutToastViewDelegate> delegate;

- (void)show;

- (void)hidden;

@end

NS_ASSUME_NONNULL_END
