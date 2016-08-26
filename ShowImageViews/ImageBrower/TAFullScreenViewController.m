//
//  TAFullScreenViewController.m
//  TaxProject
//
//  Created by jeffery on 16/3/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "TAFullScreenViewController.h"
#import "ZoomScaleScrollView.h"

#define CustomDeviceWidth     [UIScreen mainScreen].bounds.size.width
#define CustomDeviceHeight    [UIScreen mainScreen].bounds.size.height

@interface TAFullScreenViewController ()<UIScrollViewDelegate,ZoomScaleDelegate>
{
    NSInteger currentNu;
}
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UILabel *detailLabel;

@property (nonatomic,strong)UIButton *deleteButton;


@property (nonatomic)BOOL ShowNav;//在点击之后判断是否需要在滑动以及放大里面隐藏

@property (nonatomic) BOOL statusBarIsHidden;//statusBarIsHidden点击的时候直接判断是否显示




@end

@implementation TAFullScreenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarIsHidden = NO;
    self.ShowNav = YES;

    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [self getMyLeftBarButtonItem];

    if (self.canDeleteImage) {
        self.navigationItem.rightBarButtonItem = [self getMyRightBarButtonItem];

    }

    [self addPageView];
    [self layoutPageView];
    currentNu = self.currentI;
    [self setScrollImage];
}


- (void)addPageView
{
    [self.view addSubview:self.scrollView];
}


- (void)layoutPageView
{
    self.scrollView.frame = CGRectMake(0,0, CustomDeviceWidth, CustomDeviceHeight);
    
}

- (void)setScrollImage
{
    if ([self isImageArray])
    {
        for (int i = 0; i<self.thumbArray.count; i++)
        {
            UIImage *image = self.thumbArray[i];
            ZoomScaleScrollView *scroll = [[ZoomScaleScrollView alloc]initWithFrame:CGRectMake(CustomDeviceWidth*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
            scroll.scaleImage = image;
            scroll.zoomDelegate =self;
            scroll.canDownLoad = self.canBeDownload;
            [self.scrollView addSubview:scroll];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(statusNavAnimation)];
            [scroll addGestureRecognizer:gesture];
        }
        [self.scrollView setContentOffset:CGPointMake(CustomDeviceWidth*self.currentI, 0)];
        self.title = [NSString stringWithFormat:@"%d/%lu",self.currentI+1,(unsigned long)self.thumbArray.count];

    }
    else if ([self isImageUrlArray])
    {
        for (int i = 0 ; i<self.imageUrlArray.count; i++)
        {
            ZoomScaleScrollView *scroll = [[ZoomScaleScrollView alloc]initWithFrame:CGRectMake(CustomDeviceWidth*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
            scroll.imageUrl = self.imageUrlArray[i];
            scroll.zoomDelegate =self;
            scroll.canDownLoad = self.canBeDownload;
            [self.scrollView addSubview:scroll];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(statusNavAnimation)];
            [scroll addGestureRecognizer:gesture];
        }
        [self.scrollView setContentOffset:CGPointMake(CustomDeviceWidth*self.currentI, 0)];
        
        self.detailLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentI+1,(unsigned long)self.imageUrlArray.count];
        self.title = [NSString stringWithFormat:@"%d/%lu",self.currentI+1,(unsigned long)self.imageUrlArray.count];

    }

}


#pragma mark
#pragma mark Setter方法
- (void)setCurrentI:(NSInteger)currentI
{
    _currentI = currentI;
    currentNu = _currentI;
    
}

- (void)setThumbArray:(NSMutableArray *)thumbArray
{
    _thumbArray = thumbArray;
    self.scrollView.contentSize = CGSizeMake(CustomDeviceWidth*_thumbArray.count, 0);
}

- (void)setImageUrlArray:(NSMutableArray *)imageUrlArray
{
    _imageUrlArray = imageUrlArray;
    self.scrollView.contentSize =CGSizeMake(CustomDeviceWidth*_imageUrlArray.count, 0);
}



#pragma mark private
#pragma mark  -- 判断传人是image数组还是地址数组
- (BOOL)isImageArray{
    if (self.thumbArray.count>0) {
        return YES;
    }
    return NO;
}

- (BOOL)isImageUrlArray
{
    if (self.imageUrlArray.count>0) {
        return YES;
    }
    return NO;
}

- (CGSize)getStringSize:(NSString *)str withFloat:(float)fontNum
{
    if ([str isKindOfClass:[NSString class]] && str.length>0) {
        CGSize strSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontNum]}];
        return strSize;
    }
    return CGSizeZero;
}


#pragma mark zoomscale delegate
-(void)beginZoomScale
{
    [self hideStatusAndNav];
}


#pragma mark buttonEvent
- (void)didDeleteButton:(id)sender
{
    if (self.thumbArray) {
        if (self.thumbArray.count == 1)
        {
            [self.thumbArray removeObjectAtIndex:0];
            if (self.indexBlock) {
                self.indexBlock(currentNu);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if (currentNu == self.thumbArray.count-1)
            {
                self.currentI = currentNu-1;
            }
            else
            {
                self.currentI = currentNu;
            }
            for (UIImageView *view in self.scrollView.subviews)
            {
                [view removeFromSuperview];
            }
            [self.thumbArray removeObjectAtIndex:currentNu];
            if (self.indexBlock) {
                self.indexBlock(currentNu);
            }
            [self setScrollImage];
        }
    }
    else if (self.imageUrlArray)
    {
        if (self.imageUrlArray.count == 1)
        {
            [self.imageUrlArray removeObjectAtIndex:0];
            if (self.indexBlock) {
                self.indexBlock(currentNu);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if (currentNu == self.imageUrlArray.count-1)
            {
                self.currentI = currentNu-1;
            }
            else
            {
                self.currentI = currentNu;
            }
            for (UIImageView *view in self.scrollView.subviews)
            {
                [view removeFromSuperview];
            }
            [self.imageUrlArray removeObjectAtIndex:currentNu];
            if (self.indexBlock) {
                self.indexBlock(currentNu);
            }
            [self setScrollImage];
        }
    }
}


#pragma mark 状态栏导航栏隐藏动画
- (void)hideStatusAndNav
{
    if (self.ShowNav) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.ShowNav = NO;
        self.statusBarIsHidden = !self.statusBarIsHidden;
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self setNeedsStatusBarAppearanceUpdate];
                         }];
    }
    
}


- (void)statusNavAnimation
{
    if (!self.statusBarIsHidden)
    {
        self.ShowNav = NO;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.ShowNav = YES;
    }
    self.statusBarIsHidden = !self.statusBarIsHidden;

    [UIView animateWithDuration:0.4
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                     }];

}

//status动画
- (BOOL)prefersStatusBarHidden
{
    return self.statusBarIsHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideStatusAndNav];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentNu = scrollView.contentOffset.x/scrollView.frame.size.width;
    if ([self isImageArray]) {
        self.title = [NSString stringWithFormat:@"%d/%lu",currentNu+1,(unsigned long)self.thumbArray.count];
    }
    else if ([self isImageUrlArray])
    {
        self.title = [NSString stringWithFormat:@"%d/%lu",currentNu+1,(unsigned long)self.imageUrlArray.count];
        
    }
}

#pragma mark init
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(didDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIBarButtonItem *)getMyLeftBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(didBackButton)];
    return item;
}

- (UIBarButtonItem *)getMyRightBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStylePlain target:self action:@selector(didDeleteButton:)];
    
    return  item;
}

- (void)didBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end