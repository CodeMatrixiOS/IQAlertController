//
//  OptionTableViewController.m
//  IQAlertController Demo
//
//  Created by Iftekhar on 05/08/17.
//  Copyright © 2017 Iftekhar. All rights reserved.
//

#import "OptionTableViewController.h"

@interface OptionTableViewController ()

@end

@implementation OptionTableViewController

@synthesize delegate, options, selectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = (self.options)[indexPath.row];
    
    cell.accessoryType = (indexPath.row == self.selectedIndex)  ? UITableViewCellAccessoryCheckmark    :   UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndex = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(optionTableViewController:didSelectedIndex:)])
    {
        [self.delegate optionTableViewController:self didSelectedIndex:indexPath.row];
    }
    
    [tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
