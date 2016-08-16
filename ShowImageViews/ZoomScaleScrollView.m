//
//  ZoomScaleScrollView.m
//  ShenZhenTax
//
//  Created by jeffery on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "ZoomScaleScrollView.h"
#import "SZTwoActionSheetView.h"
#import "CustomAlertView.h"

@interface ZoomScaleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZoomScaleScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        self.imgView =[[UIImageView alloc]initWithFrame:CGRectZero];
        self.imgView.contentMode = UIViewContentModeCenter;
        self.imgView.userInteractionEnabled =YES;
        [self addSubview:self.imgView];
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

-(void)setScaleImage:(UIImage *)scaleImage
{
    _scaleImage = scaleImage;
    [self displayImage];
}

- (void)setCanDownLoad:(BOOL)canDownLoad
{
    _canDownLoad = canDownLoad;
    if (_canDownLoad) {
        UILongPressGestureRecognizer *pressGes = [[UILongPressGestureRecognizer alloc]init];
        [pressGes addTarget:self action:@selector(tapImage:)];
        [self.imgView addGestureRecognizer:pressGes];
    }
}
-(void)displayImage
{
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    [self reSetImage:_scaleImage];
}

-(void)reSetImage:(UIImage *)img
{
    if (img) {
        // Set image
        _imgView.image = img;
        // Setup photo frame
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = img.size;
        _imgView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;
        [self setMaxMinZoomScalesForCurrentBounds];
    }
}

- (void)setMaxMinZoomScalesForCurrentBounds{
    
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail
    if (self.imgView.image == nil) return;
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.imgView.frame.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    // If image is smaller than the screen then ensure we show it at
    // min scale of 1
    if (xScale > 1 && yScale > 1) {
        minScale = 1.0;
    }
    // Calculate Max
    CGFloat maxScale = 10.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    
    // Set
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    // Reset position
    self.imgView.frame = CGRectMake(0, 0, self.imgView.frame.size.width,self.imgView.frame.size.height);
    
    [self setNeedsLayout];//212.812
}

-(void)setImgToCenter{
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imgView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    // Center
    if (!CGRectEqualToRect(self.imgView.frame, frameToCenter))
        self.imgView.frame = frameToCenter;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setImgToCenter];
    
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view
{
    if ([self.zoomDelegate respondsToSelector:@selector(beginZoomScale)]) {
        [self.zoomDelegate beginZoomScale];
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return self.imgView;
}

#pragma mark 图片下载
//下载图片
- (void)tapImage:(UILongPressGestureRecognizer *)gesture
{
    if ([gesture state] ==  UIGestureRecognizerStateBegan) {
        SZTwoActionSheetView *actionSheet = [[SZTwoActionSheetView alloc]initWithNumber:2];
        [actionSheet setButtonTitle:@"保存图片" otherButtonTitle:@"取消"];
        __weak typeof(self) weakSelf = self;
        actionSheet.didSelectFirstBlock = ^{[weakSelf savePic:gesture];};
        [actionSheet showInView:self];
    }
    else if ([gesture state]==UIGestureRecognizerStateEnded){
        
    }
}

- (void)savePic:(UILongPressGestureRecognizer *)gesture
{
    
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)gesture.view;
        UIImage *image = imageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}


// 保存图片结果提示
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(error != NULL){
        [CustomAlertView showAlertViewWithMessage:@"保存图片失败" cancelButtonTitle:@"q确定" otherButtonTitles:nil onCancel:nil onDismiss:nil];
        
    }else{
        [CustomAlertView showAlertViewWithMessage:@"保存图片成功" cancelButtonTitle:@"确定" otherButtonTitles:nil onCancel:nil onDismiss:nil];
    }
}

@end
