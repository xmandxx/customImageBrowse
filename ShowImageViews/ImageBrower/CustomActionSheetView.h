//
//  CustomActionSheetView.h
//  ShowImageViews
//
//  Created by jeffery on 16/8/26.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActionSheetView : UIView

@property (strong,nonatomic)void(^didSelectFirstBlock)(void) ;//点击回调方法
@property (strong,nonatomic)void(^didSelectSecondBlock)(void);

-(instancetype)initWithNumber:(NSInteger)number;//   2/3
-(void)setButtonTitle:(NSString*)title otherButtonTitle:(NSString*)otherTitle;//设置标题

-(void)show;//显示方法
@end
