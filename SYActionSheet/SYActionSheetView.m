//
//  SYActionSheetView.m
//  boloyo
//
//  Created by yzdmtd on 13-11-20.
//  Copyright (c) 2013年 sunbb. All rights reserved.
//

#import "SYActionSheetView.h"

@interface SYActionSheetView ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, copy) NSString *aTitle;
@property (nonatomic, copy) NSString *aCancleTitle;

@end

@implementation SYActionSheetView

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super init])
    {
        _aTitle = title;
        
        _btnArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        if (cancelButtonTitle)
        {
            _aCancleTitle = cancelButtonTitle;

            UIButton *cancleabutton = [[UIButton alloc] initWithFrame:CGRectZero];
            
            cancleabutton.tag = kBtnCaccleTag;
            //cancleabutton.backgroundColor = [UIColor yellowColor];
            [cancleabutton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [cancleabutton setBackgroundImage:[[UIImage imageNamed:@"ActionSheet_Btn_Cancle"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
            [cancleabutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancleabutton addTarget:self action:@selector(cancleEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_btnArray addObject:cancleabutton];
        }

        int i = kBtnCaccleTag;

        id eachObject;
        
        va_list argList;
        
        if(otherButtonTitles)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
            button.tag = ++i;
            //button.backgroundColor = [UIColor yellowColor];
            [button setTitle:otherButtonTitles forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"ActionSheet_Btn_Normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];

            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(actionWithNormalButton:) forControlEvents:UIControlEventTouchUpInside];
            [_btnArray addObject:button];
            
            va_start(argList,otherButtonTitles);
            
            while ((eachObject = va_arg(argList,id)))
            {
                UIButton *_button = [[UIButton alloc] initWithFrame:CGRectZero];
                _button.tag = ++i;
                //_button.backgroundColor = [UIColor yellowColor];
                [_button setTitle:(NSString *)eachObject forState:UIControlStateNormal];
                [_button setBackgroundImage:[[UIImage imageNamed:@"ActionSheet_Btn_Normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];

                [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_button addTarget:self action:@selector(actionWithNormalButton:) forControlEvents:UIControlEventTouchUpInside];
                [_btnArray addObject:_button];
            }
            
            va_end(argList);
        }
        
        [self initUI];
    }
    
    return self;
}

- (void)actionWithNormalButton:(UIButton *)abtn
{
    [self hideSYActionSheet];

    if (self.syActionSheetActionBlock) {
        self.syActionSheetActionBlock(abtn);
    }
}

- (void)initUI
{
    transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSYActionSheet)];
    tap.numberOfTapsRequired = 1;
    [transparentView addGestureRecognizer:tap];
    
    CGFloat btnWidth = CGRectGetWidth(transparentView.frame) - 20,btnHeight = 45,btnSpace = 10,normalSpace = 30;
    
    actionSheetHeight = btnHeight * _btnArray.count + btnSpace * (_btnArray.count - 2) + normalSpace * 3;

    actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, actionSheetHeight)];
    actionSheetView.backgroundColor = [UIColor whiteColor];
    actionSheetView.layer.borderWidth = 1.0;
    actionSheetView.layer.borderColor = kRGBRef(87.0, 87.0, 87.0, 1.0);
    actionSheetView.alpha = 0.95;
    [self addSubview:actionSheetView];
    
    __block CGRect frame = CGRectZero;

    if (self.aTitle)
    {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, transparentView.frame.size.width - 10, 0)];
        titleLab.font = [UIFont systemFontOfSize:12.0];
        titleLab.textColor = [UIColor darkGrayColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.numberOfLines = 0;
        titleLab.text = self.aTitle;
        titleLab.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLab];
        
        CGSize labSize = SY_MULTILINE_TEXTSIZE(self.aTitle, [UIFont systemFontOfSize:12.0], CGSizeMake(CGRectGetWidth(titleLab.frame), MAXFLOAT), NSLineBreakByCharWrapping);
        frame = titleLab.frame;
        frame.size.height = labSize.height;
        titleLab.frame = frame;
        
        actionSheetHeight = btnHeight * _btnArray.count + btnSpace * (_btnArray.count - 2) + normalSpace * 2;
        normalSpace = labSize.height + 10;
        actionSheetHeight += normalSpace;
        
        frame = actionSheetView.frame;
        frame.size.height = actionSheetHeight;
        actionSheetView.frame = frame;
    }
    
    frame = CGRectMake(10, 0, btnWidth, btnHeight);
    
    [_btnArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop){
    
        if (obj.tag == kBtnCaccleTag)
        {
            frame.origin.y = actionSheetHeight - btnHeight - 30;
        }
        else
        {
            frame.origin.y = normalSpace + (btnSpace + btnHeight) * (idx - 1);
        }
        obj.frame = frame;
        
        [self addSubview:obj];
    }];
}

- (void)dealloc
{
    if (_btnArray) {
        [_btnArray removeAllObjects],_btnArray = nil;
    }
    
    if (_syActionSheetActionBlock) {
        _syActionSheetActionBlock = nil;
    }
    
    _aTitle = nil;
    _aCancleTitle = nil;
}

- (void)cancleEvent:(id)sender
{
    SYLog(@"cancleEvent");
    
    [self hideSYActionSheet];
}


#pragma mark -
#pragma mark PickerView show/hide

- (void)hideSYActionSheet
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         transparentView.alpha = 0.0;
                         
                         self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);

                         //self.frame = CGRectMake(0, KDeviceHeight, kDeviceWidth, KDeviceHeight - 64);
                     } completion:^(BOOL finished) {
                         [transparentView removeFromSuperview];
                         [self removeSelf];
                     }];
}

- (void)removeSelf
{
    [self removeFromSuperview];
    self.isShow = NO;

    SYLog(@"-------------- pickerView removed!!!!");
}

- (void)showSYActionSheet
{
    [self showSYActionSheetInView:kWindow];
}

- (void)showSYActionSheetInView:(UIView *)view
{
    CGFloat vH = CGRectGetHeight(view.frame);
    
	self.frame = CGRectMake(0, KDeviceHeight, kDeviceWidth, actionSheetHeight);
    actionSheetY = vH - actionSheetHeight;
    
    [view addSubview:self];
    [view insertSubview:transparentView belowSubview:self];

    self.isShow = YES;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         transparentView.alpha = 0.4;
                         self.frame = CGRectMake(0, actionSheetY, kDeviceWidth, actionSheetHeight);
                     }
                     completion:^(BOOL finished) {}];
}

@end
