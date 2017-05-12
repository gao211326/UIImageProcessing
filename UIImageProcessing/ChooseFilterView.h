//
//  ChooseFilterView.h
//  UIImageProcessing
//
//  Created by 高磊 on 2017/5/9.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseFilterViewDelegate <NSObject>


/**
 展示category滤镜的详细滤镜效果

 @param name category名字
 @param point 点击按钮的中心位置
 */
- (void)showFilterMenberWithCategoryName:(NSString *)name point:(CGPoint)point;

@end

@interface ChooseFilterView : UIView

@property (nonatomic,strong) NSMutableArray <NSDictionary *> *categorys;

@property (nonatomic,weak) id <ChooseFilterViewDelegate>delegate;

@end
