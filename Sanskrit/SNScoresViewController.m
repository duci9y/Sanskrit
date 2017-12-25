//
//  SNScoresTableViewController.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 17/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNScoresViewController.h"
#import "UIColor+SNColors.h"

@interface SNScoresViewController ()
@property (strong, nonatomic) NSArray *scores;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SNScoresViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSParameterAssert(self.key);
    
    self.scores = [[NSUserDefaults standardUserDefaults] arrayForKey:self.key];
    if (!self.scores) self.scores = @[@"No scores"];
    NSParameterAssert(self.scores);
    
    CGFloat height = self.scores.count * self.tableView.rowHeight;
    self.tableView.sectionHeaderHeight = self.view.bounds.size.height - height / 2;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.scores[indexPath.row]];
    cell.textLabel.textColor = [UIColor sn_darkTextColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (IBAction)backPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
