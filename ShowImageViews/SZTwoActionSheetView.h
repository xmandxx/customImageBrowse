//
//  HSWYCustomActionSheetView.h
//  HSWY
//
//  Created by hu on 15/8/26.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SZTwoActionSheetView : UIView

@property (strong,nonatomic)void(^didSelectFirstBlock)(void) ;//点击回调方法
@property (strong,nonatomic)void(^didSelectSecondBlock)(void);

-(instancetype)initWithHeight:(float)height;//设置高度
-(instancetype)initWithNumber:(NSInteger)number;//   2/3
-(void)setButtonTitle:(NSString*)title otherButtonTitle:(NSString*)otherTitle;//设置标题

-(void)showInView:(UIView *)view;//显示方法


@end
