//
//  VOSideMenuController.h
//  VOSideMenu
//
//  Created by Valo Lee on 14-8-23.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOCenterViewController.h"
#import "VOLeftViewController.h"
#import "VORigthViewController.h"

typedef NS_ENUM(NSUInteger, VOSideMenuState) {
	VOSideMenuStateCenterShow,
	VOSideMenuStateLeftMoving,
	VOSideMenuStateLeftShow,
	VOSideMenuStateRightMoving,
	VOSideMenuStateRightShow,
};

#define kAnimationDuration			 0.2

@interface VOSideMenuController : UIViewController
@property (nonatomic, weak) VOCenterViewController *centerVC;
@property (nonatomic, weak) VOLeftViewController   *leftVC;
@property (nonatomic, weak) VORigthViewController  *rightVC;

// 页面状态
@property (nonatomic, assign) VOSideMenuState      sideMenuState;

// 侧滑操作
- (void)centerPanGesterAction: (UIPanGestureRecognizer *)sender;
- (void)showLeftView;
- (void)showRightView;
-(void)showCenterView;

@end
