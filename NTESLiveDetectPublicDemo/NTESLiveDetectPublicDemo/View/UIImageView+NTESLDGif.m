//
//  UIImageView+NTESLDGif.m
//  NTESVerifyCode
//
//  Created by Ke Xu on 2019/1/9.
//  Copyright © 2019 NetEase. All rights reserved.
//

#import "UIImageView+NTESLDGif.h"
#import <ImageIO/ImageIO.h>
#import "LDDemoDefines.h"

@implementation UIImageView (NTESLDGif)

//解析gif文件数据的方法 block中会将解析的数据传递出来
-(void)getGifImageWithUrk:(NSURL *)url
               returnData:(void(^)(NSArray<UIImage *> * imageArray,
                                   NSArray<NSNumber *>*timeArray,
                                   CGFloat totalTime,
                                   NSArray<NSNumber *>* widths,
                                   NSArray<NSNumber *>* heights))dataBlock{
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    //获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    //存放所有图片
    NSMutableArray * imageArray = [NSMutableArray array];
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [NSMutableArray array];
    //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
    NSMutableArray * widthArray = [NSMutableArray array];
    //存放每张图片的高度
    NSMutableArray * heightArray = [NSMutableArray array];
    //遍历
    for (size_t i=0; i<count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge_transfer UIImage *)(imageRef)];
        //获取图片信息
        NSDictionary * info = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CGFloat width = [[info objectForKey:(__bridge_transfer NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge_transfer NSString *)kCGImagePropertyPixelHeight] floatValue];
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        NSDictionary * timeDic = [info objectForKey:(__bridge_transfer NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge_transfer NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    CFRelease(source);
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}

-(void)yh_setImage:(NSURL *)imageUrl{
    WeakSelf(self);
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        StrongSelf(weakSelf);
        //添加帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray * times = [[NSMutableArray alloc]init];
        float currentTime = 0;
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            currentTime+=[timeArray[i] floatValue];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount= MAXFLOAT;
        //设置播放总时长
        animation.duration = totalTime;
        //Layer层添加
        [strongSelf.layer addAnimation:animation forKey:@"NTESLDGifAnimation"];
    }];
}

@end
