//
//  WQSuspendView.m
//  SuspendView
//
//  Created by 李文强 on 2019/6/6.
//  Copyright © 2019年 WenqiangLI. All rights reserved.
//

#import "WQSuspendView.h"

#define kScreenWidth    CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight   CGRectGetHeight([UIScreen mainScreen].bounds)
#define IS_IPhoneXLater (kScreenWidth >=375.0f && kScreenHeight >=812.0f)

/*状态栏高度*/
#define kStatusBarH (IS_IPhoneXLater ? 44 : 20)

/*状态栏和导航栏总高度*/
#define kNavBarH (IS_IPhoneXLater ? 88 : 64)

/*TabBar高度*/
#define kTabBarH  (IS_IPhoneXLater ? 83 : 49)

/*底部安全区域远离高度*/
#define kSpaceBottomMarea_H (IS_IPhoneXLater ? 34 : 0)

/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kStatusBarH + kTabBarH)


#define WIDTH CGRectGetWidth(self.frame)
#define HEIGHT CGRectGetHeight(self.frame)
#define animateDuration 0.3       //位置改变动画时间

@implementation WQSuspendView

static WQSuspendView *_suspendView;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurationUI];
    }
    return self;
}

- (void)configurationUI{
    //自定义
    self.backgroundColor = [UIColor redColor];
    
    //图片~文字等...
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"拜访"];
    [self addSubview:imageView];
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    //滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(locationChange:)];
    [self addGestureRecognizer:pan];
}

+ (void)showWithTapBlock:(void (^)(void))tapBlock{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _suspendView = [[WQSuspendView alloc] initWithFrame:CGRectMake(kScreenWidth - 77, kScreenHeight - kTabBarH -100, 77, 77)];
        _suspendView.tapBlock = tapBlock;
    });
    if (!_suspendView.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:_suspendView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_suspendView];
    }
}

//显示
+ (void)show{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _suspendView = [[WQSuspendView alloc] initWithFrame:CGRectMake(kScreenWidth - 77, kScreenHeight - kTabBarH -100, 77, 77)];
    });
    if (!_suspendView.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:_suspendView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_suspendView];
    }
}

//移除
+ (void)remove{
    [_suspendView removeFromSuperview];
}

//点击事件
- (void)tap:(UITapGestureRecognizer *)tap{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

//滑动事件
- (void)locationChange:(UIPanGestureRecognizer *)pan{
    //获取当前位置
    CGPoint panPoint = [pan locationInView:[UIApplication sharedApplication].keyWindow];
    if (pan.state == UIGestureRecognizerStateBegan) {

    }else if(pan.state == UIGestureRecognizerStateChanged){
        self.center = CGPointMake(panPoint.x, panPoint.y);
        
        CGFloat btnMinX = CGRectGetMinX(self.frame);
        CGFloat btnMinY = CGRectGetMinY(self.frame);
        CGFloat btnMaxX = CGRectGetMaxX(self.frame);
        CGFloat btnMaxY = CGRectGetMaxY(self.frame);

        CGFloat centerX = panPoint.x;
        CGFloat centerY = panPoint.y;
        //x轴左右极限坐标
        if (btnMinX < 0){
            //左侧越界
            centerX = WIDTH/2;
        }else if (btnMaxX > kScreenWidth){
            //右侧越界
            centerX = kScreenWidth - WIDTH/2;
        }

        //y轴上下极限坐标
        if (btnMinY < kNavBarH){
            //顶部越界
            centerY = kNavBarH + HEIGHT/2;
        }else if (btnMaxY > kScreenHeight - kTabBarH){
            //底部越界
            centerY = kScreenHeight - kTabBarH - HEIGHT/2;
        }
        self.center = CGPointMake(centerX, centerY);
    }else if (pan.state == UIGestureRecognizerStateEnded){
        if (panPoint.x <= kScreenWidth/2) {//靠左
            if (panPoint.y <= 40 + HEIGHT/2 && panPoint.x >= 20 + WIDTH/2) {//左上
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, HEIGHT/2);
                }];
            }else if (panPoint.y >= kScreenHeight - HEIGHT/2 - 40 && panPoint.x >= 20 +WIDTH/2){//左下
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2);
                }];
            }else if (panPoint.x < WIDTH/2 + 20 && panPoint.y > kScreenHeight - HEIGHT/2){//左下
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(WIDTH/2, kScreenHeight-HEIGHT/2);
                }];
            }else{
                CGFloat pointy = panPoint.y < HEIGHT/2 ? HEIGHT/2 :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(WIDTH/2, pointy);
                }];
            }
        }else if (panPoint.x > kScreenWidth/2){//靠右
            if (panPoint.y <= 40 + HEIGHT/2 && panPoint.x < kScreenWidth - WIDTH/2 - 20) {//右上
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, HEIGHT/2);
                }];
            }else if (panPoint.y >= kScreenHeight - 40 - HEIGHT/2 && panPoint.x < kScreenWidth - WIDTH/2 - 20){//右下
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2);
                }];
            }else if (panPoint.x > kScreenWidth - WIDTH/2 - 20 && panPoint.y < HEIGHT/2){//右上
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(kScreenWidth-WIDTH/2, HEIGHT/2);
                }];
            }else{
                CGFloat pointy = panPoint.y > kScreenHeight-HEIGHT/2 ? kScreenHeight-HEIGHT/2 :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(kScreenWidth-WIDTH/2, pointy);
                }];
            }
        }
    }
}

//改变位置
- (void)locationChange1:(UIPanGestureRecognizer *)panGesture{
    CGPoint panPoint = [panGesture locationInView:[UIApplication sharedApplication].keyWindow];
    if (panGesture.state == UIGestureRecognizerStateBegan) {

    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        if (panPoint.x <= kScreenWidth/2) {//靠左
//            if (panPoint.y <= 40 + HEIGHT/2 && panPoint.x >= 20 + WIDTH/2) {//左上
//                [UIView animateWithDuration:animateDuration animations:^{
//                    self.center = CGPointMake(panPoint.x, HEIGHT/2);
//                }];
//            }else if (panPoint.y >= kScreenHeight - HEIGHT/2 - 40 && panPoint.x >= 20 +WIDTH/2){//左下
//                [UIView animateWithDuration:animateDuration animations:^{
//                    self.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2);
//                }];
//            }else if (panPoint.x < WIDTH/2 + 20 && panPoint.y > kScreenHeight - HEIGHT/2){//左下
//                [UIView animateWithDuration:animateDuration animations:^{
//                    self.center = CGPointMake(WIDTH/2, kScreenHeight-HEIGHT/2);
//                }];
//            }else{
                CGFloat pointy = panPoint.y < HEIGHT/2 ? HEIGHT/2 :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(WIDTH/2, pointy);
                }];
//            }
        }else if (panPoint.x > kScreenWidth/2){//靠右
//            if (panPoint.y <= 40 + HEIGHT/2 && panPoint.x < kScreenWidth - WIDTH/2 - 20) {//右上
//                [UIView animateWithDuration:animateDuration animations:^{
//                    self.center = CGPointMake(panPoint.x, HEIGHT/2);
//                }];
//            }else if (panPoint.y >= kScreenHeight - 40 - HEIGHT/2 && panPoint.x < kScreenWidth - WIDTH/2 - 20){//右下
//                [UIView animateWithDuration:animateDuration animations:^{
//                    self.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2);
//                }];
//            }else if (panPoint.x > kScreenWidth - WIDTH/2 - 20 && panPoint.y < HEIGHT/2){//右上
//                [UIView animateWithDuration:animateDuration animations:^{
//                    self.center = CGPointMake(kScreenWidth-WIDTH/2, HEIGHT/2);
//                }];
//            }else{
                CGFloat pointy = panPoint.y > kScreenHeight-HEIGHT/2 ? kScreenHeight-HEIGHT/2 :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(kScreenWidth-WIDTH/2, pointy);
                }];
//            }
        }
    }
}

@end
