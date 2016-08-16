//
//  ZoomScaleScrollView.h
//  ShenZhenTax
//
//  Created by jeffery on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZoomScaleScrollView;

@protocol ZoomScaleDelegate <NSObject>

@optional

- (void)beginZoomScale;/**<开始缩放*/

@end

@interface ZoomScaleScrollView : UIScrollView

@property (nonatomic,strong)UIImage *scaleImage;

@property (nonatomic,assign)BOOL canDownLoad;

@property (nonatomic,weak)id <ZoomScaleDelegate> zoomDelegate;

@end
