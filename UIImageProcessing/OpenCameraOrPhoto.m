//
//  OpenCameraOrPhoto.m
//  BaishitongClient
//
//  Created by 高磊 on 15/10/28.
//  Copyright © 2015年 高磊. All rights reserved.
//

#import "OpenCameraOrPhoto.h"

#import <MobileCoreServices/MobileCoreServices.h>
//#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"


static CGFloat const  ADD_ORIGINAL_MAX_WIDTH  =  600.0f;

@interface OpenCameraOrPhoto()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView *    superView;
    
    BOOL        _isPhoto;
}

@end

@implementation OpenCameraOrPhoto


SYNTHESIZE_SINGLETON_FOR_CLASS(OpenCameraOrPhoto)

- (id)init
{
    self = [super init];
    if (self)
    {
        _isPhoto = NO;
    }
    return self;
}

+ (void)openPhotoWithView:(UIView *)view withBlock:(OpenCameraOrPhotoBlock)openCameraOrPhotoBlock
{
    [[OpenCameraOrPhoto sharedInstance] openPhotoWithView:view withBlock:openCameraOrPhotoBlock];
}

- (void)openPhotoWithView:(UIView *)view withBlock:(OpenCameraOrPhotoBlock)openCameraOrPhotoBlock
{
    superView = view;
    // 从相册中选取
    if ([self isPhotoLibraryAvailable]) {
        
        _isPhoto = YES;
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
//        [controller setAllowsEditing:YES];//允许进入编辑模式
        [self.glViewController presentViewController:controller
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
    }
    
    self.openPhotoBlock = openCameraOrPhotoBlock;
}

+ (void)openCameraWithView:(UIView *)view withBlock:(OpenCameraOrPhotoBlock)openCameraOrPhotoBlock
{
    [[OpenCameraOrPhoto sharedInstance] openCameraWithView:view withBlock:openCameraOrPhotoBlock];
}

- (void)openCameraWithView:(UIView *)view withBlock:(OpenCameraOrPhotoBlock)openCameraOrPhotoBlock
{
    superView = view;
    if (self.isCamer)
    {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            
            _isPhoto = NO;
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isRearCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = (id)self;
            [self.glViewController presentViewController:controller
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
        }
    }
    else
    {
        UIAlertController *uialert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                         message:@"您尚未为GLY打开”相机服务“，开启方法为“手机设置-隐私-相机服务-智能消防管理”进行[开启]。"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil)
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action)
                                       
                                       {
                                           
                                           
                                       }];
        
        [uialert addAction:cancelAction];
        
        [([UIApplication sharedApplication].delegate).window.rootViewController presentViewController:uialert animated:YES completion:nil];
    }
    self.openCameraBlock = openCameraOrPhotoBlock;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@" 打印信息:%@",info);
    __weak typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        //编辑后的图片
        UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (editImage) {
            if (_isPhoto) {
                if (weakSelf.openPhotoBlock)
                {
                    weakSelf.openPhotoBlock(editImage,@"");
                }
            }else{
                if (weakSelf.openCameraBlock)
                {
                    weakSelf.openCameraBlock(editImage,@"");
                }
            }
        }else{
        
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            UIImage *upImage = image;
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIImageOrientation imageOrientation = image.imageOrientation;
            if(imageOrientation != UIImageOrientationUp)
            {
                UIGraphicsBeginImageContext(image.size);
                [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
                upImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }

            if (_isPhoto) {
                if (weakSelf.openPhotoBlock)
                {
                    weakSelf.openPhotoBlock(upImage,@"");
                }
            }else{
                if (weakSelf.openCameraBlock)
                {
                    weakSelf.openCameraBlock(upImage,@"");
                }
            }
            

//            
//            NSURL *imageAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
//            
//            PHFetchResult*result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetUrl] options:nil];
//            
//            PHAsset *asset = [result firstObject];
//            
//            PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
//            
//            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:phImageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                
//                NSLog(@" 打印信息++:%@",info);
//                
//                NSData *photoData = imageData;
//                UIImage *image = [UIImage imageWithData:photoData];
//                if (_isPhoto) {
//                    if (weakSelf.openPhotoBlock)
//                    {
//                        weakSelf.openPhotoBlock(image,@"");
//                    }
//                }else{
//                    if (weakSelf.openCameraBlock)
//                    {
//                        weakSelf.openCameraBlock(image,@"");
//                    }
//                }
//                
//            }];
        }
    }];
}

- (UIViewController *)glViewController {
    UIResponder *nextResponder = superView;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}
#pragma mark camera utility
- (BOOL)isCamer
{
    BOOL camer = NO;
    
    __block BOOL blockCamer = camer;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized){
        camer=YES;
    }else if(authStatus==AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             blockCamer = granted;
             
         }];
    }else{
        camer = NO;
    }
    
    return camer;
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie
            sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage
            sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType
                  sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ADD_ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ADD_ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ADD_ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ADD_ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ADD_ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
