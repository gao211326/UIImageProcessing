//
//  HomeViewController.m
//  UIImageProcessing
//
//  Created by 高磊 on 2017/5/4.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "HomeViewController.h"
#import "OpenCameraOrPhoto.h"
#import "FilterViewController.h"

@interface HomeViewController ()

//选择相册
@property (nonatomic,strong) UIButton *photoButton;
//选择相机
@property (nonatomic,strong) UIButton *cameraButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UICOLOR_FROM_RGB_OxFF(0xdddddd);
    
    self.title = @"美一下";
    
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.cameraButton];
    
    [self makeViewConstraints];
}

- (void)makeViewConstraints
{
    [_photoButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(64-self.view.frame.size.height/4.0);
    }];
    
    
    [_cameraButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(self.view.frame.size.height/4.0);
    }];
}

#pragma mark == event response
- (void)photoButtonClick:(UIButton *)sender
{
    __weak typeof(self)weakSelf = self;
    
    __block UIImage *blockImage = nil;
    
    [OpenCameraOrPhoto openPhotoWithView:self.view withBlock:^(UIImage *image, NSString *imageName)
    {
        FilterViewController *vc = [[FilterViewController alloc] init];
        blockImage = image;
        vc.image = [blockImage copy];
        
        [weakSelf presentViewController:vc animated:YES completion:^{
            
        }];
    }];
}

- (void)cameraButtonClick:(UIButton *)sender
{
    __weak typeof(self)weakSelf = self;
    
    __block UIImage *blockImage = nil;
    
    [OpenCameraOrPhoto openCameraWithView:self.view withBlock:^(UIImage *image, NSString *imageName)
     {
         FilterViewController *vc = [[FilterViewController alloc] init];
         blockImage = image;
         vc.image = [blockImage copy];
         
         [weakSelf presentViewController:vc animated:YES completion:^{
             
         }];
     }];
}

#pragma mark == 懒加载
- (UIButton *)photoButton
{
    if (nil == _photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}

- (UIButton *)cameraButton
{
    if (nil == _cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
