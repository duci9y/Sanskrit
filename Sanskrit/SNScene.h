//
//  SNScene.h
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 15/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SNHeaderNode.h"

@protocol SNSceneDelegate <NSObject>

- (void)gameOverWithScore:(NSUInteger)score;
- (void)sceneDidPause;

@end

@interface SNScene : SKScene <SNHeaderNodeDelegate>
@property (weak, nonatomic) id<SNSceneDelegate> delegate;
@property (strong, nonatomic) SNHeaderNode *header;
@property (nonatomic) NSInteger score;
@end
