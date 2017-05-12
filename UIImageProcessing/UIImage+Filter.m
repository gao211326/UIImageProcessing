//
//  UIImage+Filter.m
//  UIImageProcessing
//
//  Created by 高磊 on 2017/4/28.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "UIImage+Filter.h"

@implementation UIImage (Filter)

+ (UIImage *)filterImage:(UIImage *)image filterName:(NSString *)name
{
    if ([name isEqualToString:@"OriginImage"]) {
        return image;
    }

    
    //将UIImage转换为CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    //创建滤镜对象
    CIFilter *ciFilter = [CIFilter filterWithName:name keysAndValues:kCIInputImageKey,ciImage, nil];
    
    //返回滤镜的属性描述信息
    NSDictionary *dic = [ciFilter attributes];
    
    NSLog(@" 打印信息:%@",dic);
    
//    NSArray *array = [ciFilter outputKeys];
    
    
    if ([name isEqualToString:@"CIColorClamp"]) {
        
        CGFloat min[] = {0,0,0,0};
        CGFloat max[] = {0,0,1,1};
        [ciFilter setValue:[CIVector vectorWithValues:min count:4] forKey:@"inputMinComponents"];
        [ciFilter setValue:[CIVector vectorWithValues:max count:4] forKey:@"inputMaxComponents"];
    }
    else if ([name isEqualToString:@"CIColorCrossPolynomial"]){
        CGFloat r[] = {0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
        CGFloat g[] = {0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
        CGFloat b[] = {1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
        [ciFilter setValue:[CIVector vectorWithValues:r count:10] forKey:@"inputRedCoefficients"];
        [ciFilter setValue:[CIVector vectorWithValues:g count:10] forKey:@"inputGreenCoefficients"];
        [ciFilter setValue:[CIVector vectorWithValues:b count:10] forKey:@"inputBlueCoefficients"];
    }
    else if ([name isEqualToString:@"CIColorPolynomial"]){
        CGFloat r[] = {1,0.3,0,0.4};
        CGFloat g[] = {0,0,0.5,0.8};
        CGFloat b[] = {0,0,0.5,1};
        CGFloat a[] = {0,1,1,1};
        [ciFilter setValue:[CIVector vectorWithValues:r count:4] forKey:@"inputRedCoefficients"];
        [ciFilter setValue:[CIVector vectorWithValues:g count:4] forKey:@"inputGreenCoefficients"];
        [ciFilter setValue:[CIVector vectorWithValues:b count:4] forKey:@"inputBlueCoefficients"];
        [ciFilter setValue:[CIVector vectorWithValues:a count:4] forKey:@"inputAlphaCoefficients"];
    }
    else if ([name isEqualToString:@"CIHueAdjust"]){
        [ciFilter setValue:[NSNumber numberWithFloat:0.5] forKey:kCIInputAngleKey];
    }
//    [ciFilter setValue:@"1.0" forKey:kCIInputIntensityKey];
//    [ciFilter setValue:@"80.0" forKey:kCIInputRadiusKey];
    
//    [ciFilter setDefaults];
    

    //
    CIImage *outPutImage = [ciFilter outputImage];
    //获取上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:outPutImage fromRect:outPutImage.extent];
    
    UIImage *filter_image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    
//    UIImage *filter_image = [UIImage imageWithCIImage:outPutImage];
    
    return filter_image;
}

@end
