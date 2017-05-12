//
//  ChooseFilterView.m
//  UIImageProcessing
//
//  Created by 高磊 on 2017/5/9.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "FilterMenberView.h"

static CGFloat const kMenberBtnW = 80;
static CGFloat const kMenberBtnH = 40;
static NSInteger const kMenberBtnTag = 2000;

@interface FilterMenberView ()
{
    UIButton *  _lastSelectBtn;
}
@property(nonatomic,strong) UIScrollView *backScrollView;

@end

@implementation FilterMenberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backScrollView];
    }
    return self;
}


#pragma mark == setter
- (void)setMenbers:(NSMutableArray<NSDictionary *> *)menbers
{
    if (menbers.count == 0) {
        return;
    }
    
    _menbers = menbers;
    
    [self addFilter];
}


#pragma mark == private method
- (void)addFilter
{
    for (NSInteger i = 0;i < _menbers.count;i++) {
     
        NSDictionary *dic = _menbers[i];
        NSString *key = dic.allKeys[0];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:dic[key] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showFilter:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake((i+1) + i * kMenberBtnW, (self.frame.size.height - kMenberBtnH)/2.0, kMenberBtnW, kMenberBtnH)];
        btn.tag = kMenberBtnTag + i;
        [self.backScrollView addSubview:btn];
        if (_menbers.count -1 == i) {
            [self.backScrollView setContentSize:CGSizeMake(CGRectGetMaxX(btn.frame) + 20, 0)];
        }
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"换个效果" forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(self.frame.size.width - 75 - 20, 0, 75, 30)];
    [closeBtn addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

#pragma mark == event response
- (void)closeButtonClick:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)showFilter:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    if (_lastSelectBtn.selected) {
        _lastSelectBtn.selected = NO;
    }
    
    sender.selected = YES;
    _lastSelectBtn = sender;
    
    NSInteger index = sender.tag - kMenberBtnTag;
    NSDictionary *dic = _menbers[index];
    NSString *key = dic.allKeys[0];

    if (self.delegate && [self.delegate respondsToSelector:@selector(imageFilterName:)])
    {
        [self.delegate imageFilterName:key];
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
