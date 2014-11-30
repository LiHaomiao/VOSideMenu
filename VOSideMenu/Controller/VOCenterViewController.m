//
//  VOCenterViewController.m
//  VOSideMenu
//
//  Created by Valo Lee on 14-8-23.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOCenterViewController.h"
#import "VOAppDelegate.h"

@interface VOCenterViewController ()

@property (nonatomic, weak) VOAppDelegate *app;

@end

@implementation VOCenterViewController

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
    // Do any additional setup after loading the view.
	self.app = [UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击事件
- (IBAction)showLeftView:(UIButton *)sender {
	[self.app.sideMenuController showLeftView];
}

- (IBAction)showRightView:(UIButton *)sender {
	[self.app.sideMenuController showRightView];
}

#pragma mark - 手势事件
// 此处加手势效果,避免在此页面上的textView滚动时,会拉出左右页面.
- (IBAction)panGestureAction:(UIPanGestureRecognizer *)sender {
	[self.app.sideMenuController centerPanGesterAction: sender];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
