//
//  MainTableViewController.m
//  IQAlertController Demo
//
//  Created by Iftekhar on 05/08/17.
//  Copyright © 2017 Iftekhar. All rights reserved.
//

#import "MainTableViewController.h"
#import <IQAlertController/IQAlertController.h>
#import "ModalViewController.h"
#import "OptionTableViewController.h"


#define animationStrings @[@"Top", @"Bottom", @"Left", @"Right", @"Fade", @"Pop", @"None"]
#define positionStrings @[@"Center", @"Top", @"Bottom", @"Left", @"Right", @"Customize Center"]

@interface MainTableViewController ()<OptionTableViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelAnimationDuration;
@property (strong, nonatomic) IBOutlet UIStepper *stepperAnimationDuration;
@property (nonatomic, assign) IQAlertControllerAnimation animationStyle;

@property (nonatomic, assign) IQAlertControllerPosition alertPosition;
@property (nonatomic, assign) CGPoint customizeCenter;

@property (nonatomic, assign) CGSize maximumContentSize;
@property (nonatomic, assign) CGSize minimumContentSize;

@property(nonatomic, assign) BOOL enableBlurEffect;
@property(nonatomic, assign) BOOL allowTappedDismiss;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _customizeCenter = CGPointMake(200, 200);
    _enableBlurEffect = YES;
    _allowTappedDismiss = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (IBAction)showAlertAction:(id)sender
{
    ModalViewController *modalController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ModalViewController class])];
    modalController.view.translatesAutoresizingMaskIntoConstraints = NO;
    IQAlertController *alertController = [[IQAlertController alloc] initWithViewController:modalController];
    alertController.animationDuration = self.stepperAnimationDuration.value;
    alertController.animationStyle = self.animationStyle;
    alertController.alertPosition = self.alertPosition;
    alertController.customizeCenter = self.customizeCenter;
    alertController.allowTappedDismiss = self.allowTappedDismiss;
    alertController.enableBlurEffect = self.enableBlurEffect;
//    alertController.effectStyle = UIBlurEffectStyleDark;
    
    alertController.alertViewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    alertController.alertViewContainer.layer.shadowOffset = CGSizeZero;
    alertController.alertViewContainer.layer.shadowRadius = 20.0;
    alertController.alertViewContainer.layer.shadowOpacity = 0.5;
    
    [alertController showWithCompletion:nil];
}


- (IBAction)animationDurationStepperAction:(UIStepper *)sender {
    self.labelAnimationDuration.text = [NSString stringWithFormat:@"%.2f",sender.value];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    switch (indexPath.section)
    {
            //animation
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.detailTextLabel.text = animationStrings[self.animationStyle];
                    break;
                    
                case 1:
                    self.labelAnimationDuration.text = [NSString stringWithFormat:@"%.2f",self.stepperAnimationDuration.value];
                    cell.detailTextLabel.text = animationStrings[self.animationStyle];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            //position
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.detailTextLabel.text = positionStrings[self.alertPosition];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            //size
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.detailTextLabel.text = @"";
                    break;
                    
                default:
                    break;
            }
        }
            break;
            //other
        case 3:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.accessoryType = self.enableBlurEffect ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                    
                case 1:
                    cell.accessoryType = self.allowTappedDismiss ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
            //animation
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    OptionTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OptionTableViewController class])];
                    controller.delegate = self;
                    controller.view.tag = 1;
                    controller.options = animationStrings;
                    controller.selectedIndex = self.animationStyle;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            //position
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    OptionTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OptionTableViewController class])];
                    controller.delegate = self;
                    controller.view.tag = 2;
                    controller.options = positionStrings;
                    controller.selectedIndex = self.alertPosition;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            //size
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                    break;
                    
                default:
                    break;
            }
        }
            break;
            //other
        case 3:
        {
            switch (indexPath.row)
            {
                case 0:
                    self.enableBlurEffect = !self.enableBlurEffect;
                    cell.accessoryType = self.enableBlurEffect ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                    
                case 1:
                    self.allowTappedDismiss = !self.allowTappedDismiss;
                    cell.accessoryType = self.allowTappedDismiss ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)optionTableViewController:(OptionTableViewController *)controller didSelectedIndex:(NSInteger)index
{
    if (controller.view.tag == 1)
    {
        self.animationStyle = index;
    }
    else if (controller.view.tag == 2)
    {
        self.alertPosition = index;
    }
}

@end
