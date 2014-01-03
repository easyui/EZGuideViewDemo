//
//  EZGuideView.m
//  EZGuideViewDemo
//
//  Created by EZ on 13-11-26.
//  Copyright (c) 2013年 cactus. All rights reserved.
//

#import "EZGuideView.h"
#import <QuartzCore/QuartzCore.h>
#ifdef __IPHONE_6_0
  #define UITextAlignmentCenter             NSTextAlignmentCenter
  #define UITextAlignmentLeft               NSTextAlignmentLeft
  #define UITextAlignmentRight              NSTextAlignmentRight
  #define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
  #define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
  #define UILineBreakModeWordWrap           NSLineBreakByWordWrapping
#endif

#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)

#pragma mark - Implementation
@interface EZGuideView ()
@property (nonatomic, strong) UIView            *parentView;
@property (nonatomic, strong) UIView            *topView;
@property (nonatomic, strong) NSMutableArray    *arrowPoints;
@property (nonatomic, strong) NSMutableArray    *aboves;
@property (nonatomic, strong) NSMutableArray    *boxFrames;
@property (nonatomic, strong) NSMutableArray    *contentViews;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation EZGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor clearColor];

        // 内容
        self.subFont = [UIFont fontWithName:@"HelveticaNeue" size:16.f];
        self.subTextColor = [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1];
        self.subTextHighlightColor = [UIColor colorWithRed:0.098 green:0.102 blue:0.106 alpha:1.000];
        self.subTextAlignment = UITextAlignmentCenter;
        // contentView
        self.contentViewBackgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.95f];
        self.contentHeight = 0.f;
        self.contentWidth = 0.f;
        // popview
        self.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        self.shadowOffset = CGSizeMake(0, 1);
        self.shadowBlurRadius = 3.f;
        self.boxPadding = 10.f;
        self.boxRadius = 4.f;
        self.controlPointOffset = 1.8f;
        self.horizontalMargin = 6.f;
        self.topMargin = 50.f;
        // 箭头
        self.arrowHeight = 12.f;
        self.arrowHorizontalPadding = 5.f;
        self.arrowCurvature = 6.f;
        // 边框
        self.showBorder = YES;
        self.borderColor = [UIColor blackColor];
        self.borderLineWidth = 1.f;
    }

    return self;
}

#pragma mark - View Lifecycle

- (void)drawRect:(CGRect)rect
{
    int length = self.arrowPoints.count;

    for (int i = 0; i < length; i++) {
        CGPoint arrowPoint = [(NSValue *)self.arrowPoints[i] CGPointValue];
        BOOL    above = [(NSNumber *)self.aboves[i] boolValue];
        CGRect  boxFrame = [(NSValue *)self.boxFrames[i] CGRectValue];

        CGRect frame = boxFrame;

        float   xMin = CGRectGetMinX(frame);
        float   yMin = CGRectGetMinY(frame);

        float   xMax = CGRectGetMaxX(frame);
        float   yMax = CGRectGetMaxY(frame);

        float radius = self.boxRadius;

        float cpOffset = self.controlPointOffset;
        // 画完一圈边框 整个popview的背景
        UIBezierPath *popoverPath = [UIBezierPath bezierPath];

        [popoverPath moveToPoint:CGPointMake(xMin, (yMin + radius))];                                                                                                                               // LT1
        [popoverPath addCurveToPoint:CGPointMake((xMin + radius), yMin) controlPoint1:CGPointMake(xMin, (yMin + radius) - cpOffset) controlPoint2:CGPointMake((xMin + radius) - cpOffset, yMin)];   // LT2

        if (!above) {
            [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - self.arrowHeight, yMin)];                                                                                                                    // left side
            [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x - self.arrowHeight + self.arrowCurvature, yMin) controlPoint2:arrowPoint];
            [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + self.arrowHeight, yMin) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x + self.arrowHeight - self.arrowCurvature, yMin)];
        }

        [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];
        [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];
        [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];
        [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];

        if (above) {
            [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + self.arrowHeight, yMax)]; [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x + self.arrowHeight - self.arrowCurvature, yMax) controlPoint2:arrowPoint];
            [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x - self.arrowHeight, yMax) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x - self.arrowHeight + self.arrowCurvature, yMax)];
        }

        [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];
        [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];
        [popoverPath closePath];

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef    context = UIGraphicsGetCurrentContext();

        UIColor *shadow = self.shadowColor;
        CGSize  shadowOffset = self.shadowOffset;
        CGFloat shadowBlurRadius = self.shadowBlurRadius;

        NSArray *gradientColors = [NSArray arrayWithObjects:
            (id)self.contentViewBackgroundColor.CGColor,
            (id)self.contentViewBackgroundColor.CGColor, nil];
        CGFloat         gradientLocations[] = {0, 1};
        CGGradientRef   gradient = CGGradientCreateWithColors(colorSpace, ((__bridge CFArrayRef)gradientColors), gradientLocations);

        float   bottomOffset = (above ? self.arrowHeight : 0.f);
        float   topOffset = (!above ? self.arrowHeight : 0.f);

        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        CGContextBeginTransparencyLayer(context, NULL);
        [popoverPath addClip]; //
        CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0);

        if (self.contentViewBackgroundImage) {
            if (above) {
                CGContextDrawImage(context, CGRectMake(xMin, yMin, frame.size.width, frame.size.height + bottomOffset), [self.contentViewBackgroundImage CGImage]);
            } else {
                CGContextDrawImage(context, CGRectMake(xMin, yMin - topOffset, frame.size.width, frame.size.height + topOffset), [self.contentViewBackgroundImage CGImage]);
            }
        }

        // CGRectMake(frame.origin.x -30, frame.origin.y - 30, frame.size.width + 60,  frame.size.height + 60)
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);

        //
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);

        // 画边框
        if (self.showBorder) {
            [self.borderColor setStroke];
            popoverPath.lineWidth = self.borderLineWidth;
            [popoverPath stroke];
        }
    }
}

- (void)dealloc
{
    self.delegate = nil;
}

#pragma mark - public
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)textArr
{
    [self showAtPointArr:@[[NSValue valueWithCGPoint:point]] inView:view withTextArr:@[textArr] orientations:nil];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)textArr orientation:(EZGuideViewOrientation)orientation
{
    [self showAtPointArr:@[[NSValue valueWithCGPoint:point]] inView:view withTextArr:@[textArr] orientations:@[[NSNumber numberWithInt:orientation]]];
}

- (void)showAtPointArr:(NSArray *)pointArr inView:(UIView *)view withTextArr:(NSArray *)textArr
{
    [self showAtPointArr:pointArr inView:view withTextArr:textArr orientations:nil];
}

- (void)showAtPointArr:(NSArray *)pointArr inView:(UIView *)view withTextArr:(NSArray *)textArr orientations:(NSArray *)orientations
{
    if (self.durationTime > 0.f) {
      self.timer = [NSTimer scheduledTimerWithTimeInterval:self.durationTime target:self selector:@selector(tapped:) userInfo:nil repeats:NO];
    }
    if (pointArr.count != textArr.count) {
        return;
    }

    if (!orientations) {
        int length = pointArr.count;
        self.orientations = [[NSMutableArray alloc] initWithCapacity:length];

        for (int i = 0; i < length; i++) {
            [self.orientations addObject:[NSNumber numberWithInt:EZGuideViewNone]];
        }
    } else {
        self.orientations = [[NSMutableArray alloc] initWithArray:orientations];
    }

    UIFont  *font = self.subFont;
    CGSize  screenSize = [self screenSize];

    //    NSLog(@"%f",(screenSize.height -4.f* point.y));
    self.contentViews = [[NSMutableArray alloc] initWithCapacity:pointArr.count];

    for (NSString *text in textArr) {
        CGSize size = CGSizeMake(screenSize.width - self.horizontalMargin * 4.f, 1000.f);
        if(IOS7_OR_LATER){
            CGRect textRect = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
            self.contentWidth = self.contentWidth!=0.f?self.contentWidth:textRect.size.width;
            self.contentHeight = self.contentHeight!=0.f?self.contentHeight:textRect.size.height;
        }else{
            CGSize  textSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            self.contentWidth = self.contentWidth!=0.f?self.contentWidth:textSize.width;
            self.contentHeight = self.contentHeight!=0.f?self.contentHeight:textSize.height;
        }
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, self.contentHeight)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.userInteractionEnabled = NO;
        [textLabel setNumberOfLines:0]; // This is so the label word wraps instead of cutting off the text
        textLabel.font = font;
        textLabel.textAlignment = self.subTextAlignment;
        textLabel.textColor = self.subTextColor;
        textLabel.text = text;
        [self.contentViews addObject:textLabel];
    }

    self.topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [self configPointArr:pointArr inView:view];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.cancelsTouchesInView = NO; // 继续传递事件
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;

    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);

    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1.08f, 1.08f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)layoutAtPointArr:(NSArray *)pointArr inView:(UIView *)view
{
    [self configPointArr:pointArr inView:view];

    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
    } completion:nil];
}

#pragma mark - User Interaction

- (void)tapped:(UITapGestureRecognizer *)tap
{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (!animated) {
        [self dismissComplete];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0.1f;
            self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            [self dismissComplete];
        }];
    }
}

- (void)dismissComplete
{
    [self removeFromSuperview];

    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverViewDidDismiss:)]) {
        [self.delegate popoverViewDidDismiss:self];
    }
}

#pragma mark - private
- (CGSize)screenSize
{
    UIInterfaceOrientation  orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize                  size = [UIScreen mainScreen].bounds.size;
    UIApplication           *application = [UIApplication sharedApplication];

    if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(size.height, size.width);
    }

    if (application.statusBarHidden == NO) {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }

    return size;
}

- (void)setupLayout:(CGPoint)point ContentView:(UIView *)contentView orientation:(EZGuideViewOrientation)orientation
{
    NSLog(@"____%@", NSStringFromCGRect(self.topView.frame));
    NSLog(@"____%@", NSStringFromCGRect(self.parentView.frame));
    CGPoint topPoint = [self.topView convertPoint:point fromView:self.parentView];
    //        CGPoint topPoint = point;
    CGPoint arrowPoint = topPoint;
    //    NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);

    CGRect topViewBounds = self.topView.bounds;
    // NSLog(@"topViewBounds %@", NSStringFromCGRect(topViewBounds));
    float   contentHeight = contentView.frame.size.height;
    float   contentWidth = contentView.frame.size.width;
    //    float padding = kBoxPadding;
    float   boxHeight = contentHeight + 2.f * self.boxPadding;
    float   boxWidth = contentWidth + 2.f * self.boxPadding;

    float xOrigin = 0.f;

    // Make sure the arrow point is within the drawable bounds for the popover.
    if (arrowPoint.x + self.arrowHeight > topViewBounds.size.width - self.horizontalMargin - self.boxRadius - self.arrowHorizontalPadding) { // 防止右边出界
        arrowPoint.x = topViewBounds.size.width - self.horizontalMargin - self.boxRadius - self.arrowHorizontalPadding - self.arrowHeight;
        NSLog(@"Correcting Arrow Point because it's too far to the right");
    } else if (arrowPoint.x - self.arrowHeight < self.horizontalMargin + self.boxRadius + self.arrowHorizontalPadding) { // 防止左边出界
        arrowPoint.x = self.horizontalMargin + self.arrowHeight + self.boxRadius + self.arrowHorizontalPadding;
        NSLog(@"Correcting Arrow Point because it's too far to the left");
    }

    NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);

    xOrigin = floorf(arrowPoint.x - boxWidth * 0.5f);

    // 箭头与左右要保持horizontalMargin距离
    if (xOrigin < CGRectGetMinX(topViewBounds) + self.horizontalMargin) {
        xOrigin = CGRectGetMinX(topViewBounds) + self.horizontalMargin;
    } else if (xOrigin + boxWidth > CGRectGetMaxX(topViewBounds) - self.horizontalMargin) {
        xOrigin = CGRectGetMaxX(topViewBounds) - self.horizontalMargin - boxWidth;
    }

    BOOL above = YES;
    //    NSLog(@"%f", CGRectGetMinY(topViewBounds));

    CGRect boxFrame;

    if (orientation != EZGuideViewNone) {
        if (orientation == EZGuideViewDown) {
            above = NO;
            boxFrame = CGRectMake(xOrigin, arrowPoint.y + self.arrowHeight, boxWidth, boxHeight);
        } else if (orientation == EZGuideViewAbove) {
            above = YES;
            boxFrame = CGRectMake(xOrigin, arrowPoint.y - self.arrowHeight - boxHeight, boxWidth, boxHeight);
        }
    } else {
        if (topPoint.y - contentHeight - self.arrowHeight - self.topMargin < CGRectGetMinY(topViewBounds)) {
            // 判断顶部越界
            above = NO;

            boxFrame = CGRectMake(xOrigin, arrowPoint.y + self.arrowHeight, boxWidth, boxHeight);
        } else {
            // Position above.
            above = YES;
            boxFrame = CGRectMake(xOrigin, arrowPoint.y - self.arrowHeight - boxHeight, boxWidth, boxHeight);
        }
    }

    NSLog(@"boxFrame:(%f,%f,%f,%f)", boxFrame.origin.x, boxFrame.origin.y, boxFrame.size.width, boxFrame.size.height);

    CGRect contentFrame = CGRectMake(boxFrame.origin.x + self.boxPadding, boxFrame.origin.y + self.boxPadding, contentWidth, contentHeight);
    contentView.frame = contentFrame;

    [self addSubview:contentView];
    //    [topView addSubview:self];
    //  self.layer.anchorPoint = CGPointMake(arrowPoint.x / topViewBounds.size.width, arrowPoint.y / topViewBounds.size.height);
    //    self.layer.anchorPoint = CGPointMake(0, 0);
    [self.arrowPoints addObject:[NSValue valueWithCGPoint:arrowPoint]];
    [self.aboves addObject:[NSNumber numberWithBool:above]];
    [self.boxFrames addObject:[NSValue valueWithCGRect:boxFrame]];
}

- (void)configPointArr:(NSArray *)pointArr inView:(UIView *)view
{
    self.parentView = view;
    //    NSLog(@"%@", NSStringFromCGRect(self.frame));
    self.frame = self.topView.bounds;
    //    NSLog(@"%@", NSStringFromCGRect(self.frame));
    self.arrowPoints = [[NSMutableArray alloc] initWithCapacity:pointArr.count];
    self.aboves = [[NSMutableArray alloc] initWithCapacity:pointArr.count];
    self.boxFrames = [[NSMutableArray alloc] initWithCapacity:pointArr.count];
    int length = pointArr.count;

    for (int i = 0; i < length; i++) {
        [self setupLayout:[(NSValue *)pointArr[i] CGPointValue] ContentView:(UIView *)self.contentViews[i] orientation:[(NSNumber *)self.orientations[i] intValue]];
    }

    [self setNeedsDisplay];
    [self.topView addSubview:self];
}

@end