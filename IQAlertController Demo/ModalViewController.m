//
//  ModalViewController.m
//  IQAlertController Demo
//
//  Created by Iftekhar on 05/08/17.
//  Copyright © 2017 Iftekhar. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()

@property (strong, nonatomic) IBOutlet UIStepper *stepperWidth;
@property (strong, nonatomic) IBOutlet UIStepper *stepperHeight;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;

@end

@implementation ModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10.0;
    self.stepperWidth.value = self.constraintWidth.constant;
    self.stepperHeight.value = self.constraintHeight.constant;
}

- (IBAction)widthStepperChanged:(UIStepper *)sender
{
    self.constraintWidth.constant = sender.value;
}

- (IBAction)heightStepperChanged:(UIStepper *)sender
{
    self.constraintHeight.constant = sender.value;
}


@end
