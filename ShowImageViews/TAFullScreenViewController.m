//
//  TAFullScreenViewController.m
//  TaxProject
//
//  Created by jeffery on 16/3/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "TAFullScreenViewController.h"
#import "ZoomScaleScrollView.h"

#define PCIphoneDeviceWidth     [UIScreen mainScreen].bounds.size.width
#define PCIphoneDeviceHeight    [UIScreen mainScreen].bounds.size.height
static CGFloat height = 50;

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
    self.scrollView.frame = CGRectMake(0,0, PCIphoneDeviceWidth, PCIphoneDeviceHeight);
    
    self.scrollView.contentSize = CGSizeMake(PCIphoneDeviceWidth*self.thumbArray.count, 0);
    
    self.detailLabel.frame=CGRectMake(0, 0, 100, height);
    
    self.detailLabel.center = CGPointMake(PCIphoneDeviceWidth/2, PCIphoneDeviceHeight-height/2);
    
    self.detailLabel.textColor = [UIColor whiteColor];
    self.deleteButton.frame=CGRectMake(0, 0, height, height);
    self.deleteButton.center = CGPointMake(PCIphoneDeviceWidth-height, PCIphoneDeviceHeight-height/2);
    
}

- (void)setScrollImage
{
    for (int i = 0; i<self.thumbArray.count; i++)
    {
        UIImage *image = self.thumbArray[i];
        ZoomScaleScrollView *scroll = [[ZoomScaleScrollView alloc]initWithFrame:CGRectMake(PCIphoneDeviceWidth*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        scroll.scaleImage = image;
        scroll.zoomDelegate =self;
        scroll.canDownLoad = YES;
        [self.scrollView addSubview:scroll];
 
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(statusNavAnimation)];
        [scroll addGestureRecognizer:gesture];
    }
    [self.scrollView setContentOffset:CGPointMake(PCIphoneDeviceWidth*self.currentI, 0)];
    
    self.title = [NSString stringWithFormat:@"%d/%lu",self.currentI+1,(unsigned long)self.thumbArray.count];
    self.detailLabel.text = [NSString stringWithFormat:@"%d/%lu",self.currentI+1,(unsigned long)self.thumbArray.count];
}

#pragma mark zoomscale delegate
-(void)beginZoomScale
{
    [self hideStatusAndNav];
}


#pragma mark buttonEvent
- (void)didDeleteButton:(id)sender
{
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
    self.title = [NSString stringWithFormat:@"%d/%lu",currentNu+1,(unsigned long)self.thumbArray.count];
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