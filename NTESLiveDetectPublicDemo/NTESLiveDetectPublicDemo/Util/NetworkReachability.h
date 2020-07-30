//
//  NetworkReachability.h
//  NTESLiveDetectPublicDemo
//
//  Created by 罗礼豪 on 2020/5/16.
//  Copyright © 2020 Ke Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^NetworkReachabilityStatusHandler)(AFNetworkReachabilityStatus status);

NS_ASSUME_NONNULL_BEGIN

@interface NetworkReachability : NSObject

+ (void)AFNReachability:(NetworkReachabilityStatusHandler)reachabilityStatus;

@end

NS_ASSUME_NONNULL_END
