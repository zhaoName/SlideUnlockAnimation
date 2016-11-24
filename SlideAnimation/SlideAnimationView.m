//
//  SlideAnimationView.m
//  SlideUnlockAnimation
//
//  Created by zhao on 2016/11/23.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "SlideAnimationView.h"

#define Slide_Width self.frame.size.width
#define Slide_Height self.frame.size.height

@interface SlideAnimationView ()

@property (nonatomic, strong) UILabel *hiddenLabel; /**< 启动动画后隐藏的label*/
@property (strong, nonatomic) UILabel *animationLabel; /**< 启动动画后显示的label*/
@property (nonatomic, strong) CAGradientLayer *gradientLayer; /**< 颜色渐变*/
@property (nonatomic, strong) CABasicAnimation *locationAnimation; /**< 颜色渐变动画*/
@property (nonatomic, strong) CABasicAnimation *alphaAnimation; /**< 闪烁动画*/

@end

@implementation SlideAnimationView

#pragma mark -- 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
         [self initDatas];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if([super initWithCoder:aDecoder])
    {
         [self initDatas];
    }
    return self;
}

- (instancetype)init
{
    if([super init])
    {
        [self initDatas];
    }
    return self;
}

- (void)initDatas
{
    self.duration = 2.5;
    self.slideType = SlideAnimationViewTypeDefault;
    self.gradientColors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor redColor].CGColor, (id)[UIColor blackColor].CGColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self handleGradientColor];
}

- (void)handleGradientColor
{
    [self addSubview:self.hiddenLabel];
    // 创建gradientLayer
    //gradientLayer的大小和位置
    self.gradientLayer.bounds = CGRectMake(0, 0, Slide_Width, Slide_Height);
    self.gradientLayer.position = CGPointMake(Slide_Width/2, Slide_Height/2);
    
    
    
    if(self.slideType != SlideAnimationViewTypeTwinkle)
    {
        // 由它们两个决定动画的方向
        self.gradientLayer.startPoint = CGPointMake(0, 1); // 起始位置 默认是(0.5, 0)
        self.gradientLayer.endPoint = CGPointMake(1, 0);   // 结束位置 默认是(0.5, 1) 若用默认值则动画是从上水平向下
        
        // 动画效果的颜色
        // 这里要注意 因为layer上的颜色是CGColorRef类型，但是CGColorRef不是一个OC对象所以直接放在数组里有报错
        self.gradientLayer.colors = self.gradientColors;
        
        // locations的值是NSNumber类型，且取值在[0, 1]之间， 最重要的是他的长度要和上边colors的长度一样
        self.gradientLayer.locations = @[@(0.2), @(0.5), @(0.8)];
        
        // 创建动画
        self.locationAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
        // 这两句话表示第一个黑色从0跑到了0.75的位置，红色从0跑到了1的位置， 第二个黑色从0.25跑到了1的位置
        // 动画的起始位置
        self.locationAnimation.fromValue = @[@(0),@(0),@(0.25)];
        // 动画的结束位置
        self.locationAnimation.toValue = @[@(0.75),@(1),@(1)];
        
        // 一次动画的用时
        self.locationAnimation.duration = self.duration;
        // 动画重复的次数
        self.locationAnimation.repeatCount = HUGE;
        // autoreverses属性会自动将动画恢复(怎么跑过去怎么回来)
        self.locationAnimation.autoreverses = (self.slideType == SlideAnimationViewTypeReVerse) ? YES : NO;
    }
    else
    {
        self.gradientLayer.backgroundColor = [UIColor redColor].CGColor;
        
        self.alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        self.alphaAnimation.repeatCount = MAXFLOAT;
        self.alphaAnimation.duration = self.duration;
        
        self.alphaAnimation.fromValue = @0.0;
        self.alphaAnimation.toValue = @1.0;
        self.alphaAnimation.autoreverses = YES;
    }
}

#pragma mark -- 进入前台或活跃状态

// 当程序重新进入前台或活跃状态，动画仍然会执行
- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSlideAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSlideAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark -- 操作动画

// 开始动画
- (void)startSlideAnimation
{
    [self.gradientLayer removeAnimationForKey:@"locations"];
    // 开启动画 隐藏灭有动画的Label
    self.hiddenLabel.hidden = YES;
    // 添加动画效果
    [self.layer addSublayer:self.gradientLayer];
    // 将动画添加到Label的字上
    self.gradientLayer.mask = self.animationLabel.layer;
    if(self.slideType != SlideAnimationViewTypeTwinkle)
    {
        // 在gradientLayer上添加动画
        [self.gradientLayer addAnimation:self.locationAnimation forKey:@"locations"];
    }
    else
    {
        [self.gradientLayer addAnimation:self.alphaAnimation forKey:@"locations"];
    }
}

// 结束动画
- (void)stopSlideAnimation
{
    [self.gradientLayer removeAllAnimations];
    [self.gradientLayer removeFromSuperlayer];
    self.hiddenLabel.hidden = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- getter

- (CAGradientLayer *)gradientLayer
{
    if(!_gradientLayer)
    {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

- (UILabel *)animationLabel
{
    if(!_animationLabel)
    {
        _animationLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _animationLabel.text = self.labelText;
        _animationLabel.font = [UIFont systemFontOfSize:self.labelFont];
        _animationLabel.hidden = !self.hiddenLabel.hidden;
    }
    return _animationLabel;
}

- (UILabel *)hiddenLabel
{
    if(!_hiddenLabel)
    {
        _hiddenLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _hiddenLabel.text = self.labelText;
        _hiddenLabel.font = [UIFont systemFontOfSize:self.labelFont];
        _hiddenLabel.hidden = NO;
    }
    return _hiddenLabel;
}

@end
