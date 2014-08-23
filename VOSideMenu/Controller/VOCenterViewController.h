//
//  VOCenterViewController.h
//  VOSideMenu
//
//  Created by Valo Lee on 14-8-23.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOSideMenuProcotol.h"

@interface VOCenterViewController : UIViewController

@property (nonatomic, weak) id<VOSideMenuProcotol> delegate;

@end
