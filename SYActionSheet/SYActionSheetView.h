//
//  SYActionSheetView.h
//  boloyo
//
//  Created by yzdmtd on 13-11-20.
//  Copyright (c) 2013年 sunbb. All rights reserved.
//

#import <UIKit/UIKit.h>

//cancle btn tag
#define kBtnCaccleTag 1100

//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds
#define kWindow [UIApplication sharedApplication].keyWindow

#define kRGB(R,G,B,ALPHA) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:ALPHA]
#define kRGBRef(R,G,B,ALPHA) [kRGB(R,G,B,ALPHA) CGColor]

//只在debug模式下才打印日志
//release后不打印日志
#ifndef SYLog
#if DEBUG
#define SYLog(xxx, ...) NSLog((@"%s [%d行]: " xxx), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define SYLog(xxx, ...)
#endif
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define SY_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define SY_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

@interface SYActionSheetView : UIView
{
    UIView *transparentView;//背景控制 点击移除视图
    UIView *actionSheetView;//主视图
    
@private
    CGFloat actionSheetHeight;//弹出菜单高度
    CGFloat actionSheetY;//弹出菜单y
}

//按钮点击事件回调
@property (nonatomic, copy) void (^syActionSheetActionBlock) (UIButton *);

/**
 *  初始化SYActionSheet
 *
 *  @param title             标题
 *  @param cancelButtonTitle 取消按钮名字
 *  @param otherButtonTitles 其他的按钮名字
 *
 *  @return SYActionSheet
 */
- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 *  显示在哪个视图上
 *
 *  @param view 要显示的父视图
 */
- (void)showSYActionSheetInView:(UIView *)view;
- (void)showSYActionSheet;

/**
 *  隐藏事件
 */
- (void)hideSYActionSheet;

@end
