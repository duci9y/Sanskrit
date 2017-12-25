//
//  SNHeaderNode.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 15/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNHeaderNode.h"
#import "UIColor+SNColors.h"
#import "AGSpriteButton.h"

@interface SNHeaderNode ()
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKNode *timerLabelContainer;
@property (strong, nonatomic) SKNode *scoreLabelContainer;
@property (strong, nonatomic) SKLabelNode *timerLabel;
@end

@implementation SNHeaderNode

// Spacing:
//         |
//       [20px]
//         |
//        16px
//         |
// -16px-[0.33]-16px-[0.33]-16px-[0.33]-16px-
//         |
//        16px
//         |

- (instancetype)initWithSize:(CGSize)size color:(UIColor *)color delegate:(id<SNHeaderNodeDelegate>)delegate
{
    if (self = [super initWithColor:color size:size]) {
        NSParameterAssert(delegate);
        self.delegate = delegate;
        
        CGFloat verticalSeparator = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 16 : 4;
        CGFloat horizontalSeparator = 16;
        
        CGFloat height = size.height - (2 * verticalSeparator) - 24 - verticalSeparator;
        CGFloat width = (size.width - 4 * horizontalSeparator) / 3;
        CGFloat y = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0 : -2;
        
        SKShapeNode *scoreLabelContainer = [SKShapeNode node];
        scoreLabelContainer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(width / -2, height / -2, width, height) cornerRadius:8].CGPath;
        scoreLabelContainer.fillColor = [UIColor sn_overlayColor];
        scoreLabelContainer.strokeColor = [UIColor clearColor];
        scoreLabelContainer.position = CGPointMake(0, y);
        
        SKShapeNode *timerLabelContainer = scoreLabelContainer.copy;
        timerLabelContainer.position = CGPointMake(size.width / -2 + horizontalSeparator + width / 2, y);
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        scoreLabel.fontSize = [self fontSizeForHeightConstraint:height - (verticalSeparator / 2)];
        scoreLabel.fontColor = [UIColor whiteColor];
        scoreLabel.text = @"0";
        scoreLabel.position = CGPointMake(0, scoreLabel.fontSize / -3);
        
        SKLabelNode *timerLabel = scoreLabel.copy;
        
        self.scoreLabel = scoreLabel;
        self.timerLabel = timerLabel;
        self.scoreLabelContainer = scoreLabelContainer;
        self.timerLabelContainer = timerLabelContainer;
        
        [scoreLabelContainer addChild:scoreLabel];
        [timerLabelContainer addChild:timerLabel];
        
        [self addChild:scoreLabelContainer];
        [self addChild:timerLabelContainer];
        
        AGSpriteButton *pauseButton = [AGSpriteButton buttonWithColor:[UIColor sn_buttonColor] andSize:CGSizeMake(width - height, height)];
        SKSpriteNode *pauseIcon = [SKSpriteNode spriteNodeWithImageNamed:@"Pause"];
        [pauseButton addTarget:self selector:@selector(pausePressed) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
        
        SKShapeNode *shape = [SKShapeNode node];
        shape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-width / 2, -height / 2, width, height) cornerRadius:height / 2].CGPath;
        shape.fillColor = [UIColor sn_buttonColor];
        shape.strokeColor = [UIColor clearColor];
        shape.position = CGPointMake(width / 2 + horizontalSeparator + width / 2, y);
        
        [pauseButton addChild:pauseIcon];
        [shape addChild:pauseButton];
        [self addChild:shape];
        
        SKSpriteNode *bar = [SKSpriteNode spriteNodeWithImageNamed:@"LongStripes"];
        bar.yScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1.0 : 0.5;
        bar.position = CGPointMake(0, self.size.height / -2 + 8);
        [self addChild:bar];
        
        self.showsTimer = NO;
        self.timer = 30;
    }
    return self;
}

- (void)setTimer:(NSInteger)timer
{
    _timer = timer;
    
    if (self.timer == 0) {
        [self.delegate timerDidFinish];
        return;
    }
    
    self.timerLabel.text = [NSString stringWithFormat:@"0:%02ld", (long)self.timer];
}

- (void)setShowsTimer:(BOOL)showsTimer
{
    _showsTimer = showsTimer;
    
    self.timerLabelContainer.hidden = !showsTimer;
}

- (void)setShowsScore:(BOOL)showsScore
{
    _showsScore = showsScore;
    
    self.scoreLabelContainer.hidden = !showsScore;
}

- (void)setScore:(NSInteger)score
{
    if (score > self.score)
        [self.scoreLabel runAction:[SKAction sequence:@[[SKAction scaleTo:1.8 duration:0.08],
                                                        [SKAction runBlock:^{
            self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
        }],
                                                        [SKAction scaleTo:0.8 duration:0.1], [SKAction scaleTo:1.0 duration:0.1]]]];
    else {
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
        SKAction *red = [SKAction runBlock:^{
            self.scoreLabel.fontColor = [UIColor sn_redColor];
        }];
        SKAction *white = [SKAction runBlock:^{
            self.scoreLabel.fontColor = [UIColor whiteColor];
        }];
        SKAction *delay = [SKAction waitForDuration:0.1];
        [self.scoreLabel runAction:[SKAction sequence:@[red, delay, white, delay, red, delay, white]]];
        
    }
    _score = score;
}

- (IBAction)pausePressed
{
    NSParameterAssert(self.delegate);
    [self.delegate pausePressed];
}

- (CGFloat)fontSizeForHeightConstraint:(CGFloat)maxHeight
{
    NSString *test = @"Wx|g";
    BOOL found = NO;
    CGFloat currentFontSize = 48;
    
    while (!found) {
        if ([test sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:currentFontSize]}].height < maxHeight) found = YES;
        else currentFontSize--;
    }
    
    return currentFontSize;
}

@end
