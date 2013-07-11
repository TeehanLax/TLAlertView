//
//  TLAlertView.m
//  TLAlertView
//
//  Created by Ash Furrow on 2013-07-11.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import "TLAlertView.h"

static const CGFloat animationDuration = 0.4f;
static const CGFloat alertViewWidth = 270.0f;
static const CGFloat buttonHeight = 44.0f;

@interface TLAlertView ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *buttonTitle;

@property (nonatomic, copy) TLAlertViewHandler handler;
@property (nonatomic, strong) TLAlertView *retainedSelf;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation TLAlertView

#pragma mark - Initializers

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    return [self initWithTitle:title message:message buttonTitle:buttonTitle handler:nil];
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle handler:(TLAlertViewHandler)handler {
    if (!(self = [super init])) return nil;
    
    self.title = title;
    self.message = message;
    self.buttonTitle = buttonTitle;
    self.handler = handler;
    
    [self setup];
    
    return self;
}

#pragma mark - Private Methods

-(void)setup {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.frame = keyWindow.bounds;
    
    self.backgroundView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f]; // Determined empirically
    self.backgroundView.alpha = 0.0f;
    [self addSubview:self.backgroundView];
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 100)];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 11.0f;
    self.alertView.layer.masksToBounds = YES;
    self.alertView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [self addSubview:self.alertView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, alertViewWidth, 44.0f)];
    titleLabel.text = self.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:titleLabel];
    
    UIFont *messageFont = [UIFont systemFontOfSize:17];
    CGRect boundingMessageRect = [self.message boundingRectWithSize:CGSizeMake(alertViewWidth, 999) options:0 attributes:@{NSFontAttributeName: messageFont} context:nil];
    CGFloat messageHeight = MAX(CGRectGetHeight(boundingMessageRect), 44.0f);
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, alertViewWidth, messageHeight)];
    messageLabel.text = self.message;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.font = messageFont;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:messageLabel];
    
    self.alertView.bounds = CGRectMake(0, 0, alertViewWidth, messageHeight + 44.0f + 45.0f);
    self.alertView.center = CGPointMake(CGRectGetMidX(keyWindow.bounds), -CGRectGetMaxY(self.alertView.bounds));
    
    CALayer *keylineLayer = [CALayer layer];
    keylineLayer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.29f] CGColor];
    keylineLayer.frame = CGRectMake(0.0f, CGRectGetHeight(self.alertView.frame) - 45.0f, alertViewWidth, 1.0f);
    [self.alertView.layer addSublayer:keylineLayer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:self.buttonTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
    button.frame = CGRectMake(0.0f, CGRectGetHeight(self.alertView.frame) - 44.0f, alertViewWidth, 44.0f);
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:button];
    
    // Adjust our keyWindow's tint adjustment mode to make everything behind the alert view dimmed
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [keyWindow tintColorDidChange];
    
    // Set up our UIKit Dynamics
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
}

#pragma mark - Public Methods

-(void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [keyWindow addSubview:self];
    
    // Animate in the background blind
    [UIView animateWithDuration:animationDuration animations:^{
        self.backgroundView.alpha = 1.0f;
    }];
    
    // Use UIKit Dynamics to make the alertView appear.
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.alertView snapToPoint:keyWindow.center];
    snapBehaviour.damping = 0.65f;
    [self.animator addBehavior:snapBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.alertView]];
    [self.animator addBehavior:itemBehaviour];
    
}

-(void)dismiss {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.alertView]];
    [gravityBehaviour setXComponent:0.0f yComponent:10.0f];
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.alertView]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.alertView];
    [self.animator addBehavior:itemBehaviour];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.backgroundView.alpha = 0.0f;
        keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        [keyWindow tintColorDidChange];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.retainedSelf = nil;
    }];
    
    if (self.handler) {
        self.handler(self);
    }
}

@end
