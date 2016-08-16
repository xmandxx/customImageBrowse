//
//  HSWYCustomActionSheetView.m
//  HSWY
//
//  Created by hu on 15/8/26.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SZTwoActionSheetView.h"


#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.3f
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor lightGrayColor]
#define ButtonHeight                            44
#define PCIphoneDeviceWidth     [UIScreen mainScreen].bounds.size.width
#define PCIphoneDeviceHeight    [UIScreen mainScreen].bounds.size.height

@interface SZTwoActionSheetView()

@property (strong,nonatomic)UIButton *cameraButton;
@property (strong,nonatomic)UIButton *photographButton;
@property (strong,nonatomic)UIButton *cancelButton;
@property (strong,nonatomic)UIView *backgroundaView;
@property (nonatomic)NSInteger number;

@end

@implementation SZTwoActionSheetView


-(instancetype)initWithHeight:(float)height{
    self=[super init];
    if (self) {
        self.number = 3;
        self.frame = CGRectMake(0, 0, PCIphoneDeviceWidth, PCIphoneDeviceHeight);
        self.backgroundColor = WINDOW_COLOR;
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        
        self.backgroundaView = [[UIView alloc] initWithFrame:CGRectMake(0, PCIphoneDeviceHeight, PCIphoneDeviceWidth, height)];
        self.backgroundaView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;

        [self addSubview:self.backgroundaView];
        
        [self.backgroundaView addSubview:self.cameraButton];
        [self.backgroundaView addSubview:self.photographButton];
        [self.backgroundaView addSubview:self.cancelButton];

        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.backgroundaView setFrame:CGRectMake(0, PCIphoneDeviceHeight-height, PCIphoneDeviceWidth, height)];
        } completion:^(BOOL finished) {
        }];
    }
    return self;
}

-(instancetype)initWithNumber:(NSInteger)number{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, PCIphoneDeviceWidth, PCIphoneDeviceHeight);
        self.backgroundColor = WINDOW_COLOR;
        
        self.number =number;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        
        self.backgroundaView = [[UIView alloc] initWithFrame:CGRectMake(0, PCIphoneDeviceHeight, PCIphoneDeviceWidth, number*ButtonHeight)];
        self.backgroundaView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
        
        [self addSubview:self.backgroundaView];
        
        if (self.number == 2) {
            [self.backgroundaView addSubview:self.cameraButton];
            [self.backgroundaView addSubview:self.cancelButton];
        }
        else{
            [self.backgroundaView addSubview:self.cameraButton];
            [self.backgroundaView addSubview:self.photographButton];
            [self.backgroundaView addSubview:self.cancelButton];
        }
        
    
        
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.backgroundaView setFrame:CGRectMake(0, PCIphoneDeviceHeight-ButtonHeight*number, PCIphoneDeviceWidth, ButtonHeight*number)];
        } completion:^(BOOL finished) {
        }];

    }
    return self;
}


-(UIButton*)cameraButton{
    if (!_cameraButton) {
        _cameraButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, PCIphoneDeviceWidth, ButtonHeight)];
        _cameraButton.titleLabel.font=[UIFont systemFontOfSize:16];
        _cameraButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _cameraButton.backgroundColor=[UIColor whiteColor];
        [_cameraButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
        [self.cameraButton addTarget:self action:@selector(didSelectedFirstButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}


-(UIButton*)photographButton{
    if (!_photographButton) {
        _photographButton=[[UIButton alloc]initWithFrame:CGRectMake(0, ButtonHeight+1, PCIphoneDeviceWidth, ButtonHeight)];
        _photographButton.titleLabel.font=[UIFont systemFontOfSize:16];
        _photographButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _photographButton.backgroundColor=[UIColor whiteColor];
        [_photographButton setTitle:@"从手机相册选取" forState:UIControlStateNormal];
        [_photographButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.photographButton addTarget:self action:@selector(didSelectedSecondButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photographButton;
}

-(UIButton*)cancelButton{
    if (!_cancelButton) {
        if (self.number == 3) {
            _cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(0, ButtonHeight*2+6, PCIphoneDeviceWidth, ButtonHeight)];
 
        }
        else
        {
            _cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(0, ButtonHeight+1, PCIphoneDeviceWidth, ButtonHeight)];
 
        }
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:16];
        _cancelButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        _cancelButton.backgroundColor=[UIColor whiteColor];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _cancelButton;
}

-(void)didSelectedFirstButton{
    self.didSelectFirstBlock();
    [self tappedCancel];
}

-(void)didSelectedSecondButton{
    self.didSelectSecondBlock();
    [self tappedCancel];
}

-(void)setButtonTitle:(NSString*)title otherButtonTitle:(NSString*)otherTitle{
    [self.cameraButton setTitle:title forState:UIControlStateNormal];
    [self.photographButton setTitle:otherTitle forState:UIControlStateNormal];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.backgroundaView setFrame:CGRectMake(0, PCIphoneDeviceHeight, PCIphoneDeviceWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)showInView:(UIView *)view{
//    [[self getCurrentVC].view addSubview:self];
    [view addSubview:self];
}


- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}









@end
