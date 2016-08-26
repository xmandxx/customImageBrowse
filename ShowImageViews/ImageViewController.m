//
//  ImageViewController.m
//  ShowImageViews
//
//  Created by jeffery on 16/8/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "ImageViewController.h"
#import "FullImageBrowseViewController.h"

@interface ImageViewController ()

@property(nonatomic,strong)NSMutableArray *imageItems;

@end

@implementation ImageViewController

- (instancetype)init
{
    if (self = [super init]) {
        _imageItems = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ UIColor whiteColor];
    UIImage *image1 = [UIImage imageNamed:@"003.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"101.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"102.jpg"];
    UIImage *image4 = [UIImage imageNamed:@"808.jpg"];
    
    [self.imageItems addObject:image1];
    [self.imageItems addObject:image2];
    [self.imageItems addObject:image3];
    [self.imageItems addObject:image4];
    
    
    FullImageBrowseViewController *vc = [[FullImageBrowseViewController alloc]init];
//    vc.thumbArray = self.imageItems;
    NSArray *array =@[@"http://img.taopic.com/uploads/allimg/130203/240422-1302030S62917.jpg",@"http://picm.photophoto.cn/005/008/017/0080170433.jpg",@"http://img.taopic.com/uploads/allimg/130203/240422-1302030S62917.jpg",@"http://pic26.nipic.com/20121222/9252150_193141295302_2.jpg"];
        vc.imageUrlArray = [NSMutableArray arrayWithArray:array];
    vc.canDeleteImage =YES;
    vc.canBeDownload = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
