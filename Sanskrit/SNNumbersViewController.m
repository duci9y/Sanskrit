//
//  SNViewController.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 11/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNNumbersViewController.h"
#import "SNNumbersScene.h"
#import "SNGameOverScene.h"
#import "SNDataManager.h"

@interface SNNumbersViewController () <SNSceneDelegate, SNGameOverSceneDelegate>
@property (strong, nonatomic) IBOutlet SNNumericInputView *numericInputView;
@end

@implementation SNNumbersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = self.skView;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SNNumbersScene *scene = [SNNumbersScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    self.numericInputView.delegate = scene;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)gameOverWithScore:(NSUInteger)score
{
    if (score) {
        [[SNDataManager sharedInstance] saveScoreForNumbersGame:score];
    }
    
    [super gameOverWithScore:score];
}

- (void)restartGame
{
    self.gameScene = nil;
    
    __block SKScene *toRemove = self.skView.scene;
    
    SNNumbersScene *scene = [SNNumbersScene sceneWithSize:self.skView.bounds.size];
    scene.delegate = self;
    self.numericInputView.delegate = scene;
    
    SKTransition *transition = [SKTransition crossFadeWithDuration:0.4];
    transition.pausesOutgoingScene = YES;
    [self.skView presentScene:scene transition:transition];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        toRemove = nil;
    });
}

@end
