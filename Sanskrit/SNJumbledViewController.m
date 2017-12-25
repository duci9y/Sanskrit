//
//  SNJumbledViewController.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 14/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNJumbledViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "SNJumbledScene.h"
#import "SNDataManager.h"

@interface SNJumbledViewController ()
@property (strong, nonatomic) IBOutlet SKView *skView;
@end

@implementation SNJumbledViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = self.skView;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SNJumbledScene *scene = [SNJumbledScene sceneWithSize:skView.bounds.size];
    scene.delegate = self;
    
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [skView presentScene:scene];
}

- (void)gameOverWithScore:(NSUInteger)score
{
    if (score) {
        [[SNDataManager sharedInstance] saveScoreForJumbledGame:score];
    }
    
    [super gameOverWithScore:score];
}

- (void)restartGame
{
    self.gameScene = nil;
    
    __block SKScene *toRemove = self.skView.scene;
    
    SNJumbledScene *scene = [SNJumbledScene sceneWithSize:self.skView.bounds.size];
    scene.delegate = self;
    
    SKTransition *transition = [SKTransition crossFadeWithDuration:0.4];
    transition.pausesOutgoingScene = YES;
    [self.skView presentScene:scene transition:transition];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        toRemove = nil;
    });
}

@end
