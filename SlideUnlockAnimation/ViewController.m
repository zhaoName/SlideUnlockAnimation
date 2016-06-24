//
//  ViewController.m
//  SlideUnlockAnimation
//
//  Created by zhao on 16/6/23.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "ViewController.h"

#define BackView_Width self.backgroundView.frame.size.width
#define BackView_Height self.backgroundView.frame.size.height

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *animationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhaoImageView;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、创建gradientLayer
    
    //gradientLayer的大小和位置
    self.gradientLayer.bounds = CGRectMake(0, 0, BackView_Width, BackView_Height);
    self.gradientLayer.position = CGPointMake(BackView_Width/2, BackView_Height/2);
    
    //由它们两个决定动画的方向
    self.gradientLayer.startPoint = CGPointMake(0, 1); //起始位置 默认是(0.5, 0)
    self.gradientLayer.endPoint = CGPointMake(1, 0);   //结束位置 默认是(0.5, 1) 若用默认值则动画是从上水平向下
    
    //动画效果的颜色
    //这里要注意 因为layer上的颜色是CGColorRef类型，但是CGColorRef不是一个OC对象所以直接放在数组里有报错
    self.gradientLayer.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor redColor].CGColor, (id)[UIColor blackColor].CGColor];
    
    //locations的值是NSNumber类型，且取值在[0, 1]之间， 最重要的是他的长度要和上边colors的长度一样
    self.gradientLayer.locations = @[@(0.2), @(0.5), @(0.8)];
     //2、添加动画效果
    [self.backgroundView.layer addSublayer:self.gradientLayer];
    
   
    CABasicAnimation *locationAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
    
    //这两句话表示第一个黑色从0跑到了0.75的位置，红色从0跑到了1的位置， 第二个黑色从0.25跑到了1的位置
    //动画的起始位置
    locationAnimation.fromValue = @[@(0),@(0),@(0.25)];
    //动画的结束位置
    locationAnimation.toValue = @[@(0.75),@(1),@(1)];
    
    //一次动画的用时
    locationAnimation.duration = 2.5;
    //动画重复的次数
    locationAnimation.repeatCount = HUGE;
    
    //在gradientLayer上添加动画
    [self.gradientLayer addAnimation:locationAnimation forKey:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //3、将动画添加到Label的字上
    self.animationLabel.text = @"SlideUnlockAnimation";
    //不能写在viewDidLoad
    self.gradientLayer.mask = self.animationLabel.layer;
    
    //self.gradientLayer.mask = self.zhaoImageView.layer;
}

- (CAGradientLayer *)gradientLayer
{
    if(!_gradientLayer)
    {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

@end
