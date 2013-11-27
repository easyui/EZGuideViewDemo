//
//  EZGuideView.h
//  EZGuideViewDemo
//
//  Created by NeuLion SH on 13-11-26.
//  Copyright (c) 2013年 cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    EZGuideViewNone = 0,
    EZGuideViewAbove,
    EZGuideViewDown,
} EZGuideViewOrientation;

@class EZGuideView;

@protocol EZGuideViewDelegate <NSObject>

@optional
- (void)popoverViewDidDismiss:(EZGuideView *)popoverView;
@end

@interface EZGuideView : UIView {

}   
@property (nonatomic, weak) id <EZGuideViewDelegate>    delegate;       

// 内容
@property (nonatomic, strong) UIFont            *subFont;               
@property (nonatomic, strong) UIColor           *subTextColor;          
@property (nonatomic, strong) UIColor           *subTextHighlightColor; 
@property (nonatomic, assign)  NSTextAlignment  subTextAlignment;       

// contentView
@property (nonatomic, strong) UIColor           *contentViewBackgroundColor;    
@property (nonatomic, strong) UIImage           *contentViewBackgroundImage;    

// pop view
@property (nonatomic, strong) NSMutableArray            *orientations;
@property (nonatomic, strong) UIColor                   *shadowColor;
@property (nonatomic, assign) CGSize                    shadowOffset;
@property (nonatomic, assign) CGFloat                   shadowBlurRadius;
@property (nonatomic, assign) CGFloat                   boxPadding;
@property (nonatomic, assign) CGFloat                   boxRadius;          // box四个角的角度
@property (nonatomic, assign) CGFloat                   controlPointOffset; //
@property (nonatomic, assign) CGFloat                   horizontalMargin;   // 外边到屏幕的至少距离
@property (nonatomic, assign) CGFloat                   topMargin;          // 这个具体防止pop在上面时顶到nav bar等，一般不需要改，默认值50.f

// 箭头
@property (nonatomic, assign) CGFloat   arrowHeight;
@property (nonatomic, assign) CGFloat   arrowHorizontalPadding;
@property (nonatomic, assign) CGFloat   arrowCurvature; // 箭头两边的曲率，当为0时两边是直线

// 边框
@property (nonatomic, assign) BOOL      showBorder;
@property (nonatomic, strong) UIColor   *borderColor;
@property (nonatomic, assign) CGFloat   borderLineWidth;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)textArr;
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)textArr orientation:(EZGuideViewOrientation)orientation;

- (void)showAtPointArr:(NSArray *)pointArr inView:(UIView *)view withTextArr:(NSArray *)textArr;
- (void)showAtPointArr:(NSArray *)pointArr inView:(UIView *)view withTextArr:(NSArray *)textArr    orientations:(NSArray *)orientations;

- (void)layoutAtPointArr:(NSArray *)pointArr inView:(UIView *)view;
- (void)dismiss:(BOOL)animated;
@end