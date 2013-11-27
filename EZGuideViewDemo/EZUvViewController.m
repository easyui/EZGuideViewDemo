//
//  EZUvViewController.m
//  EZGuideViewDemo
//
//  Created by NeuLion SH on 13-11-27.
//  Copyright (c) 2013年 cactus. All rights reserved.
//

#import "EZUvViewController.h"

@interface EZUvViewController ()

@end

@implementation EZUvViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    EZGuideView * pv = [[EZGuideView alloc] initWithFrame:CGRectZero];
    pv.subTextColor = [UIColor whiteColor];
    pv.contentViewBackgroundColor = [UIColor orangeColor];
    pv.borderLineWidth = 0.f;
    [pv showAtPointArr:@[[NSValue valueWithCGPoint:CGPointMake(self.menuButton.center.x, self.menuButton.center.y + self.menuButton.bounds.size.height / 2)], [NSValue valueWithCGPoint:CGPointMake(self.adButton.center.x, self.adButton.center.y - self.adButton.bounds.size.height / 2)]] inView:self.view withTextArr:@[@"这个是菜单按钮，来点我呀，点了就看到菜单了，有很多栏目可以看到的，点吧点吧点吧点吧点吧点吧点吧，，，，，", @"这个是btn的广告"]];
}

@end
