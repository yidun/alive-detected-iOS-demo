//
//  NTESLDMainViewController.m
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/11.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#import "NTESLDMainViewController.h"
#import <NTESLiveDetect/NTESLiveDetect.h>
#import "NTESLiveDetectView.h"
#import "LDDemoDefines.h"
#import "NTESLDSuccessViewController.h"
#import <WHToast.h>
#import "NTESTimeoutToastView.h"
#import "NetworkReachability.h"
#import "SceneDelegate.h"
#import "AppDelegate.h"

static NSOperationQueue *_queue;

@interface NTESLDMainViewController () <NTESLiveDetectViewDelegate, NTESTimeoutToastViewDelegate>

@property (nonatomic, strong) NTESLiveDetectView *mainView;

@property (nonatomic, strong) NTESLiveDetectManager *detector;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) NSDictionary *dictionary;

/**
 屏幕亮度值
 */
@property (nonatomic, assign) CGFloat value;

@end

@implementation NTESLDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];

    WeakSelf(self);
    [NetworkReachability AFNReachability:^(AFNetworkReachabilityStatus status) {
        [weakSelf replyLoading];
    }];
    
    if (@available(iOS 13.0, *)) {
        NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *windowScene = (UIWindowScene *)array[0];
        SceneDelegate *delegate =(SceneDelegate *)windowScene.delegate;

        delegate.enterBackground = ^{
            [weakSelf backBarButtonPressed];
        };
    } else {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setEnterBackgroundHandler:^{
            [weakSelf backBarButtonPressed];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIScreen mainScreen] setBrightness:self.value];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.detector stopLiveDetect];
     if (self.mainView.timer) {
         [self.mainView.timer invalidate];
     }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self backBarButtonPressed];
}

- (void)__initDetectorView {
    self.mainView = [[NTESLiveDetectView alloc] initWithFrame:self.view.frame];
    self.mainView.LDViewDelegate = self;
    [self.view addSubview:self.mainView];
}

- (void)__initDetector {
    self.detector = [[NTESLiveDetectManager alloc] initWithImageView:self.mainView.cameraImage withDetectSensit:NTESSensitNormal];
    NSString *getSDKVersion = [self.detector getSDKVersion];
    [self startLiveDetect];
//
    CGFloat brightness = [UIScreen mainScreen].brightness;
    self.value = brightness;
//    [self compareCurrentBrightness:brightness];
    [UIScreen mainScreen].brightness = 0.8;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetectStatusChange:) name:@"NTESLDNotificationStatusChange" object:nil];
    // 监控app进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDefaultBrightness:) name:UIScreenBrightnessDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}
//
-(void)willResignActive {
    [UIScreen mainScreen].brightness = self.value;
}

- (void)didBecomeActive {
    [UIScreen mainScreen].brightness = 0.8;
}

- (void)saveDefaultBrightness:(NSNotification *)notification {
    CGFloat brightness = [UIScreen mainScreen].brightness;
    [self compareCurrentBrightness:brightness];

}

- (void)compareCurrentBrightness:(CGFloat)brightness {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",brightness]];
     NSDecimalNumberHandler *numHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
     NSString *str1 = [[num1 decimalNumberByRoundingAccordingToBehavior:numHandler] stringValue];
     if (![str1 isEqualToString:@"0.8"]) {
       self.value = [UIScreen mainScreen].brightness;
     } else {
         
     }
}

- (void)startLiveDetect {
    [self.mainView.activityIndicator startAnimating];
    [self.detector setTimeoutInterval:20];
    
    __weak __typeof(self)weakSelf = self;
    [self.detector startLiveDetectWithBusinessID:@"6a1a399443a54d31b91896a4208bf6e0" actionsHandler:^(NSDictionary * _Nonnull params) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.mainView.activityIndicator stopAnimating];
             NSString *actions = [params objectForKey:@"actions"];
             if (actions && actions.length != 0) {
                 [self.mainView showActionTips:actions];
                 NSLog(@"动作序列：%@", actions);
             } else {
                 [weakSelf showToastWithQuickPassMsg:@"返回动作序列为空"];
             }
         });
    } completionHandler:^(NTESLDStatus status, NSDictionary * _Nullable params) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.params = params;
            [weakSelf showToastWithLiveDetectStatus:status];
        });
    }];
}

-  (void)applicationEnterBackground {
    [self stopLiveDetect];
}

- (void)stopLiveDetect {
    [self.detector stopLiveDetect];
}

- (void)liveDetectStatusChange:(NSNotification *)infoNotification {
//    NSDictionary *infoDict = [infoNotification.userInfo objectForKey:@"info"];
    [self.mainView changeTipStatus:infoNotification.userInfo];
}

- (void)showToastWithLiveDetectStatus:(NTESLDStatus)status {
    NSString *msg = @"";
    NTESLDSuccessViewController *vc = [[NTESLDSuccessViewController alloc] init];
    NSString *token;
    if ([self.params isKindOfClass:[NSDictionary class]]) {
        token = [self.params objectForKey:@"token"];
    }
    vc.token = token;
    switch (status) {
        case NTESLDCheckPass:
        {
            vc.message = @"活体检测通过";
            vc.loginType = NTESQuickLoginTypeSeccess;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case NTESLDCheckNotPass:
            vc.message = @"活体检测不通过";
            vc.loginType = NTESQuickLoginTypeFailure;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case NTESLDOperationTimeout:
        {
            msg = @"动作检测超时\n请在规定时间内完成动作";
            NTESTimeoutToastView *toastView = [[NTESTimeoutToastView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            toastView.delegate = self;
            [toastView show];
        }
            break;
        case NTESLDGetConfTimeout:
            msg = @"活体检测获取配置信息超时";
            break;
        case NTESLDOnlineCheckTimeout:
            vc.message = @"云端检测结果请求超时";
            vc.loginType = NTESQuickLoginTypeFailure;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case NTESLDOnlineUploadFailure:
            vc.message = @"云端检测上传图片失败";
            vc.loginType = NTESQuickLoginTypeFailure;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case NTESLDNonGateway:
            msg = @"网络未连接";
            break;
        case NTESLDSDKError:
            vc.message = @"SDK内部错误";
            vc.loginType = NTESQuickLoginTypeFailure;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case NTESLDCameraNotAvailable:
            msg = @"App未获取相机权限";
            break;
        default:
            vc.message = @"未知错误";
            vc.loginType = NTESQuickLoginTypeFailure;
            [self.navigationController pushViewController:vc animated:YES];
            break;
    }
    if (status == NTESLDGetConfTimeout || status == NTESLDNonGateway ||status == NTESLDCameraNotAvailable) {
        [self showToastWithQuickPassMsg:msg];
    }
}

- (void)showToastWithQuickPassMsg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [WHToast setMaskColor:UIColorFromHexA(0x000000, 0.75)];
        [WHToast setCornerRadius:12*KWidthScale];
        [WHToast setFontSize:13*KWidthScale];
        [WHToast setPadding:14*KWidthScale];
        CGFloat marginY = IS_IPHONE_X ? (SCREEN_HEIGHT - 237*KHeightScale - 34 - 64) : (SCREEN_HEIGHT - 237*KHeightScale - 64);
        [WHToast showMessage:msg originY:marginY duration:3.0 finishHandler:nil];
    });
}

- (void)dealloc {
    NSLog(@"-----dealloc");
}

#pragma mark - view delegate
- (void)backBarButtonPressed {
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[UIScreen mainScreen] setBrightness:weakSelf.value];
        if ([weakSelf.navigationController.topViewController isKindOfClass:[self class]]) {
           [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    });
}

#pragma mark - NTESTimeoutToastViewDelegate
- (void)retryButtonDidTipped:(UIButton *)sender {
    [self replyLoading];
}

- (void)replyLoading {
    [self stopLiveDetect];
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    self.mainView = nil;
    self.detector = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self __initDetectorView];
    [self __initDetector];
}

- (void)backHomePageButtonDidTipped:(UIButton *)sender {
    [self backBarButtonPressed];
}

@end

