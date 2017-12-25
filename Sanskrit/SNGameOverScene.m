//
//  SNGameOverScene.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 14/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNGameOverScene.h"
#import "AGSpriteButton.h"
#import "UIColor+SNColors.h"

@implementation SNGameOverScene

- (instancetype)initWithSize:(CGSize)size delegate:(id<SNGameOverSceneDelegate>)delegate score:(NSInteger)score
{
    if (self = [super initWithSize:size]) {
        self.delegate = delegate;
        
        self.backgroundColor = [UIColor sn_backgroundColor];
        
        CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 320 : 220;
        CGFloat height = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 64 : 44;
        CGFloat separator = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 8 : 4;
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        scoreLabel.text = [NSString stringWithFormat:@"You scored a %ld.", (long)score];
        scoreLabel.fontColor = [UIColor sn_darkTextColor];
        scoreLabel.fontSize = height / 2;
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + height / 2 + separator + height / 2 + separator + height / 2);
        if (score) [self addChild:scoreLabel];
        
        AGSpriteButton *pauseButton = [[AGSpriteButton alloc] initWithColor:[UIColor sn_buttonColor] size:CGSizeMake(width - height, height)];
        [pauseButton setLabelWithText:@"Resume" andFont:[UIFont fontWithName:@"Helvetica" size:height / 2] withColor:[UIColor whiteColor]];
        [pauseButton addTarget:self selector:@selector(resumeGame) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
        
        SKShapeNode *pauseButtonParent = [SKShapeNode node];
        pauseButtonParent.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-width / 2, -height / 2, width, height) cornerRadius:height / 2].CGPath;
        pauseButtonParent.fillColor = [UIColor sn_buttonColor];
        pauseButtonParent.strokeColor = [UIColor clearColor];
        pauseButtonParent.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + height / 2 + separator + height / 2);
        
        [pauseButtonParent addChild:pauseButton];
        if ([self.delegate shouldShowResumeButton]) [self addChild:pauseButtonParent];

        AGSpriteButton *quitButton = [[AGSpriteButton alloc] initWithColor:[UIColor sn_buttonColor] size:CGSizeMake(width - height, height)];
        [quitButton setLabelWithText:@"Quit" andFont:[UIFont fontWithName:@"Helvetica" size:height / 2] withColor:[UIColor whiteColor]];
        [quitButton addTarget:self selector:@selector(quitGame) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
        
        SKShapeNode *quitButtonParent = pauseButtonParent.copy;
        quitButtonParent.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [quitButtonParent addChild:quitButton];
        [self addChild:quitButtonParent];
        
        AGSpriteButton *restartButton = [[AGSpriteButton alloc] initWithColor:[UIColor sn_buttonColor] size:CGSizeMake(width - height, height)];
        [restartButton setLabelWithText:@"Restart" andFont:[UIFont fontWithName:@"Helvetica" size:height / 2] withColor:[UIColor whiteColor]];
        [restartButton addTarget:self selector:@selector(restartGame) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
        
        SKShapeNode *restartButtonParent = pauseButtonParent.copy;
        restartButtonParent.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - height / 2 - separator - height / 2);
        [restartButtonParent addChild:restartButton];
        [self addChild:restartButtonParent];

    }
    return self;
}

- (void)restartGame
{
    NSParameterAssert(self.delegate);
    NSParameterAssert([self.delegate respondsToSelector:@selector(restartGame)]);
    [self.delegate restartGame];
}

- (void)quitGame
{
    NSParameterAssert(self.delegate);
    NSParameterAssert([self.delegate respondsToSelector:@selector(quitGame)]);
    [self.delegate quitGame];
}

- (void)resumeGame
{
    NSParameterAssert(self.delegate);
    NSParameterAssert([self.delegate respondsToSelector:@selector(resumeGame)]);
    [self.delegate resumeGame];
}

@end
