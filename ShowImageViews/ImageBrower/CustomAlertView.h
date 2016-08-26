//
//  CustomAlertView.h
//  ShenZhenTax
//
//  Created by 季风 on 16/6/12.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

//用typedef定义DismissBlock和CancelBlock
typedef void (^OtherButtonTouchedBlock)(long buttonIndex);
typedef void (^CancelButtonTouchedBlock)();
typedef void (^CancelBlock)();

@interface CustomAlertView : UIView
@property (strong,nonatomic) CancelBlock cancelButtonTouchedBlock;
@property (strong,nonatomic) OtherButtonTouchedBlock otherButtonTouchedBlock;


- (instancetype)initWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtons onCancel:(CancelButtonTouchedBlock)cancelled onDismiss:(OtherButtonTouchedBlock)dismissed;

/**
 *	@brief	实例化
 *
 *	@param 	message 	消息
 *	@param 	cancelButtonTitle 	取消标题
 *	@param 	otherButtons 	其他按钮标题
 *	@param 	cancelled 	取消block
 *	@param 	dismissed 	其他按钮点击block
 *
 *	@return	实例
 */
+ (instancetype)showAlertViewWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtons onCancel:(CancelButtonTouchedBlock)cancelled onDismiss:(OtherButtonTouchedBlock)dismissed;
@end
