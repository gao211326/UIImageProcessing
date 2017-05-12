//
//  FilterImageView.h
//  UIImageProcessing
//
//  Created by 高磊 on 2017/5/10.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface FilterImageView : GLKView

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) CIFilter *filter;

@end
