//
//  NTESBaseViewController.h
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTESBaseViewController : UIViewController

- (void)shouldHideLogoView:(BOOL)hide;

- (void)shouldHiddenTitle:(BOOL)hide title:(NSString *)title
    showHiddenVoiceButton:(BOOL)voiceButton;

@end

