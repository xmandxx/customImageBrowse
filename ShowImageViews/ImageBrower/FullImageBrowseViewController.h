//
//  FullImageBrowseViewController.h
//  ShowImageViews
//
//  Created by jeffery on 16/8/26.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullImageBrowseViewController : UIViewController
typedef void(^returnIndexBlock)(NSInteger index);/**<返回下标block*/


@property(nonatomic,strong)NSMutableArray* thumbArray;/**<图片数组*/

@property (nonatomic,strong)NSMutableArray * imageUrlArray;/**<图片地址数字*/


@property (nonatomic)NSInteger currentI;/**<当前下标*/

@property (nonatomic,strong)returnIndexBlock indexBlock;

@property (nonatomic)BOOL canDeleteImage;//能否删除图片

@property (nonatomic)BOOL canBeDownload;//能否下载图片
@end
