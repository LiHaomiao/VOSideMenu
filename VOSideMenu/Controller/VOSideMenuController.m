//
//  VOSideMenuController.m
//  VOSideMenu
//
//  Created by Valo Lee on 14-8-23.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOSideMenuController.h"
#import "VOCenterViewController.h"
#import "UIImage+ImageEffects.h"

#define kMaxBlurAlpha 1.0

typedef NS_ENUM(NSUInteger, VOSideMenuState) {
    VOSideMenuStateCenterShow,
    VOSideMenuStateLeftMoving,
    VOSideMenuStateLeftShow,
	VOSideMenuStateRightMoving,
	VOSideMenuStateRightShow,
};

@interface VOSideMenuController () <VOSideMenuProcotol>

// 中间内容页
@property (weak, nonatomic) IBOutlet UIView *centerContainer;
// 特效图片
@property (weak, nonatomic) IBOutlet UIImageView *blurView;
// 左侧页面
@property (weak, nonatomic) IBOutlet UIView *leftContainer;
// 右侧页面
@property (weak, nonatomic) IBOutlet UIView *rightContainer;

// 页面状态
@property (nonatomic, assign) VOSideMenuState sideMenuState;

// 特效相关
@property (nonatomic, strong) UIImage *blurImage;
@property (nonatomic, assign) BOOL showBlurView;

@end

@implementation VOSideMenuController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 隐藏/显示左右View
- (void)moveView: (__weak UIView *)view toShow: (BOOL)show{
	CGRect frame = view.frame;
	CGFloat endx, lastRadius;
	
	// 计算坐标
	if (view == self.leftContainer) {
		endx = show ? 0 : -frame.size.width;
	}
	else{
		endx = show ? self.view.bounds.size.width - frame.size.width : frame.size.width;
		
	}
	// 计算特效参数
	lastRadius = show? kMaxBlurAlpha: 0;
	// 计算动画时间
	CGFloat duration = ABS(endx - frame.origin.x) / frame.size.width;

	// 动画
	frame.origin.x = endx;
	[UIView animateWithDuration : duration
					  animations:^{
						  view.frame = frame;
						  self.blurView.alpha = lastRadius;
					  }];
}

#pragma mark 状态设置及相应操作
- (void)setSideMenuState:(VOSideMenuState)sideMenuState{
	_sideMenuState = sideMenuState;
	switch (sideMenuState) {
		case VOSideMenuStateCenterShow:
			// 显示中间页面时关闭左右两侧页面
			[self moveView:self.leftContainer toShow:NO];
			[self moveView:self.rightContainer toShow:NO];
			// 关闭页面结束后隐藏特效图片
			self.showBlurView = NO;
			break;
			
		case VOSideMenuStateLeftShow:
			// 显示特效图片后, 再移动左侧页面
			self.showBlurView = YES;
			[self moveView:self.leftContainer toShow:YES];
			break;
			
		case VOSideMenuStateRightShow:
			// 显示特效图片后, 再移动右侧页面
			self.showBlurView = YES;
			[self moveView:self.rightContainer toShow:YES];
			break;
			
		case VOSideMenuStateLeftMoving:
			// 开始移动则显示特效图片
			self.showBlurView = YES;
			break;
			
		case VOSideMenuStateRightMoving:
			// 开始移动则显示特效图片
			self.showBlurView = YES;
			break;			
		
		default:
			break;
	}
}

#pragma mark - 特效
#pragma mark 特效图片显示/隐藏
- (void)setShowBlurView:(BOOL)showBlurView{
	_showBlurView = showBlurView;
	if (showBlurView) {
		[self updateBlurView];
	}
	self.blurView.hidden = !showBlurView;
}

#pragma mark 屏幕截图
- (void)updateBlurView {
    UIGraphicsBeginImageContext(self.centerContainer.bounds.size);
	[self.centerContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	self.blurView.image = [image applyBlurWithRadius: 20
										   tintColor: nil
							   saturationDeltaFactor: 1.5
										   maskImage: nil];
}

#pragma mark - 手势操作
#pragma mark - 点击内容页关闭左右页面
- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender {
	self.sideMenuState = VOSideMenuStateCenterShow;
}

#pragma mark - 滑动拉出左/右页面
- (IBAction)panGestureAction:(UIPanGestureRecognizer *)sender {
	// 手势当前坐标
	CGPoint curPoint = [sender locationInView:self.view];
	// 手势起始坐标
	static CGPoint startPoint;
	// 页面起始x坐标
	static CGFloat startx;
	CGRect frame;
	switch (sender.state) {
		case UIGestureRecognizerStateBegan:
			startPoint = curPoint;
			break;
			
		case UIGestureRecognizerStateChanged:
			switch (self.sideMenuState) {
				case VOSideMenuStateCenterShow:
					// 未显示左右页面时,根据坐标变化,改变页面状态
					if (curPoint.x > startPoint.x) {
						// 移动左侧页面
						self.sideMenuState = VOSideMenuStateLeftMoving;
						startx = self.leftContainer.frame.origin.x;
					}
					else if(curPoint.x < startPoint.x){
						// 移动右边页面
						self.sideMenuState = VOSideMenuStateRightMoving;
						startx = self.rightContainer.frame.origin.x;
					}
					break;
					
				case VOSideMenuStateLeftShow:
					// 左侧页面处于显示状态时,移动左侧页面
					self.sideMenuState = VOSideMenuStateLeftMoving;
					startx = self.leftContainer.frame.origin.x;
					break;
					
				case VOSideMenuStateRightShow:
					// 右边边页面处于显示状态时,移动右边页面
					self.sideMenuState = VOSideMenuStateRightMoving;
					startx = self.rightContainer.frame.origin.x;
					break;
					
					// 移动左侧页面的方法
				case VOSideMenuStateLeftMoving:
					frame = self.leftContainer.frame;
					// 计算坐标
					frame.origin.x = (curPoint.x - startPoint.x) + startx;
					if (frame.origin.x >= 0) {
						frame.origin.x = 0;
					}
					else if(frame.origin.x <= -frame.size.width){
						frame.origin.x = -frame.size.width;
					}
					// 设置左侧页面frame
					self.leftContainer.frame = frame;
					// 移动过程中改变特效图片效果
					self.blurView.alpha = (frame.size.width + frame.origin.x) / frame.size.width * kMaxBlurAlpha;
					break;
				
					//移动右侧页面的方法
				case VOSideMenuStateRightMoving:
					frame = self.rightContainer.frame;
					//计算坐标
					frame.origin.x = (curPoint.x - startPoint.x) + startx;
					if (frame.origin.x <= 0) {
						frame.origin.x = 0;
					}
					else if(frame.origin.x >= frame.size.width){
						frame.origin.x = frame.size.width;
					}
					// 设置右侧页面frame
					self.rightContainer.frame = frame;
					// 移动过程中改变特效图片效果
					self.blurView.alpha = (frame.size.width - frame.origin.x) / frame.size.width * kMaxBlurAlpha;
					break;
					
				default:
					break;
			}
			break;
			
			// 退出手势操作,根据页面状态及坐标设置结束状态
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			switch (self.sideMenuState) {
					// 移动的是左侧页面
				case VOSideMenuStateLeftMoving:
				{
					frame = self.leftContainer.frame;
					// 如果左侧页面的x坐标超过其宽度的一半,则显示,反之则隐藏
					if (CGRectGetMaxX(frame) >= frame.size.width / 2) {
						self.sideMenuState = VOSideMenuStateLeftShow;
					}
					else{
						self.sideMenuState = VOSideMenuStateCenterShow;
					}
				}
					break;
					
				case VOSideMenuStateRightMoving:
				{
					frame = self.rightContainer.frame;
					// 如果右侧页面的x坐标超过其宽度的一半,则显示,反之则隐藏
					if (self.view.bounds.size.width - CGRectGetMinX(frame) >= frame.size.width / 2) {
						self.sideMenuState = VOSideMenuStateRightShow;
					}
					else{
						frame.origin.x = frame.size.width;
						self.sideMenuState = VOSideMenuStateCenterShow;
					}
				}
					break;
					
				default:
					break;
			}
			break;
			
		default:
			break;
	}
}

#pragma mark - VOSideMenuProcotol代理
#pragma mark 中间内容页手势动作
// 此处用代理实现. 如果是直接在centerContainer上加上Pan手势,则在中间内容也上的任何pan手势都可以触发左右页面出现的效果.比如中间页面的textView上下滚动时,如果手势的x左边有变化也会拉出左/右页面.
// 左/中/右3个页面中的任何手势,都可以参照此例处理.
- (void)centerPanGesterAction:(UIPanGestureRecognizer *)sender{
	[self panGestureAction:sender];
}

#pragma mark 显示左侧页面
-(void)showLeftView{
	if (self.sideMenuState == VOSideMenuStateCenterShow) {
		self.sideMenuState = VOSideMenuStateLeftShow;
	}
}

#pragma mark 显示右侧页面
- (void)showRightView{
	if (self.sideMenuState == VOSideMenuStateCenterShow) {
		self.sideMenuState = VOSideMenuStateRightShow;
	}
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// storyBoard中设置了连接中间页面segue的 identifier, 这里用来定位中间页面,并设置代理.
	if ([segue.identifier isEqualToString: @"toCenterView"]) {
		VOCenterViewController *centerVC = segue.destinationViewController;
		centerVC.delegate = self;
	}
}

@end
