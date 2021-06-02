//
//  WQSuspendView.h
//  SuspendView
//
//  Created by 李文强 on 2019/6/6.
//  Copyright © 2019年 WenqiangLI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WQSuspendView : UIView

@property (nonatomic, copy) void (^tapBlock)(void);

/// 显示 + 回调
+ (void)showWithTapBlock:(void (^)(void))tapBlock;

/// 显示
+ (void)show;

/// 移除
+ (void)remove;

@end

NS_ASSUME_NONNULL_END
