//
//  ChooseFilterView.h
//  UIImageProcessing
//
//  Created by 高磊 on 2017/5/9.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterMenberViewDelegate <NSObject>


/**
 滤镜

 */
- (void)imageFilterName:(NSString *)name;

@end

@interface FilterMenberView : UIView

@property (nonatomic,strong) NSMutableArray <NSDictionary *> *menbers;

@property (nonatomic,weak) id <FilterMenberViewDelegate>delegate;

@end
