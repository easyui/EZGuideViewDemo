//
//  EZUv2ViewController.m
//  EZGuideViewDemo
//
//  Created by NeuLion SH on 13-12-23.
//  Copyright (c) 2013年 cactus. All rights reserved.
//
#ifndef kCFCoreFoundationVersionNumber_iOS_6_1
#define kCFCoreFoundationVersionNumber_iOS_6_1 793.00
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS7_OR_GREATER(...)
#endif


#import "EZUv2ViewController.h"

@interface EZUv2ViewController ()

@end

@implementation EZUv2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       IF_IOS7_OR_GREATER(self.edgesForExtendedLayout = UIRectEdgeNone;);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    EZGuideView *pv = [[EZGuideView alloc] initWithFrame:CGRectZero];
    pv.horizontalMargin = 0.f;
    pv.arrowHeight = 0.f;
    pv.subTextColor = [UIColor whiteColor];
    pv.contentViewBackgroundColor = [UIColor orangeColor];
    pv.borderLineWidth = 0.f;
    pv.boxRadius = 0;
    pv.contentWidth = self.view.frame.size.width;
//    [pv showAtPoint:CGPointMake(self.view.center.x,0.f) inView:self.view withText:@"不积跬步 无以至千里 不积小流 无以成江海" orientation:EZGuideViewDown];
        [pv showAtPoint:CGPointMake(self.view.center.x,0.f) inView:self.view withText:@"不积跬步" orientation:EZGuideViewDown];
}
@end
