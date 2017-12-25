//
//  SNGameOverScene.h
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 14/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol SNGameOverSceneDelegate <NSObject>

- (void)restartGame;
- (void)quitGame;
- (void)resumeGame;
- (BOOL)shouldShowResumeButton;

@end

@interface SNGameOverScene : SKScene
- (instancetype)initWithSize:(CGSize)size delegate:(id<SNGameOverSceneDelegate>)delegate score:(NSInteger)score;
@property (weak, nonatomic) id<SNGameOverSceneDelegate> delegate;
@end
