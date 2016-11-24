//
//  SlideAnimationView.h
//  SlideUnlockAnimation
//
//  Created by zhao on 2016/11/23.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SlideAnimationViewType)
{
    SlideAnimationViewTypeDefault = 0, /**< 默认，单次*/
    SlideAnimationViewTypeReVerse, /**< 来回*/
    SlideAnimationViewTypeTwinkle, /**< 闪烁*/
};

@interface SlideAnimationView : UIView

@property (nonatomic, strong) NSString *labelText; /**< 动画文字*/
@property (nonatomic, assign) CGFloat labelFont; /**< 字体大小*/

@property (nonatomic, assign) CGFloat duration; /**< 动画持续时间 秒*/
@property (nonatomic, assign) SlideAnimationViewType slideType; /**< 动画类型*/
@property (nonatomic, strong) NSArray *gradientColors; /**< 渐变颜色*/

/**
 *  开始动画 此方法不能放在VC的viewDidLoad里调用
 */
- (void)startSlideAnimation;

/**
 *  结束动画
 */
- (void)stopSlideAnimation;

/**
 *  添加通知 当程序重新进入前台或活跃状态，动画仍然会执行
 */
- (void)addNotificationObserver;

@end
