//
//  OpenCameraOrPhoto.h
//  BaishitongClient
//
//  Created by 高磊 on 15/10/28.
//  Copyright © 2015年 高磊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OpenCameraOrPhotoBlock)(UIImage *image,NSString *imageName);

@interface OpenCameraOrPhoto : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(OpenCameraOrPhoto);

+ (void)openCameraWithView:(UIView *)view withBlock:(OpenCameraOrPhotoBlock)openCameraOrPhotoBlock;

+ (void)openPhotoWithView:(UIView *)view withBlock:(OpenCameraOrPhotoBlock)openCameraOrPhotoBlock;

@property (nonatomic,copy) OpenCameraOrPhotoBlock openPhotoBlock;

@property (nonatomic,copy) OpenCameraOrPhotoBlock openCameraBlock;

//字符串表示图片的时间  格式为2016:01:03
@property (nonatomic,strong) NSString *imageDate;

@end
