//
//  SNHeaderNode.h
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 15/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol SNHeaderNodeDelegate <NSObject>

- (void)pausePressed;

@optional
- (void)timerDidFinish;

@end

@interface SNHeaderNode : SKSpriteNode
@property (nonatomic) BOOL showsTimer;
@property (nonatomic) BOOL showsScore;

@property (nonatomic) NSInteger score;
@property (weak, nonatomic) id<SNHeaderNodeDelegate> delegate;
@property (nonatomic) NSInteger timer;

- (instancetype)initWithSize:(CGSize)size color:(UIColor *)color delegate:(id<SNHeaderNodeDelegate>)delegate;

@end
