//
//  TLAlertView.h
//  TLAlertView
//
//  Created by Ash Furrow on 2013-07-11.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLAlertView;

typedef void(^TLAlertViewHandler)(TLAlertView *alertView);

@interface TLAlertView : UIView

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSString *buttonTitle;

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle handler:(TLAlertViewHandler)handler;

-(void)show;
-(void)dismiss;

@end
