//
//  SNColoursViewController.m
//  Sanskrit
//
//  Created by Aashirwaad on 17/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNColoursViewController.h"
#import "SNColoursScene.h"
#import "SNDataManager.h"

@interface SNColoursViewController ()

@end

@implementation SNColoursViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = self.skView;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SNColoursScene *scene = [SNColoursScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)gameOverWithScore:(NSUInteger)score
{
    if (score) {
        [[SNDataManager sharedInstance] saveScoreForColoursGame:score];
    }
    
    [super gameOverWithScore:score];
}

- (void)restartGame
{
    self.gameScene = nil;
    
    __block SKScene *toRemove = self.skView.scene;
    
    SNColoursScene *scene = [SNColoursScene sceneWithSize:self.skView.bounds.size];
    scene.delegate = self;
    
    SKTransition *transition = [SKTransition crossFadeWithDuration:0.4];
    transition.pausesOutgoingScene = YES;
    [self.skView presentScene:scene transition:transition];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        toRemove = nil;
    });
}


@end
