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
static const CGFloat marginInnerView    = 10.0f;
static const CGFloat separatorEachEle   = 10.0f;

@interface TLAlertView ()

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *message;
@property (nonatomic, strong) NSString  *buttonTitle;
@property (nonatomic, strong) UIView    *customAlertView;

@property (nonatomic, copy) TLAlertViewHandler handler;
@property (nonatomic, strong) TLAlertView *retainedSelf;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *innerView;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, readwrite) BOOL tap2close;

@end

@implementation TLAlertView

#pragma mark - Initializers

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    return [self initWithTitle:title message:message buttonTitle:buttonTitle handler:nil];
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle outsideClose: (BOOL)tap2close
{
    self.tap2close = tap2close;
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

-(instancetype)initWithView:(UIView *)view
{
    return [self initWithView:view handler:nil];
}

-(instancetype)initWithView:(UIView *)view outsideClose: (BOOL)tap2close
{
    self.tap2close = tap2close;
    return [self initWithView:view handler:nil];
}

-(instancetype)initWithView:(UIView *)view handler:(TLAlertViewHandler)handler
{
    if (!(self = [super init])) return nil;
    
    self.title = nil;
    self.message = nil;
    self.buttonTitle = @"Close";
    self.handler = handler;
    self.customAlertView = view;
    
    [self setupCustomView];
    
    return self;
}

#pragma mark - Private Methods

- (void)setupCustomView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.frame = keyWindow.bounds;
    
    // Set up our subviews
    self.backgroundView                 = [[UIView alloc] initWithFrame:keyWindow.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f]; // Determined empirically
    self.backgroundView.alpha           = 0.0f;
    [self addSubview:self.backgroundView];
    
    //////////////////////////////////////////
    // AlertView it self
    //////////////////////////////////////////
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 100)];
    self.alertView.backgroundColor = [UIColor redColor];
    self.alertView.layer.cornerRadius = 11.0f;
    self.alertView.layer.masksToBounds = YES;
    self.alertView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [self.alertView setTag:1];
    
    self.innerView = [[UIView alloc] initWithFrame:self.alertView.frame];
    [self.innerView setBackgroundColor:[UIColor clearColor]];
    [self.innerView setTag:2];
    
    [self.alertView addSubview:self.innerView];
    [self addSubview:self.alertView];
    
    // Add Custom View
    [self.innerView addSubview:[self returnUIForCustomView]];
    
    // Configure AlertView
    self.alertView.bounds = CGRectMake(0, 0, alertViewWidth, 44.0f + 44.0f + 45.0f);
    self.alertView.center = CGPointMake(CGRectGetMidX(keyWindow.bounds), - CGRectGetMaxY(self.alertView.bounds));
    
    // Add Button
    [self.innerView addSubview:[self returnUIForButton]];
    
    // Add layer to AlertView
    [self.alertView.layer addSublayer:[self subLayerLine]];
    
    // Resize all subviews
    [self AMResizeViewsWithCustomView];
    
    // Adjust our keyWindow's tint adjustment mode to make everything behind the alert view dimmed
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [keyWindow tintColorDidChange];
    
    // Set up our UIKit Dynamics
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    // add custom gestures.
    if(self.tap2close == YES){
        [self setupGestures];
    }
}

-(void)setup {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.frame = keyWindow.bounds;
    
    // Set up our subviews
    self.backgroundView                 = [[UIView alloc] initWithFrame:keyWindow.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f]; // Determined empirically
    self.backgroundView.alpha           = 0.0f;
    [self addSubview:self.backgroundView];
    
    //////////////////////////////////////////
    // AlertView it self
    //////////////////////////////////////////
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 100)];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 11.0f;
    self.alertView.layer.masksToBounds = YES;
    self.alertView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [self.alertView setTag:1];
    
    self.innerView = [[UIView alloc] initWithFrame:self.alertView.frame];
    [self.innerView setBackgroundColor:[UIColor clearColor]];
    [self.innerView setTag:2];
    
    [self.alertView addSubview:self.innerView];
    [self addSubview:self.alertView];
    
    // Add Title
    [self.innerView addSubview:[self returnUIForTitle]];
    
    // Add Messsage
    [self.innerView addSubview:[self returnUIForMessage]];
    
    // Configure AlertView
    self.alertView.bounds = CGRectMake(0, 0, alertViewWidth, 44.0f + 44.0f + 45.0f);
    self.alertView.center = CGPointMake(CGRectGetMidX(keyWindow.bounds), - CGRectGetMaxY(self.alertView.bounds));
    
    // Add Button
    [self.innerView addSubview:[self returnUIForButton]];
    
    // Add layer to AlertView
    [self.alertView.layer addSublayer:[self subLayerLine]];
    
    // Resize all subviews
    [self AMResizeViews];
    
    // Adjust our keyWindow's tint adjustment mode to make everything behind the alert view dimmed
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [keyWindow tintColorDidChange];
    
    // Set up our UIKit Dynamics
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    // add custom gestures.
    if(self.tap2close == YES){
        [self setupGestures];
    }
}

#pragma mark - Public Methods

-(void)show {
    // Assume the view is offscreen. Use a Snap behaviour to position it in the center of the screen.
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
    
}

-(void)dismiss {
    // Assume that the view is currently in the center of the screen. Add some gravity to make it disappear.
    // It *should* disappear before the animation fading away the background completes.
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.alertView]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.alertView]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.alertView];
    [self.animator addBehavior:itemBehaviour];
    
    // Animate out our background blind
    [UIView animateWithDuration:animationDuration animations:^{
        self.backgroundView.alpha = 0.0f;
        keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        [keyWindow tintColorDidChange];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        // Very important!
        self.retainedSelf = nil;
    }];
    
    // Call our completion handler
    if (self.handler) {
        self.handler(self);
    }
}

#pragma mark - UI stuff

- (UIView *)returnUIForCustomView
{
    return self.customAlertView;
}

- (CALayer *)subLayerLine
{
    CGRect lastFrame = [self frameForLastSettedView];
    
    CGFloat posYLine = lastFrame.origin.y;
    if(nil == self.customAlertView){
        posYLine += separatorEachEle;
    }
    
    CALayer *keylineLayer = [CALayer layer];
    keylineLayer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.29f] CGColor];
    keylineLayer.frame = CGRectMake(
                                    0,
                                    posYLine,
                                    alertViewWidth,
                                    0.5f);
    
    return keylineLayer;
}

- (UIView *)returnUIForTitle
{
    UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (alertViewWidth-marginInnerView*2), 44.0f)];
    titleLabel.text             = self.title;
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor blackColor];
    titleLabel.font             = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.lineBreakMode    = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines    = 0;
    
    titleLabel.frame            = [self adjustLabelFrame:titleLabel];
    
    return titleLabel;
}

- (UIView *)returnUIForMessage
{
    CGRect lastFrame                = [self frameForLastSettedView];
    UILabel *messageLabel           = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                                lastFrame.origin.x,
                                                                                lastFrame.origin.y + lastFrame.size.height + separatorEachEle,
                                                                                (alertViewWidth-marginInnerView*2),
                                                                                44.0f)];
    
    messageLabel.text               = self.message;
    messageLabel.backgroundColor    = [UIColor clearColor];
    messageLabel.textColor          = [UIColor blackColor];
    messageLabel.font               = [UIFont systemFontOfSize:15];
    messageLabel.textAlignment      = NSTextAlignmentCenter;
    messageLabel.lineBreakMode      = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines      = 0;
    
    messageLabel.frame = [self adjustLabelFrame:messageLabel];
    
    return messageLabel;
}

- (UIView *)returnUIForButton
{
    CGRect lastFrame = [self frameForLastSettedView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:self.buttonTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.frame = CGRectMake(
                              0 - marginInnerView,
                              lastFrame.origin.y + lastFrame.size.height + separatorEachEle,
                              alertViewWidth,
                              44.0f);
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (CGRect )adjustLabelFrame: (UILabel *)label
{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          label.font, NSFontAttributeName,
                                          label.textColor, NSForegroundColorAttributeName,
                                          nil];
    
    CGRect text_size = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributesDictionary
                                                context:nil];
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, text_size.size.height);
}

- (CGRect)frameForLastSettedView
{
    CGRect frame;
    NSArray *subviews = [self.innerView subviews];
    if([subviews count] > 0){
        UIView *t_View = [subviews objectAtIndex:[subviews count]-1];
        frame = CGRectMake(t_View.frame.origin.x, t_View.frame.origin.y, t_View.frame.size.width, t_View.frame.size.height);
    }
    
    return frame;
}

- (void)AMResizeViews
{
    CGFloat totalHeight = 0.0f;
    
    // GET ALL SUBVIEWS (height)
    for(UIView *i_views in [self.innerView subviews]){
        totalHeight += i_views.frame.size.height;
    }
    
    // ADD separatorEachEle to totalHeight value
    totalHeight+=separatorEachEle;
    
    if(totalHeight>0){
        // Finally, calculate frame of AlertView
        [self.alertView setFrame:CGRectMake(
                                            self.alertView.frame.origin.x,
                                            self.alertView.frame.origin.y,
                                            self.alertView.frame.size.width,
                                            totalHeight + marginInnerView*2
                                            )];
        
    }
    
    [self.innerView setFrame:CGRectMake(
                                         0 + marginInnerView,
                                         0 + marginInnerView,
                                         self.alertView.frame.size.width - marginInnerView*2,
                                         self.alertView.frame.size.height - marginInnerView*2
                                         )];
    
    
    
}

- (void)AMResizeViewsWithCustomView
{
    CGRect frameCustomAlert = self.customAlertView.frame;
    
    [self.alertView setFrame:CGRectMake(0,//self.alertView.frame.origin.x,
                                        0,//self.alertView.frame.origin.y,
                                        frameCustomAlert.size.width, //frame3.size.width,
                                        frameCustomAlert.size.height)];
    
    [self.innerView setFrame:CGRectMake(0, //self.innerView.frame.origin.x,
                                        0, //self.innerView.frame.origin.y,
                                        frameCustomAlert.size.width, //frame.size.width,
                                        frameCustomAlert.size.height)];
    
    [self.customAlertView setFrame:frameCustomAlert];
    
    // If we add a CancelButton
    CGFloat totalHeight = 0.0f;
    
    // GET ALL SUBVIEWS (height)
    for(UIView *i_views in [self.innerView subviews]){
        totalHeight += i_views.frame.size.height;
    }
    
    // ADD separatorEachEle to totalHeight value
    totalHeight+=separatorEachEle;
    
    if(totalHeight>0){
        // Finally, calculate frame of AlertView
        [self.alertView setFrame:CGRectMake(
                                            self.alertView.frame.origin.x,
                                            self.alertView.frame.origin.y,
                                            self.alertView.frame.size.width,
                                            totalHeight
                                            )];
        [self.innerView setFrame:CGRectMake(0, //self.innerView.frame.origin.x,
                                            0, //self.innerView.frame.origin.y,
                                            frameCustomAlert.size.width, //frame.size.width,
                                            totalHeight)];
        
    }
}

#pragma mark - gesture actions

- (void)setupGestures
{
    // Add lister main view to close if tapped
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapBlurArea:)];
    [tap2 setNumberOfTapsRequired:1];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView setMultipleTouchEnabled:NO];
    [self.backgroundView addGestureRecognizer:tap2];
}

-(void)closeTapBlurArea:(UITapGestureRecognizer *)sender
{
    UIView *senderview = sender.view;
    
    UIView *childView = nil;
    for(UIView *child in [senderview subviews]){
        if([child isKindOfClass:[self class]]){
            childView = child;
        }
    }
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        
        CGPoint location = [sender locationInView:senderview.superview];
        BOOL closeSuperView = [self isTappedOutsideRegion:childView withLocation: location];
        if(closeSuperView == YES){
            [self dismiss];
        }
        
    }
}

- (BOOL)isTappedOutsideRegion:(UIView *)view withLocation : (CGPoint)location
{
    CGFloat endX = (view.frame.origin.x + view.frame.size.width);
    CGFloat endY = (view.frame.origin.y + view.frame.size.height);
    BOOL isValid;
    if(
       (location.x < view.frame.origin.x || location.y < view.frame.origin.y) ||
       (location.x > endX || location.y > endY)
       ){
        isValid = YES;
    }else{
        isValid = NO;
    }
    
    return isValid;
}


@end
