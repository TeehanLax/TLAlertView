//
//  TLAlertView.m
//  TLAlertView
//
//  Created by Ash Furrow on 2013-07-11.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import "TLAlertView.h"

static const CGFloat animationDuration = 0.3;

@interface TLAlertView ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *buttonTitle;

@property (nonatomic, copy) TLAlertViewHandler handler;
@property (nonatomic, strong) TLAlertView *retainedSelf;

@property (nonatomic, strong) UIView *backgroundView;

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
}

#pragma mark - Public Methods

-(void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.backgroundView.alpha = 1.0f;
    }];
}

-(void)dismiss {
    NSLog(@"Dismiss");
    if (self.handler) {
        self.handler(self);
    }
    self.retainedSelf = nil;
}

@end
