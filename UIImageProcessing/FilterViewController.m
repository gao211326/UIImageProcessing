//
//  ViewController.m
//  UIImageProcessing
//
//  Created by 高磊 on 2017/4/28.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "FilterViewController.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+Filter.h"
#import "ChooseFilterView.h"
#import "FilterMenberView.h"
#import "FilterImageView.h"

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )

@interface FilterViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,ChooseFilterViewDelegate,FilterMenberViewDelegate>

//@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) FilterImageView *imageView;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,strong) NSMutableArray *filterDatas;

@property (nonatomic,strong) NSMutableArray *filterCategorys;

@property (nonatomic,strong) ChooseFilterView *chooseFilterView;

@property (nonatomic,strong) NSDictionary *filterCategoryDic;

@end

@implementation FilterViewController

- (void)dealloc
{

}

- (id)init
{
    if (self) {

        //加载数据
        self.filterCategorys = [NSMutableArray arrayWithObjects:@{kCICategoryColorEffect:@"颜色效果"},@{kCICategoryColorAdjustment:@"颜色调整"},@{kCICategoryBlur:@"模糊效果"},@{kCICategoryCompositeOperation:@"复合操作"},@{kCICategoryDistortionEffect:@"失真效果"},@{kCICategoryGeometryAdjustment:@"几何调整"},@{kCICategorySharpen:@"锐化"},@{kCICategoryStylize:@"风格化"},@{kCICategoryTransition:@"过渡效果"}, nil];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FilterCategory" ofType:@"plist"];
        
        self.filterCategoryDic = [NSDictionary dictionaryWithContentsOfFile:path];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Will Beautiful";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addCloseButton];
    [self addSaveButton];
    
//    self.filterDatas = [NSMutableArray arrayWithObjects:@{@"OriginImage":@"原图"},
//                        @{@"CIColorClamp":@"颜色"},
//                        @{@"CIHueAdjust":@"图像色调"},
//                        @{@"CIColorPolynomial":@"颜色--"},
//                        @{@"CIColorCrossPolynomial":@"颜色1"},
//                        @{@"CIPhotoEffectNoir":@"黑白"},
//                        @{@"CIPhotoEffectInstant":@"怀旧"},
//                        @{@"CIPhotoEffectProcess":@"冲印"},
//                        @{@"CIPhotoEffectFade":@"褪色"},
//                        @{@"CIPhotoEffectTonal":@"色调"},
//                        @{@"CIPhotoEffectMono":@"单色"},
//                        @{@"CIPhotoEffectChrome":@"铬黄"},
//                        @{@"CISepiaTone":@"棕色色调"},
//                        @{@"CIPixellate":@"马赛克"},
//                        @{@"CIDiscBlur":@"铬黄3"},
//                        @{@"CIGaussianBlur":@"模糊"},
//                        @{@"CIMedianFilter":@"铬黄5"},
//                        @{@"CIMotionBlur":@"铬黄6"},
//                        @{@"CINoiseReduction":@"铬黄7"},
//                        @{@"CIZoomBlur":@"铬黄8"},
//                        @{@"CIMaskedVariableBlur":@"模糊-"},
//                        @{@"CIColorCrossPolynomial":@"铬黄10"},
//                        @{@"CIColorCube":@"铬黄11"},
//                        @{@"CIColorCubeWithColorSpace":@"铬黄12"},
//                        @{@"CIColorInvert":@"图像的颜色反转"},
//                        @{@"CIColorMap":@"铬黄14"},
//                        @{@"CIColorMonochrome":@"铬黄15"},
//                        @{@"CIColorPosterize":@"铬黄16"},
//                        @{@"CIFalseColor":@"铬黄17"},
//                        @{@"CIMaskToAlpha":@"铬黄18"},
//                        @{@"CIMaximumComponent":@"铬黄19"},
//                        @{@"CIMinimumComponent":@"铬黄20"},
//                        @{@"CIPhotoEffectChrome":@"铬黄21"},nil];
    

    
//    NSDictionary *dic = self.filterCategorys[0];
//    NSString *key = dic.allKeys[0];
//    
//    self.filterDatas = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:key]];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.chooseFilterView];
    
    [_chooseFilterView setCategorys:self.filterCategorys];
    
//    [self.view addSubview:self.pickerView];
    
//    [self.pickerView reloadAllComponents];
    
//    [self setImageWithFilterName:self.filterDatas[0]];
}

- (void)addCloseButton
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10, 20, 30, 30);
    [closeButton setImage:[UIImage imageNamed:@"叉"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)addSaveButton
{
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, 20, 30, 30);
    [saveButton setImage:[UIImage imageNamed:@"勾"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

- (void)processingImage
{
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    // 得到CGImage的宽高
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    

    //每像素大小
    NSUInteger bytesPerPixel = 4;
    //每行有多大
    NSUInteger bytesPerRow = bytesPerPixel *width;
    //每个颜色通道大小
    NSUInteger bitsPerComponent = 8;
    //UInt32 4字节
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width,sizeof(UInt32));
    
    //创建一个RGB模式的颜色空间CGColorSpace和一个容器CGBitmapContext,将像素指针参数传递到容器中缓存进行存储
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context =  CGBitmapContextCreate(pixels, width, height,bitsPerComponent,bytesPerRow, colorSpace,     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    /*
     CGContextRef __nullable CGBitmapContextCreate(
     void * __nullable data,//指向要渲染的绘制内存的地址。这个内存块的大小至少是（bytesPerRow*height）个字节
     size_t width,//bitmap的宽度,单位为像素
     size_t height, // bitmap的高度,单位为像素
     size_t bitsPerComponent,//内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
     size_t bytesPerRow,//bitmap的每一行在内存所占的比特数
     CGColorSpaceRef cg_nullable space,// bitmap上下文使用的颜色空间。
     uint32_t bitmapInfo//指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
     )
    */
    
    
    //把缓存中的图形绘制到显示器上。像素的填充格式是由你在创建context的时候进行指定的
    CGContextDrawImage(context, CGRectMake(0,0, width, height), inputCGImage);
    
    //清除colorSpace和context
    CGColorSpaceRelease(colorSpace); 
    CGContextRelease(context);
    
    //打印图像的颜色值


//    // 2.
//    UInt32 * currentPixel = pixels;
//    for (NSUInteger j = 0; j < height; j++) {
//        for (NSUInteger i = 0; i < width; i++) {
//            //指针
//            UInt32 color = *currentPixel;
//            printf("%3.0f ",(R(color)+G(color)+B(color))/3.0);
//            //指针加1，即指向下一个地址，会移动四个字节
//            currentPixel++; 
//        } 
//        printf("\n"); 
//    }
    
    
//    for (NSUInteger j = 0; j < height; j++) {
//        for (NSUInteger i = 0; i < width; i++) {
//            UInt32 * currentPixel = pixels + (j * width) + i;
//            UInt32 color = *currentPixel;
//            
//            // Average of RGB = greyscale
//            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;
//                NSLog(@" 打印信息:%u",A(color));
////            *currentPixel = RGBAMake(averageColor,averageColor,averageColor, A(color));
//        }
//    }
    //获取图片
//    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
//    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
}

- (void)setImageWithFilterName:(NSString *)name
{
    __weak typeof(self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        CIFilter *filter = [CIFilter filterWithName:name];
        
//        UIImage *image = [UIImage filterImage:weakSelf.image filterName:name];
        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.imageView.image = image;
            
            weakSelf.imageView.filter = filter;
        });
    });
}

#pragma mark == event response
- (void)saveImage:(UIButton *)sender
{

}


- (void)close:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark == ChooseFilterViewDelegate
- (void)showFilterMenberWithCategoryName:(NSString *)name point:(CGPoint)point
{
    NSMutableArray *array = self.filterCategoryDic[name];
    if (array != nil && array.count > 0) {
        FilterMenberView *menberView = [[FilterMenberView alloc] initWithFrame:self.chooseFilterView.frame];
        menberView.delegate = (id)self;
        [self.view addSubview:menberView];
        
        [menberView setMenbers:array];
    }
}

#pragma mark == FilterMenberViewDelegate
- (void)imageFilterName:(NSString *)name
{
    [self setImageWithFilterName:name];
}


#pragma mark == UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)componen
{
    if (componen == 0) {
        return self.filterCategorys.count;
    }else{
        return self.filterDatas.count;
    }
}

#pragma mark == UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSDictionary *dic = self.filterCategorys[row];
        NSString *key = dic.allKeys[0];
        NSString *str = dic[key];
        return str;
    }else{
//        NSDictionary *dic = self.filterDatas[row];
//        NSString *key = dic.allKeys[0];
//        NSString *str = dic[key];
//        return str;
        
        return self.filterDatas[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSDictionary *dic = self.filterCategorys[row];
        NSString *key = dic.allKeys[0];
        
        [self.filterDatas removeAllObjects];
        self.filterDatas = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:key]];
        
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        
        NSString *filterkey = self.filterDatas[0];
        [self setImageWithFilterName:filterkey];
        
    }else{
//        NSDictionary *dic = self.filterDatas[row];
//        NSString *key = dic.allKeys[0];
        NSString *key = self.filterDatas[row];
        [self setImageWithFilterName:key];
    }
}

#pragma mark == 懒加载
//- (UIImageView *)imageView
//{
//    if (nil == _imageView) {
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100 - 64)];
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.image = self.image;
//    }
//    return _imageView;
//}

- (FilterImageView *)imageView
{
    if (nil == _imageView) {
        _imageView = [[FilterImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100 - 64)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = self.image;
    }
    return _imageView;
}


- (ChooseFilterView *)chooseFilterView
{
    if (!_chooseFilterView) {
        _chooseFilterView = [[ChooseFilterView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
        _chooseFilterView.delegate = (id)self;
    }
    return _chooseFilterView;
}

- (UIPickerView *)pickerView
{
    if (nil == _pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
        _pickerView.backgroundColor = [UIColor cyanColor];
        _pickerView.dataSource = (id)self;
        _pickerView.delegate = (id)self;
    }
    return _pickerView;
}

- (NSDictionary *)filterCategoryDic
{
    if (!_filterCategoryDic) {
        _filterCategoryDic = [[NSDictionary alloc] init];
    }
    return _filterCategoryDic;
}

- (NSMutableArray *)filterDatas
{
    if (nil == _filterDatas) {
        _filterDatas = [[NSMutableArray alloc] init];
    }
    return _filterDatas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
