//
//  ChooseFilterView.m
//  UIImageProcessing
//
//  Created by 高磊 on 2017/5/9.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "ChooseFilterView.h"

static CGFloat const kBtnW = 80;
static CGFloat const kBtnH = 40;
static NSInteger const kBtnTag = 1000;

@interface ChooseFilterView ()

@property(nonatomic,strong) UIScrollView *backScrollView;

@end

@implementation ChooseFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backScrollView];
    }
    return self;
}


#pragma mark == setter
- (void)setCategorys:(NSMutableArray<NSDictionary *> *)categorys
{
    if (categorys.count == 0) {
        return;
    }
    
    _categorys = categorys;
    
    [self addFilter];
}


#pragma mark == private method
- (void)addFilter
{
    for (NSInteger i = 0;i < _categorys.count;i++) {
     
        NSDictionary *dic = _categorys[i];
        NSString *key = dic.allKeys[0];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:dic[key] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showFilter:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake((i+1) + i * kBtnW, (self.frame.size.height - kBtnH)/2.0, kBtnW, kBtnH)];
        btn.tag = kBtnTag + i;
        [self.backScrollView addSubview:btn];
        if (_categorys.count -1 == i) {
            [self.backScrollView setContentSize:CGSizeMake(CGRectGetMaxX(btn.frame) + 20, 0)];
        }
    }
}

#pragma mark == event response
- (void)showFilter:(UIButton *)sender
{
    NSInteger index = sender.tag - kBtnTag;
    NSDictionary *dic = _categorys[index];
    NSString *key = dic.allKeys[0];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFilterMenberWithCategoryName:point:)])
    {
        [self.delegate showFilterMenberWithCategoryName:key point:sender.frame.origin];
    }
}

#pragma mark == 懒加载
- (UIScrollView *)backScrollView
{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.showsVerticalScrollIndicator =
        _backScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _backScrollView;
}


@end
