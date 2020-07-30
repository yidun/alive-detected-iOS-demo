//
//  NetworkReachability.m
//  NTESLiveDetectPublicDemo
//
//  Created by 罗礼豪 on 2020/5/16.
//  Copyright © 2020 Ke Xu. All rights reserved.
//

#import "NetworkReachability.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetworkReachability

+ (void)AFNReachability:(NetworkReachabilityStatusHandler)reachabilityStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    // 2.监听网络状态的改变
      /*
       AFNetworkReachabilityStatusUnknown     = 未知
       AFNetworkReachabilityStatusNotReachable   = 没有网络
       AFNetworkReachabilityStatusReachableViaWWAN = 3G
       AFNetworkReachabilityStatusReachableViaWiFi = WIFI
       */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        reachabilityStatus(status);
    }];
         
          /// 3.开始监听
    [manager startMonitoring];
}

@end
