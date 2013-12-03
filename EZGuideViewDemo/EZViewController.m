//
//  EZViewController.m
//  EZGuideViewDemo
//
//  Created by NeuLion SH on 13-11-26.
//  Copyright (c) 2013年 cactus. All rights reserved.
//

#import "EZViewController.h"
#import "EZGameViewController.h"
#define NameArr @[@"简单",@"基本(支持旋转，消失后代理)",@"自定义方向",@"自定义边框和背景颜色(uv需求)",@"自定义背景图片",@"自定义时间自动消失"]
#define VCArr   @[@"EZBaseViewController",@"EZGameViewController",@"EZOrientationsViewController",@"EZUvViewController",@"EZImageViewController",@"EZTimerViewController"]
@interface EZViewController ()
@property(strong, nonatomic) NSArray    *nameArr;
@property(strong, nonatomic) NSArray    *vcArr;
@end

@implementation EZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"feature";
    self.nameArr = NameArr;
    self.vcArr = VCArr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.nameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
    }

    cell.textLabel.text = self.nameArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id vc = [[NSClassFromString(self.vcArr[indexPath.row]) alloc] initWithNibName:self.vcArr[indexPath.row] bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end