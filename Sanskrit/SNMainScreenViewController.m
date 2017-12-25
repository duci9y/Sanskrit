//
//  SNMainScreenViewController.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 14/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNMainScreenViewController.h"

@interface SNMainScreenViewController ()
@property (strong, nonatomic, readonly) UICollectionViewFlowLayout *collectionViewLayout;
@end

@implementation SNMainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat top = (self.view.bounds.size.height - ([self collectionView:nil numberOfItemsInSection:0] * self.collectionViewLayout.itemSize.height) - (([self collectionView:nil numberOfItemsInSection:0] - 1) * self.collectionViewLayout.minimumLineSpacing)) / 2;
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(top + 10, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *label;
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UILabel class]]) label = (UILabel *)view;
    }
    
    if (!label) {
        for (UIView *view in cell.subviews) {
            for (UIView *anotherView in view.subviews) {
                if ([anotherView isKindOfClass:[UILabel class]]) label = (UILabel *)anotherView;
            }
        }
    }
    
    switch (indexPath.row) {
        case 0:
            label.text = @"Numbers";
            break;
        case 1:
            label.text = @"Jumbled Sentences";
            break;
        case 2:
            label.text = @"Colours";
            break;
        case 3:
            label.text = @"High Scores";
            break;
        default:
            label.text = @"About";
            break;
    }
    
    cell.layer.cornerRadius = self.collectionViewLayout.itemSize.height / 2;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *segueIdentifier;
    switch (indexPath.row) {
        case 0:
            segueIdentifier = @"numbers";
            break;
        case 1:
            segueIdentifier = @"jumbled";
            break;
        case 2:
            segueIdentifier = @"colours";
            break;
        case 3:
            segueIdentifier = @"scores";
            break;
        case 4:
            segueIdentifier = @"about";
            break;
        default:
            segueIdentifier = @"numbers";
            break;
    }
    
    [self performSegueWithIdentifier:segueIdentifier sender:self];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
