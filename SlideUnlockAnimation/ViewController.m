//
//  ViewController.m
//  SlideUnlockAnimation
//
//  Created by zhao on 16/6/23.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "ViewController.h"
#import "SlideAnimationView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet SlideAnimationView *backgroundView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundView.duration = 2.0;
    self.backgroundView.slideType = SlideAnimationViewTypeDefault;
    self.backgroundView.labelText = @"SlideUnlockAnimation";
    self.backgroundView.labelFont = 22;
}

- (IBAction)startAnimation:(id)sender
{
    [self.backgroundView startSlideAnimation];
    [self.backgroundView addNotificationObserver];
}

- (IBAction)stopAnimation:(UIButton *)sender
{
    [self.backgroundView stopSlideAnimation];
}

@end
