//
//  EZBaseViewController.m
//  EZGuideViewDemo
//
//  Created by NeuLion SH on 13-11-27.
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

#import "EZBaseViewController.h"

@interface EZBaseViewController ()

@end

@implementation EZBaseViewController

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
      IF_IOS7_OR_GREATER(self.edgesForExtendedLayout = UIRectEdgeNone;);
    // Do any additional setup after loading the view from its nib.
//    EZGuideView *pv = [[EZGuideView alloc] initWithFrame:CGRectZero];
//    
//    [pv showAtPoint:CGPointMake(self.adButton.center.x, self.adButton.center.y - self.adButton.bounds.size.height / 2) inView:self.view withText:@"这个是btn的广告"];
//    NSLog(@"___%@",NSStringFromCGRect(self.view.frame));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    EZGuideView *pv = [[EZGuideView alloc] initWithFrame:CGRectZero];

    [pv showAtPoint:CGPointMake(self.adButton.center.x, self.adButton.center.y - self.adButton.bounds.size.height / 2) inView:self.view withText:@"这个是btn的广告"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
