//
//  SNScene.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 15/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNScene.h"
#import "UIColor+SNColors.h"

@implementation SNScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor sn_backgroundColor];
        CGFloat height = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 128 : 64;
        SNHeaderNode *header = [[SNHeaderNode alloc] initWithSize:CGSizeMake(size.width, height) color:[UIColor sn_backgroundColor] delegate:self];
        header.zPosition = 10;
        header.position = CGPointMake(size.width / 2, size.height - height / 2);
        [self addChild:header];
        
        self.header = header;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePressed) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)timerDidFinish
{
    NSParameterAssert(self.delegate);
    [self.delegate gameOverWithScore:self.score];
}

- (void)pausePressed
{
    self.paused = !self.paused;
    NSParameterAssert(self.delegate);
    [self.delegate sceneDidPause];
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    self.header.score = score;
}

@end
