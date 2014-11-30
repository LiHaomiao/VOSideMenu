//
//  VOAppDelegate.h
//  VOSideMenu
//
//  Created by Valo Lee on 14-8-23.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOSideMenuController.h"
@interface VOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) VOSideMenuController *sideMenuController;
@property (nonatomic, assign) VOSideMenuState sideMenuState;

@end
