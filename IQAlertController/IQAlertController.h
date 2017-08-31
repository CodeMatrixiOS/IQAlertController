//
// IQAlertController.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IQAlertControllerAnimation) {
    IQAlertControllerAnimationTop = 0,
    IQAlertControllerAnimationBottom,
    IQAlertControllerAnimationLeft,
    IQAlertControllerAnimationRight,
    IQAlertControllerAnimationFade,
    IQAlertControllerAnimationPop,
    IQAlertControllerAnimationNone,
};

typedef NS_ENUM(NSInteger, IQAlertControllerPosition) {
    IQAlertControllerPositionCenter = 0,
    IQAlertControllerPositionTop,
    IQAlertControllerPositionBottom,
    IQAlertControllerPositionLeft,
    IQAlertControllerPositionRight,
    IQAlertControllerPositionCustomizeCenter,
};

@interface IQAlertController : UIViewController

-(instancetype)initWithView:(UIView*)view;
-(instancetype)initWithViewController:(UIViewController*)viewController;

@property (nonatomic, assign) IQAlertControllerAnimation animationStyle;

@property (nonatomic, assign) CGFloat animationDuration;    //Default is 0.25;

@property (nonatomic, assign) IQAlertControllerPosition alertPosition;
@property (nonatomic, assign) CGPoint customizeCenter;

@property (nonatomic, assign) CGSize maximumContentSize;
@property (nonatomic, assign) CGSize minimumContentSize;

@property (nonatomic, strong, readonly) UIView *viewToPresent;
@property (nonatomic, strong, readonly) UIViewController *viewControllerToPresent;

@property(nonatomic, assign) BOOL enableBlurEffect;
@property (nonatomic, assign) UIBlurEffectStyle effectStyle;

@property(nonatomic, assign) BOOL allowTappedDismiss;
@property(nonatomic, strong) void (^tappedDismissBlock)(void);

@property(nonatomic, strong) void (^dismissCompletionBlock)(void);

//@property(nonatomic, strong) UIColor *backgroundColor;

-(void)showWithCompletion:(void (^)(void))completion;
-(void)dismissWithCompletion:(void (^)(void))completion;

//This is the container view in which view will be added
@property(nonatomic, strong, readonly) UIView *alertViewContainer;

@end


@interface UIViewController (IQAlertController)

@property(nonatomic, weak) IQAlertController *alertController;

@end

@interface UIView (IQAlertController)

@property(nonatomic, weak) IQAlertController *alertController;

@end
