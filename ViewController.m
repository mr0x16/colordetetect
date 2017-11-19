//
//  ViewController.m
//  colordetetect
//
//  Created by 马雪松 on 2017/11/18.
//  Copyright © 2017年 bestn1nja. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    BOOL fontcolor;
    UIButton *btnChangeColor, *btnDetectColor;
    UISlider *redSlider, *greenSlider, *blueSlider;
    UILabel *redlab, *greenlab, *bluelab, *grayLab;
    int red, green, blue;
    NSNumber *grayscale;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor blackColor]];
    btnChangeColor = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:btnChangeColor];
    [btnChangeColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(@50);
    }];
    [btnChangeColor setTitle:@"changeColor" forState:UIControlStateNormal];
    [btnChangeColor addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor blackColor];
    
    
    redSlider = [[UISlider alloc] init];
    redSlider.maximumValue = 255;
    redSlider.minimumValue =  0;
    redSlider.value = 255;
    [self.view addSubview:redSlider];
    [redSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-30);
        make.centerY.equalTo(self.view.mas_centerY).offset(-90);
        make.width.equalTo(@200);
    }];
    [redSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    redlab = [[UILabel alloc] init];
    redlab.text = [NSString stringWithFormat:@"%d", (int)redSlider.value];
    [self.view addSubview:redlab];
    [redlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redSlider.mas_right).offset(20);
        make.centerY.equalTo(self.view.mas_centerY).offset(-90);
        make.width.equalTo(@50);
    }];
    
    greenSlider = [[UISlider alloc] init];
    greenSlider.maximumValue = 255;
    greenSlider.minimumValue =  0;
    greenSlider.value = 255;
    [self.view addSubview:greenSlider];
    [greenSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-30);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@200);
    }];
    [greenSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    greenlab = [[UILabel alloc] init];
    greenlab.text = [NSString stringWithFormat:@"%d", (int)greenSlider.value];
    [self.view addSubview:greenlab];
    [greenlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(greenSlider.mas_right).offset(20);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@50);
    }];
    
    blueSlider = [[UISlider alloc] init];
    blueSlider.maximumValue = 255;
    blueSlider.minimumValue =  0;
    blueSlider.value = 255;
    [self.view addSubview:blueSlider];
    [blueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-30);
        make.centerY.equalTo(self.view.mas_centerY).offset(90);
        make.width.equalTo(@200);
    }];
    [blueSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    bluelab = [[UILabel alloc] init];
    bluelab.text = [NSString stringWithFormat:@"%d", (int)blueSlider.value];
    [self.view addSubview:bluelab];
    [bluelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueSlider.mas_right).offset(20);
        make.centerY.equalTo(self.view.mas_centerY).offset(90);
        make.width.equalTo(@50);
    }];
    
    grayLab = [[UILabel alloc] init];
    grayLab.text = @"1";
    grayLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:grayLab];
    [grayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-180);
        make.width.equalTo(@200);
        make.height.equalTo(@100);
    }];
//    [self.view addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)sliderValueChange:(id)sender{
    UISlider *control = (UISlider*)sender;
    if ([control isEqual:redSlider]) {
        redlab.text = [NSString stringWithFormat:@"%d", (int)redSlider.value];
    }
    if ([control isEqual:greenSlider]) {
        greenlab.text = [NSString stringWithFormat:@"%d", (int)greenSlider.value];
    }
    if ([control isEqual:blueSlider]) {
        bluelab.text = [NSString stringWithFormat:@"%d", (int)blueSlider.value];
    }
    CGFloat red = redSlider.value / 255.0f;
    CGFloat green = greenSlider.value / 255.0f;
    CGFloat blue = blueSlider.value / 255.0f;
    UIColor *currentColor = [UIColor colorWithDisplayP3Red:red green:green blue:blue alpha:1];
    self.view.backgroundColor =currentColor;
    grayLab.text = [NSString stringWithFormat:@"%.3f", red*RED_FACTOR+green*GREEN_FACTOR+blue*BLUE_FACTOR];
}

-(void)changeColor {
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)detectColor {
    UIImage* image = [self crewlLTCornerImage];
    [self centerGrayOfImage:image];
}

//获取灰度值，为后续通过灰度值判断statusbar文字是黑色还是白色做准备
-(void)centerGrayOfImage:(UIImage *)image{
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    NSInteger centerX = trunc((CGFloat)width/2);
    NSInteger centerY = trunc((CGFloat)height/2);
//    NSLog(@"%s>>>center-X: %ld, center-Y: %ld", __func__, centerX, centerY);
    CGImageRef cgimage = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, -centerX, centerY-2.0);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgimage);
    CGContextRelease(context);
    
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
//    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    [self setValue:[NSNumber numberWithDouble:(red*RED_FACTOR+green*GREEN_FACTOR+blue*BLUE_FACTOR)] forKey:@"grayscale"];
}

//取左上角2*2的图片，通过这个图片的点计算灰度值
-(UIImage *)crewlLTCornerImage {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *crewledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect crewlRect = CGRectMake(0, 0, 2, 2);
    crewledImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([crewledImage CGImage], crewlRect)];
    return crewledImage;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    [self detectColor];
    NSLog(@">>>>%.3f<<<<<<", [grayscale doubleValue]);
    if ([grayscale doubleValue] > GRAY_THRESHOLD) {
        NSLog(@"%s background color is dark, font color is white", __func__);
        return UIStatusBarStyleDefault;
    } else {
        NSLog(@"%s background color is light, font color is black", __func__);
        return UIStatusBarStyleLightContent;
    }
    
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
////    dispatch_queue_t global_queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
////    dispatch_async(global_queue, ^{
//        [self changeColor];
////    });
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
