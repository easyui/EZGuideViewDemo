//
//  EZGameViewController.h
//  EZGuideViewDemo
//
//  Created by EZ on 13-11-26.
//  Copyright (c) 2013年 cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZGuideView.h"
@interface EZGameViewController : UIViewController<EZGuideViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *adButton;

@end
