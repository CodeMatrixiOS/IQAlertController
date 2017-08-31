//
//  OptionTableViewController.h
//  IQAlertController Demo
//
//  Created by Iftekhar on 05/08/17.
//  Copyright © 2017 Iftekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionTableViewController;

@protocol OptionTableViewControllerDelegate <NSObject>

-(void)optionTableViewController:(OptionTableViewController*)controller didSelectedIndex:(NSInteger)index;

@end

@interface OptionTableViewController : UITableViewController

@property(nonatomic, assign) id<OptionTableViewControllerDelegate> delegate;
@property(nonatomic, strong) NSArray *options;
@property(nonatomic, assign) NSInteger selectedIndex;

@end
