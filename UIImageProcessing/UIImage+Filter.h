//
//  UIImage+Filter.h
//  UIImageProcessing
//
//  Created by 高磊 on 2017/4/28.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filter)


/**
 图片滤镜

 @param image 原图
 @param name 滤镜效果
 @return 返回滤镜后的图片
 */
+ (UIImage *)filterImage:(UIImage *)image filterName:(NSString *)name;

@end
