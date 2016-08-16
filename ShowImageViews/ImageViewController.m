//
//  ImageViewController.m
//  ShowImageViews
//
//  Created by jeffery on 16/8/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "ImageViewController.h"
#import "TAFullScreenViewController.h"

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
    
    
    TAFullScreenViewController *vc = [[TAFullScreenViewController alloc]init];
    vc.thumbArray = self.imageItems;
    vc.canDeleteImage =YES;
    vc.canBeDownload = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
