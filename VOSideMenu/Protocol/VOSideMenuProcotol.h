//
//  VOSideMenuProcotol.h
//  VOSideMenu
//
//  Created by Valo Lee on 14-8-23.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 此代理用于左中右页面需要SideMenuController完成的操作
@protocol VOSideMenuProcotol <NSObject>

- (void)centerPanGesterAction: (UIPanGestureRecognizer *)sender;

@optional
- (void)showLeftView;
- (void)showRightView;

@end
