//
//  IQAlertController.h
// https://github.com/hackiftekhar/IQAlertController
// Copyright (c) 2017 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "IQAlertController.h"

@interface IQAlertController ()

@property(nonatomic, strong, readonly) UIVisualEffectView *visualEffectView;

@property (nonatomic, strong) UIWindow    *alertWindow;

@property(nonatomic, readonly) CGPoint beginAnimationTranslation;
@property(nonatomic, readonly) CGPoint endAnimationTranslation;

//maximumContentSize
@property(nonatomic, strong) NSLayoutConstraint *constraintMaxWidth;
@property(nonatomic, strong) NSLayoutConstraint *constraintMaxHeight;

//minimumContentSize
@property(nonatomic, strong) NSLayoutConstraint *constraintMinWidth;
@property(nonatomic, strong) NSLayoutConstraint *constraintMinHeight;

@property(nonatomic, strong) UIGestureRecognizer *tapGesture;
@property(nonatomic, strong) UIGestureRecognizer *fakeTapGesture;

@end

@implementation IQAlertController
@synthesize visualEffectView = _visualEffectView;
@synthesize alertViewContainer = _alertViewContainer;

-(instancetype)initWithView:(UIView*)view
{
    self = [super init];
    
    if (self)
    {
        _viewToPresent = view;
    }

    return self;
}

-(instancetype)initWithViewController:(UIViewController*)viewController;
{
    self = [super init];
    
    if (self)
    {
        _viewControllerToPresent = viewController;
    }
    
    return self;
}

-(void)loadView
{
    self.view = self.visualEffectView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    //Adding container view to main view
    {
        [self.visualEffectView.contentView addSubview:self.alertViewContainer];

        NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.visualEffectView.contentView addConstraints:@[constraintCenterX,constraintCenterY]];
    }

    //Adding view to present to container view
    {
        UIView *alertView = self.viewControllerToPresent.view ?: self.viewToPresent;
        
        if (self.viewControllerToPresent)
        {
            [self addChildViewController:self.viewControllerToPresent];
        }
        
        [self.alertViewContainer addSubview:alertView];
        
        if (self.viewControllerToPresent)
        {
            [self.viewControllerToPresent didMoveToParentViewController:self];
        }
        
        NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *constraintLeading = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *constraintTrailing = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        
        [self.visualEffectView.contentView addConstraints:@[constraintTop,constraintBottom,constraintLeading,constraintTrailing]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRotate:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

-(CGFloat)animationDuration
{
    if (_animationDuration <= 0)
    {
        return 0.25;
    }
    else
    {
        return _animationDuration;
    }
}

-(void)setMaximumContentSize:(CGSize)maximumContentSize
{
    _maximumContentSize = maximumContentSize;
    
    if (maximumContentSize.width <=0)
    {
        if (self.constraintMaxWidth)
        {
            [self.alertViewContainer removeConstraint:self.constraintMaxWidth];
        }
    }
    else
    {
        if (self.constraintMaxWidth == nil)
        {
            self.constraintMaxWidth = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maximumContentSize.width];
            [self.alertViewContainer addConstraint:self.constraintMaxWidth];
        }
        else
        {
            self.constraintMaxWidth.constant = maximumContentSize.width;
        }
    }
    
    if (maximumContentSize.height <=0)
    {
        if (self.constraintMaxHeight)
        {
            [self.alertViewContainer removeConstraint:self.constraintMaxHeight];
        }
    }
    else
    {
        if (self.constraintMaxHeight == nil)
        {
            self.constraintMaxHeight = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maximumContentSize.height];
            [self.alertViewContainer addConstraint:self.constraintMaxHeight];
        }
        else
        {
            self.constraintMaxHeight.constant = maximumContentSize.height;
        }
    }
}

-(void)setMinimumContentSize:(CGSize)minimumContentSize
{
    _minimumContentSize = minimumContentSize;
    
    if (minimumContentSize.width <=0)
    {
        if (self.constraintMinWidth)
        {
            [self.alertViewContainer removeConstraint:self.constraintMinWidth];
        }
    }
    else
    {
        if (self.constraintMinWidth == nil)
        {
            self.constraintMinWidth = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:minimumContentSize.width];
            [self.alertViewContainer addConstraint:self.constraintMinWidth];
        }
        else
        {
            self.constraintMinWidth.constant = minimumContentSize.width;
        }
    }
    
    if (minimumContentSize.width <=0)
    {
        if (self.constraintMinHeight)
        {
            [self.alertViewContainer removeConstraint:self.constraintMinHeight];
        }
    }
    else
    {
        if (self.constraintMinHeight == nil)
        {
            self.constraintMinHeight = [NSLayoutConstraint constraintWithItem:self.alertViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:minimumContentSize.height];
            [self.alertViewContainer addConstraint:self.constraintMinHeight];
        }
        else
        {
            self.constraintMinHeight.constant = minimumContentSize.height;
        }
    }
}

-(UIView *)alertViewContainer
{
    if (_alertViewContainer == nil)
    {
        _alertViewContainer = [[UIView alloc] init];
        _alertViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
        _alertViewContainer.clipsToBounds = NO;
    }
    
    return _alertViewContainer;
}

-(UIVisualEffectView *)visualEffectView
{
    if (_visualEffectView == nil)
    {
        _visualEffectView = [[UIVisualEffectView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _visualEffectView;
}

#pragma mark - Tapped dismiss
-(void)setAllowTappedDismiss:(BOOL)allowTappedDismiss
{
    _allowTappedDismiss = allowTappedDismiss;

    self.tapGesture.enabled = _allowTappedDismiss;
    self.fakeTapGesture.enabled = _allowTappedDismiss;
}

-(UIGestureRecognizer *)tapGesture
{
    if (_tapGesture == nil)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [self.visualEffectView.contentView addGestureRecognizer:_tapGesture];
    }
    
    return _tapGesture;
}

-(UIGestureRecognizer *)fakeTapGesture
{
    if (_fakeTapGesture == nil)
    {
        _fakeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
        [self.alertViewContainer addGestureRecognizer:_fakeTapGesture];
    }
    
    return _fakeTapGesture;
}

-(void)tapRecognized:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        __weak typeof(self) weakSelf = self;
        
        [self dismissWithCompletion:^{
            
            if (weakSelf.tappedDismissBlock)
            {
                weakSelf.tappedDismissBlock();
            }
        }];
    }
}

-(CGPoint)beginAnimationTranslation
{
    CGPoint beginAnimationTranslation = CGPointZero;
    
    switch (self.animationStyle)
    {
        case IQAlertControllerAnimationTop:
        case IQAlertControllerAnimationBottom:
        {
            beginAnimationTranslation.y = (self.alertViewContainer.bounds.size.height+self.view.bounds.size.height)/2;

            if (self.animationStyle == IQAlertControllerAnimationTop)
            {
                beginAnimationTranslation.y = -beginAnimationTranslation.y;
            }
            
            switch (self.alertPosition)
            {
                case IQAlertControllerPositionLeft:
                {
                    beginAnimationTranslation.x = (self.alertViewContainer.bounds.size.width-self.view.bounds.size.width)/2;
                }
                    break;
                case IQAlertControllerPositionRight:
                {
                    beginAnimationTranslation.x = -(self.alertViewContainer.bounds.size.width-self.view.bounds.size.width)/2;
                }
                    break;
                case IQAlertControllerPositionCustomizeCenter:
                {
                    beginAnimationTranslation.x = self.customizeCenter.x - self.view.center.x;
                    beginAnimationTranslation.y += self.customizeCenter.y - self.view.center.y;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case IQAlertControllerAnimationLeft:
        case IQAlertControllerAnimationRight:
        {
            beginAnimationTranslation.x = (self.alertViewContainer.bounds.size.width+self.view.bounds.size.width)/2;
            
            if (self.animationStyle == IQAlertControllerAnimationLeft)
            {
                beginAnimationTranslation.x = -beginAnimationTranslation.x;
            }

            switch (self.alertPosition)
            {
                case IQAlertControllerPositionTop:
                {
                    beginAnimationTranslation.y = (self.alertViewContainer.bounds.size.height-self.view.bounds.size.height)/2;
                }
                    break;
                case IQAlertControllerPositionBottom:
                {
                    beginAnimationTranslation.y = -(self.alertViewContainer.bounds.size.height-self.view.bounds.size.height)/2;
                }
                    break;
                case IQAlertControllerPositionCustomizeCenter:
                {
                    beginAnimationTranslation.x += self.customizeCenter.x - self.view.center.x;
                    beginAnimationTranslation.y += self.customizeCenter.y - self.view.center.y;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case IQAlertControllerAnimationFade:
        case IQAlertControllerAnimationPop:
        case IQAlertControllerAnimationNone:
        {
            switch (self.alertPosition)
            {
                case IQAlertControllerPositionTop:
                {
                    beginAnimationTranslation.y = (self.alertViewContainer.bounds.size.height-self.view.bounds.size.height)/2;
                }
                    break;
                case IQAlertControllerPositionBottom:
                {
                    beginAnimationTranslation.y = -(self.alertViewContainer.bounds.size.height-self.view.bounds.size.height)/2;
                }
                    break;
                case IQAlertControllerPositionLeft:
                {
                    beginAnimationTranslation.x = (self.alertViewContainer.bounds.size.width-self.view.bounds.size.width)/2;
                }
                    break;
                case IQAlertControllerPositionRight:
                {
                    beginAnimationTranslation.x = -(self.alertViewContainer.bounds.size.width-self.view.bounds.size.width)/2;
                }
                    break;
                case IQAlertControllerPositionCustomizeCenter:
                {
                    beginAnimationTranslation.x = self.customizeCenter.x - self.view.center.x;
                    beginAnimationTranslation.y = self.customizeCenter.y - self.view.center.y;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;

    }
    
    return beginAnimationTranslation;
}

-(CGPoint)endAnimationTranslation
{
    CGPoint endAnimationTranslation = CGPointZero;

    switch (self.alertPosition)
    {
        case IQAlertControllerPositionTop:
        {
            endAnimationTranslation.y = (self.alertViewContainer.bounds.size.height-self.view.bounds.size.height)/2;
        }
            break;
        case IQAlertControllerPositionBottom:
        {
            endAnimationTranslation.y = -(self.alertViewContainer.bounds.size.height-self.view.bounds.size.height)/2;
        }
            break;
        case IQAlertControllerPositionLeft:
        {
            endAnimationTranslation.x = (self.alertViewContainer.bounds.size.width-self.view.bounds.size.width)/2;
        }
            break;
        case IQAlertControllerPositionRight:
        {
            endAnimationTranslation.x = -(self.alertViewContainer.bounds.size.width-self.view.bounds.size.width)/2;
        }
            break;
        case IQAlertControllerPositionCustomizeCenter:
        {
            endAnimationTranslation.x = self.customizeCenter.x - self.view.center.x;
            endAnimationTranslation.y = self.customizeCenter.y - self.view.center.y;
        }
            break;
            
        default:
            break;
    }
    
    return endAnimationTranslation;
}

-(void)showWithCompletion:(void (^)(void))completion
{
    if (!_alertWindow)
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];

        navController.view.backgroundColor = [UIColor clearColor];
        window.rootViewController = navController;
        _alertWindow = window;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [_alertWindow makeKeyAndVisible];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    double animationDuration =  [self animationDuration];
    CGAffineTransform beginTransform = CGAffineTransformIdentity;
    switch (self.animationStyle)
    {
        case IQAlertControllerAnimationNone:
        {
            animationDuration = 0;
        }
            break;
        case IQAlertControllerAnimationFade:
        {
            self.alertViewContainer.alpha = 0.0;
        }
            break;
        case IQAlertControllerAnimationPop:
        {
            beginTransform = CGAffineTransformMakeScale(1.2, 1.2);
            self.alertViewContainer.alpha = 0.0;
        }
            break;
        default:
            break;
    }

    CGPoint beginAnimationTranslation = [self beginAnimationTranslation];
    self.alertViewContainer.transform = CGAffineTransformTranslate(beginTransform, beginAnimationTranslation.x, beginAnimationTranslation.y);
    
    self.visualEffectView.contentView.backgroundColor = [UIColor clearColor];

    __weak typeof(self) weakSelf  = self;
    [UIView animateWithDuration:animationDuration delay:0 options:(UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut) animations:^{
        
        if (weakSelf.enableBlurEffect)
        {
            weakSelf.visualEffectView.effect = [UIBlurEffect effectWithStyle:self.effectStyle];
        }
        else
        {
            weakSelf.visualEffectView.contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        }

        weakSelf.alertViewContainer.alpha = 1.0;
        
        CGPoint endAnimationTranslation = [self endAnimationTranslation];
        self.alertViewContainer.transform = CGAffineTransformMakeTranslation(endAnimationTranslation.x, endAnimationTranslation.y);

    } completion:^(BOOL finished) {
        
        if (completion)
        {
            completion();
        }
    }];
}

-(void)dismissWithCompletion:(void (^)(void))completion
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self.alertViewContainer removeGestureRecognizer:self.tapGesture];
    [self.alertViewContainer removeGestureRecognizer:self.fakeTapGesture];

    double animationDuration =  [self animationDuration];
    
    switch (self.animationStyle)
    {
        case IQAlertControllerAnimationNone:
        {
            animationDuration = 0;
        }
            break;
        default:
            break;
    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationDuration delay:0 options:(UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn) animations:^{
        
        CGPoint beginAnimationTranslation = [self beginAnimationTranslation];
        CGAffineTransform beginTransform = CGAffineTransformMakeTranslation(beginAnimationTranslation.x, beginAnimationTranslation.y);

        switch (self.animationStyle)
        {
            case IQAlertControllerAnimationFade:
            {
                self.alertViewContainer.alpha = 0.0;
            }
                break;
            case IQAlertControllerAnimationPop:
            {
                self.alertViewContainer.alpha = 0.0;
                beginTransform = CGAffineTransformScale(beginTransform, 1.2, 1.2);
            }
                break;
                default:
                break;
        }

        self.alertViewContainer.transform = beginTransform;

        if (weakSelf.enableBlurEffect)
        {
            weakSelf.visualEffectView.effect = nil;
        }
        else
        {
            weakSelf.visualEffectView.contentView.backgroundColor = [UIColor clearColor];
        }
        
    } completion:^(BOOL finished) {
        
        if (self.viewControllerToPresent)
        {
            [weakSelf.viewControllerToPresent willMoveToParentViewController:nil];
        }
        
        UIView *alertView = weakSelf.viewControllerToPresent.view ?: weakSelf.viewToPresent;
        
        [alertView removeFromSuperview];
        
        if (self.viewControllerToPresent)
        {
            [weakSelf.viewControllerToPresent removeFromParentViewController];
        }
        
        weakSelf.alertWindow.rootViewController = nil;
        [weakSelf.alertWindow resignKeyWindow];
        [weakSelf.alertWindow removeFromSuperview];
        
        NSArray <UIWindow*> *windows = [[UIApplication sharedApplication] windows];
        
        for (UIWindow *window in [windows reverseObjectEnumerator]) {
            
            if(window != weakSelf.alertWindow && [window.rootViewController isKindOfClass:[UINavigationController class]] && window.keyWindow == NO)
            {
                [window makeKeyAndVisible];
                break;
            }
        }
        
        weakSelf.alertWindow = nil;
        
        if (completion)
        {
            completion();
        }
        
        if (weakSelf.dismissCompletionBlock)
        {
            weakSelf.dismissCompletionBlock();
        }
    }];
}

-(void)receivedRotate: (NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^(void) {
        
        weakSelf.alertViewContainer.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^(void) {
            weakSelf.alertViewContainer.alpha = 1.0;
        }];
    }];
}

@end


#import <objc/runtime.h>

@implementation UIViewController (IQAlertController)

-(void)setAlertController:(IQAlertController *)alertController
{
    objc_setAssociatedObject(self, @selector(alertController), alertController, OBJC_ASSOCIATION_ASSIGN);
}

-(IQAlertController *)alertController
{
   return objc_getAssociatedObject(self, @selector(alertController));
}

@end

@implementation UIView (IQAlertController)

-(void)setAlertController:(IQAlertController *)alertController
{
    objc_setAssociatedObject(self, @selector(alertController), alertController, OBJC_ASSOCIATION_ASSIGN);
}

-(IQAlertController *)alertController
{
    return objc_getAssociatedObject(self, @selector(alertController));
}

@end

