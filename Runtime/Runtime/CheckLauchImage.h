//
//  CheckLauchImage.h
//  Runtime
//
//  Created by 杜帅 on 16/10/13.
//  Copyright © 2016年 杜帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CacheImageStatus) {
    CacheImageStatus_Delete = 0,
    CacheImageStatus_Finsh,
    
};
@interface CheckLauchImage : NSObject
/** 
 下载图片是GET方式
 根据你所需要下载的图片的名字进行判断 是否需要下载新的图片 比如说ads.JPEG 如果下载的图片还是叫这个名字的话就不会下载新的图片的 如果名字和之前的相等 则需要在第二个方法中将 updateImage = true
 */

/*
 第一个参数 : 定时动画时间
 第二个参数 : 是否展示图片 一般写true就好
 第二个参数 : 展示 跳过按钮
 */
+ (void)checkLanuchImage:(NSTimeInterval)timerI isShowAd:(BOOL)isShowAd ignore:(BOOL)ignore;
/**
 * func: 在你需要的位置调用下载 如果不调用该方法就默认一直展示启动页动画
 第一个参数 : 网址
 第一个参数 : 更新新的图片 默认false
 */
+ (void)downLauchImageUrl:(NSString *)url update:(BOOL)updateImage;



/** 按钮颜色 */
@property (nonatomic, strong) UIColor *buttonBackColor;

/** 按钮大小 */
@property (nonatomic, assign) CGFloat buttonFont;

/** 按钮字体颜色 */
@property (nonatomic, strong) UIColor *buttonTitleColor;
@end
