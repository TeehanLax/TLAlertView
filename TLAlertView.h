//
//  TLAlertView.h
//  TLAlertView
//
//  Created by Ash Furrow on 2013-07-11.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

@import UIKit;
@import QuartzCore;

@class TLAlertView;

typedef void(^TLAlertViewHandler)(TLAlertView *alertView);

@interface TLAlertView : UIView

@property (nonatomic, readonly) NSString    *title;
@property (nonatomic, readonly) NSString    *message;
@property (nonatomic, readonly) NSString    *buttonTitle;
@property (nonatomic, readonly) UIView      *customAlertView;

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle outsideClose: (BOOL)tap2close;
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle handler:(TLAlertViewHandler)handler;
-(instancetype)initWithView:(UIView *)view;
-(instancetype)initWithView:(UIView *)view outsideClose: (BOOL)tap2close;
-(instancetype)initWithView:(UIView *)view handler:(TLAlertViewHandler)handler;

-(void)show;
-(void)dismiss;

@end
