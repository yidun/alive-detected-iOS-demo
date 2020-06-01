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

@interface NTESLDMainViewController () <NTESLiveDetectViewDelegate, NTESTimeoutToastViewDelegate>

@property (nonatomic, strong) NTESLiveDetectView *mainView;

@property (nonatomic, strong) NTESLiveDetectManager *detector;

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation NTESLDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self __initDetectorView];
    [self __initDetector];
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
    [self startLiveDetect];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetectStatusChange:) name:@"NTESLDNotificationStatusChange" object:nil];
    // 监控app进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)startLiveDetect {
    [self.mainView.activityIndicator startAnimating];
    [self.detector setTimeoutInterval:20];
    
    NSString *version = [self.detector getSDKVersion];
    
    __weak __typeof(self)weakSelf = self;
    [self.detector startLiveDetectWithBusinessID:BUSINESSID actionsHandler:^(NSDictionary * _Nonnull params) {
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
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self showToastWithQuickPassMsg:@"停止检测"];
//    });
}

- (void)liveDetectStatusChange:(NSNotification *)infoNotification {
    NSDictionary *infoDict = [infoNotification.userInfo objectForKey:@"info"];
    [self.mainView changeTipStatus:infoDict];
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
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NTESTimeoutToastViewDelegate
- (void)retryButtonDidTipped:(UIButton *)sender {
    [self stopLiveDetect];
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    self.mainView = nil;
    self.detector = nil;
    [self.detector stopLiveDetect];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self __initDetectorView];
    [self __initDetector];
}

- (void)backHomePageButtonDidTipped:(UIButton *)sender {
    [self backBarButtonPressed];
}

@end

