//
//  SNViewController.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 15/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNViewController.h"
#import "SNScoresViewController.h"

@implementation SNViewController

- (void)gameOverWithScore:(NSUInteger)score
{
    __block SKScene *toRemove = self.skView.scene;
    
    SNGameOverScene *gameOver = [[SNGameOverScene alloc] initWithSize:self.skView.bounds.size delegate:self score:score];
    SKTransition *transition = [SKTransition crossFadeWithDuration:0.4];
    transition.pausesOutgoingScene = YES;
    [self.skView presentScene:gameOver transition:transition];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (toRemove) toRemove = nil;
        
    });
}

- (BOOL)shouldShowResumeButton
{
    if (self.gameScene) return YES;
    return NO;
}

- (void)sceneDidPause
{
    self.gameScene = self.skView.scene;
    
    SNGameOverScene *gameOver = [[SNGameOverScene alloc] initWithSize:self.skView.bounds.size delegate:self score:NO];
    SKTransition *transition = [SKTransition crossFadeWithDuration:0.4];
    transition.pausesOutgoingScene = YES;
    [self.skView presentScene:gameOver transition:transition];
}

- (void)quitGame
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)restartGame
{
    
}

- (void)resumeGame
{
    SKTransition *transition = [SKTransition crossFadeWithDuration:0.4];
    transition.pausesOutgoingScene = YES;
    [self.skView presentScene:self.gameScene transition:transition];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.gameScene = nil;
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SNScoresViewController *vc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"numbersSegue"])
        vc.key = @"numbersGameScores";
    if ([segue.identifier isEqualToString:@"jumbledSegue"])
        vc.key = @"jumbledGameScores";
    if ([segue.identifier isEqualToString:@"coloursSegue"])
        vc.key = @"coloursGameScores";
}

- (IBAction)backPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
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
