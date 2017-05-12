//
//  FilterImageView.m
//  UIImageProcessing
//
//  Created by 高磊 on 2017/5/10.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "FilterImageView.h"
#import <OpenGLES/EAGL.h>

@interface FilterImageView()

@property (nonatomic,strong) CIContext *ciContext;

@end

@implementation FilterImageView

- (id)initWithFrame:(CGRect)frame
{
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self = [super initWithFrame:frame context:context];
    if (self) {
        
        _ciContext = [CIContext contextWithEAGLContext:context options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:kCIContextUseSoftwareRenderer]];
        //超出父视图 进行剪切
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

- (void)setFilter:(CIFilter *)filter
{
    _filter = filter;
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

//图片全部显示 不变形
- (CGRect)aspectFitWithFromRect:(CGRect)fromRect toRect:(CGRect)toRect
{
    CGFloat fromScale = fromRect.size.width * 1.0/ fromRect.size.height;
    CGFloat toScale = toRect.size.width * 1.0 / toRect.size.height;
    
    //画布原始frame
    CGRect fillFrame = toRect;
    
    //如果原图的宽高比大于当前画布的宽高比  则调整图片在画布上的frame
    if (fromScale > toScale) {
        //得到新的画布高 以宽为基础
        fillFrame.size.height = toRect.size.width * 1.0 / fromScale;
        fillFrame.origin.y += (toRect.size.height - fillFrame.size.height) * 0.5;
    }else{
        //以高为基础
        fillFrame.size.width = toRect.size.height * fromScale;
        fillFrame.origin.x += (toRect.size.width - fillFrame.size.width) * 0.5;
    }
    return fillFrame;
}

- (CGRect)aspectFillWithFromRect:(CGRect)fromRect toRect:(CGRect)toRect
{
    CGFloat fromScale = fromRect.size.width * 1.0/ fromRect.size.height;
    CGFloat toScale = toRect.size.width * 1.0 / toRect.size.height;
    
    //画布原始frame
    CGRect fillFrame = toRect;
    
    //如果原图的宽高比大于当前画布的宽高比  则调整图片在画布上的frame
    if (fromScale > toScale) {
        //得到新的画布高 以宽为基础
        fillFrame.size.width = toRect.size.height * 1.0 * fromScale;
        fillFrame.origin.x += (toRect.size.width - fillFrame.size.width) * 0.5;
    }else{
        //以高为基础
        fillFrame.size.height = toRect.size.width * 1.0 / fromScale;
        fillFrame.origin.y += (toRect.size.height - fillFrame.size.height) * 0.5;
    }
    return fillFrame;
}

- (CGRect)imageBoundsForContentModeWithFromRect:(CGRect)fromRect toRect:(CGRect)toRect
{
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFill:
        {
            return [self aspectFillWithFromRect:fromRect toRect:toRect];
        }
            break;
        case UIViewContentModeScaleAspectFit:
        {
            return [self aspectFitWithFromRect:fromRect toRect:toRect];
        }
            break;
        default:
            return fromRect;
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    if (_ciContext && _image) {
        //得到CIImage
        CIImage *inputCIImage = [[CIImage alloc] initWithImage:_image];
        
        CGRect inRect = [self imageBoundsForContentModeWithFromRect:inputCIImage.extent
                                                             toRect:CGRectMake(0, 0, self.drawableWidth, self.drawableHeight)];
        
        if (_filter) {
            [_filter setValue:inputCIImage forKey:kCIInputImageKey];
            //根据filter得到输出图像
            if (_filter.outputImage) {
                //渲染开始
                [_ciContext drawImage:_filter.outputImage
                               inRect:inRect
                             fromRect:inputCIImage.extent];
            }
        }else{
            [_ciContext drawImage:inputCIImage
                           inRect:inRect
                         fromRect:inputCIImage.extent];
        }
    }
}

@end
