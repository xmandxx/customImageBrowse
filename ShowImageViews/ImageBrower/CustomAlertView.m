//
//  CustomAlertView.m
//  ShenZhenTax
//
//  Created by 季风 on 16/6/12.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIColor+HTMLColors.h"

#define CustomDeviceWidth     [UIScreen mainScreen].bounds.size.width
#define CustomDeviceHeight    [UIScreen mainScreen].bounds.size.height
#define UnitedBackgroundColor [UIColor colorWithHexString:@"#F2F2F2"]
#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.3f
#define VIEW_BACKGROUNDCOLOR             [UIColor whiteColor]
#define NormalButtonColorHexString                    @"#333333"
#define PromptButtonColorHexString                    @"#0076FF"
#define WarnButtonColorHexString                    @"#FE3824"
#define ButtonHeight                            44
#define ButtonSpacing                           1
#define SectionSpacing                          5

static CGFloat backViewLeftEdge = 32;
static CGFloat labelLeftEdge = 15;
static CGFloat labelTopEdge =22;
static CGFloat textFont =16;
static CGFloat labelBottomEdge =19;
static CGFloat buttonTopEdge = 15;
static CGFloat buttonHeight =40;
static CGFloat buttonLeftEdge = 16;
static CGFloat buttonBetweenEdge = 15;

@interface CustomAlertView()
{
    CGFloat height;
}
@property (strong,nonatomic)UIView *backgroundView;

@property (nonatomic,strong)UIButton *cancelButton;

@end

@implementation CustomAlertView

+ (instancetype)showAlertViewWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtons onCancel:(CancelButtonTouchedBlock)cancelled onDismiss:(OtherButtonTouchedBlock)dismissed {
    CustomAlertView *alert = [[CustomAlertView alloc]initWithMessage:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtons onCancel:cancelled onDismiss:dismissed];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    return alert;
}

- (instancetype)initWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtons onCancel:(CancelButtonTouchedBlock)cancelled onDismiss:(OtherButtonTouchedBlock)dismissed {
    if (self=[super init]) {
        self.frame = CGRectMake(0, 0, CustomDeviceWidth, CustomDeviceHeight);
        self.backgroundColor = WINDOW_COLOR;
        self.alpha = 0;
        
        self.backgroundView = [[UIView alloc]init];
        self.backgroundView.layer.cornerRadius = 8;
        self.backgroundView.backgroundColor = VIEW_BACKGROUNDCOLOR;
        [self addSubview:self.backgroundView];
        [self setMessage:(NSString *)message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtons];
        self.cancelButtonTouchedBlock = cancelled;
        self.otherButtonTouchedBlock = dismissed;
    }
    return self;
}

- (void)didMoveToSuperview {
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

//modified by je
-(void)setMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    for (UIView *subview in [self.backgroundView subviews]) {
        [subview removeFromSuperview];
    }
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.numberOfLines = 0;
    CGSize labelSize = [self getLabelSize:message withFloat:textFont WithLabelWidth:CustomDeviceWidth-2*(labelLeftEdge+backViewLeftEdge)];
    messageLabel.font = [UIFont systemFontOfSize:textFont];
    messageLabel.frame = CGRectMake(labelLeftEdge,labelTopEdge, CustomDeviceWidth-2*(labelLeftEdge+backViewLeftEdge), labelSize.height);
    messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    messageLabel.textAlignment=NSTextAlignmentCenter;
    messageLabel.text = message;
    [self.backgroundView addSubview:messageLabel];
    
    UIView *seperatorLine = [[UIView alloc]initWithFrame:CGRectMake(labelLeftEdge, messageLabel.frame.origin.y+messageLabel.frame.size.height+labelBottomEdge, CustomDeviceWidth-2*(labelLeftEdge+backViewLeftEdge), 1)];
    seperatorLine.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.backgroundView addSubview:seperatorLine];
    
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self setMyCancleButton:self.cancelButton];
    [self.backgroundView addSubview:self.cancelButton];
    
    if (otherButtonTitles.count == 0) //一个取消按钮
    {
        self.cancelButton.frame =CGRectMake(labelLeftEdge, seperatorLine.frame.size.height+seperatorLine.frame.origin.y+buttonTopEdge, CustomDeviceWidth-backViewLeftEdge*2-2*labelLeftEdge, buttonHeight);
    }
    else if (otherButtonTitles.count == 1) //一个取消按钮+一个其他按钮
    {
        CGFloat realButtonWidth =(CustomDeviceWidth-2*(labelLeftEdge+backViewLeftEdge)-buttonLeftEdge)/2;
        
        self.cancelButton.frame = CGRectMake(labelLeftEdge, buttonTopEdge+seperatorLine.frame.size.height+seperatorLine.frame.origin.y, realButtonWidth, buttonHeight);
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(labelLeftEdge+realButtonWidth+buttonLeftEdge, buttonTopEdge+seperatorLine.frame.size.height+seperatorLine.frame.origin.y, realButtonWidth, buttonHeight)];
        button.tag = 1;
        [self setMyCustomButton:button];
        [button setTitle:[otherButtonTitles objectAtIndex:0] forState:UIControlStateNormal];
        [self.backgroundView addSubview:button];
    }
    else
    {
        CGFloat orginY = seperatorLine.frame.origin.y+seperatorLine.frame.size.height+buttonTopEdge;
        

        for (int i = 0; i<otherButtonTitles.count; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(labelLeftEdge,orginY+(buttonBetweenEdge+buttonHeight)*i, CustomDeviceWidth-backViewLeftEdge*2-2*labelLeftEdge, buttonHeight)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelLeftEdge, button.frame.origin.y+button.frame.size.height+buttonBetweenEdge/2, CustomDeviceWidth-backViewLeftEdge*2-2*labelLeftEdge, 1)];
            label.backgroundColor = UnitedBackgroundColor;
            
            [button setTitle:[otherButtonTitles objectAtIndex:i] forState:UIControlStateNormal];
            button.tag = i+1;
            [self setMyCustomButton:button];
            [self.backgroundView addSubview:button];
            [self.backgroundView addSubview:label];

        }
        self.cancelButton.frame = CGRectMake(labelLeftEdge, orginY+otherButtonTitles.count*(buttonHeight+buttonBetweenEdge), CustomDeviceWidth-backViewLeftEdge*2-2*labelLeftEdge, buttonHeight);

    }
    
    if (otherButtonTitles.count>=2) //如果大于2个按钮
    {
        self.backgroundView.frame = CGRectMake(0, 0, CustomDeviceWidth - backViewLeftEdge*2, labelTopEdge+labelSize.height+labelBottomEdge+buttonHeight*(otherButtonTitles.count+1)+(otherButtonTitles.count)*buttonBetweenEdge+2*buttonTopEdge);
    }
    else{
        self.backgroundView.frame  = CGRectMake(0, 0, CustomDeviceWidth - backViewLeftEdge*2, labelTopEdge+labelSize.height+labelBottomEdge+buttonHeight+2*buttonTopEdge);
    }
    
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.borderColor = [UIColor colorWithHexString:@"#dadada"].CGColor;
    self.backgroundView.center = self.center;

}



//设置取消按钮
- (void)setMyCancleButton:(UIButton *)btn
{
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [[UIColor colorWithHexString:@"#cccccc"] CGColor];
    [btn addTarget:self action:@selector(cancelButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
}


//其他按钮样式
- (void)setMyCustomButton:(UIButton *)btn
{
    btn.titleLabel.font=[UIFont systemFontOfSize:textFont];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor colorWithHexString:@"#048adb"];
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(otherButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
}




- (CGSize)getLabelSize:(NSString *)labelStr withFloat:(float)fontNum WithLabelWidth:(float)labelWidth  //label 设置 numberOfLines
{
    NSString *resultStr = [NSString stringWithFormat:@"%@",labelStr];
    if (!resultStr||resultStr.length<=0) {
        return CGSizeZero;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontNum], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [resultStr boundingRectWithSize:CGSizeMake(labelWidth, 30000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return size;
}


//取消按钮事件
-(IBAction)cancelButtonTouched:(id)sender{
    if (self.cancelButtonTouchedBlock) {
        self.cancelButtonTouchedBlock();
    }
    [self dismissSelf];
}

//其他按钮事件
-(IBAction)otherButtonTouched:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (self.otherButtonTouchedBlock) {
        self.otherButtonTouchedBlock(button.tag);
    }
    [self dismissSelf];
}

//移除动画
- (void)dismissSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:16];
        _cancelButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _cancelButton.backgroundColor=[UIColor whiteColor];
        _cancelButton.tag = 1;
    }
    return _cancelButton;
}

@end
