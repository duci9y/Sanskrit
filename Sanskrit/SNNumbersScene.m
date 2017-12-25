//
//  SNMyScene.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 11/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNNumbersScene.h"
#import "FBTweakInline.h"
#import "SNDataManager.h"
#import "UIColor+SNColors.h"
#import "SNHeaderNode.h"

@interface SNNumbersScene ()
@property (nonatomic) CGFloat velocity;
@property (nonatomic) BOOL gameOver;
@end

static CGFloat blockWidth, blockHeight;

@implementation SNNumbersScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.gameOver = NO;
        self.physicsWorld.gravity = CGVectorMake(0, FBTweakValue(@"0", @"0", @"Y-axis Gravity", -0.1, -1.0, 0.0));
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, size.height)];
        [path addLineToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(size.width, 0)];
        [path addLineToPoint:CGPointMake(size.width, size.height)];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path.CGPath];
        self.physicsBody.friction = 0.0;
        self.physicsBody.restitution = 0.0;
                
        self.velocity = self.size.height / -5.0;
        
        blockWidth = floor(size.width / 3.0) - 2.0;
        blockHeight = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80 : 40;
                
        [SNDataManager sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePressed) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (NSUInteger)currentDifficulty
{
    if (self.score < 15) return 1;
    if (self.score < 30) return 2;
    if (self.score < 45) return 3;
    if (self.score < 60) return 4;
    else return 5;
}

- (void)update:(CFTimeInterval)currentTime {
    if (self.paused) return;
    static CFTimeInterval previousTime, timeInterval;
    if (!previousTime) previousTime = currentTime;
    if (!timeInterval) timeInterval = FBTweakValue(@"0", @"0", @"Maximum Time Interval", 1.8, 0.0, 5.0);
    if (timeInterval < 0.8) timeInterval = FBTweakValue(@"0", @"0", @"Minimum Time Interval", 1.2, 0.0, 5.0);
    
    if (currentTime - previousTime > timeInterval) {
        NSArray *number = [[SNDataManager sharedInstance] randomNumberForDifficulty:[self currentDifficulty]];
        
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor sn_blockColor] size:CGSizeMake(blockWidth, blockHeight)];
        node.name = @"Block";
        CGFloat deltaX = arc4random() % (int)(self.size.width / 3);
        deltaX *= arc4random() % 2 ? -1 : 1;
        
        node.position = CGPointMake(CGRectGetMidX(self.frame) + deltaX, self.size.height);
        
        node.userData = @{number.firstObject: number.lastObject}.mutableCopy;
        
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
        node.physicsBody.velocity = CGVectorMake(0, self.velocity);
        node.physicsBody.friction = 0.0;
        node.physicsBody.linearDamping = 0.0;
        node.physicsBody.restitution = 0.0;
        node.physicsBody.allowsRotation = NO;
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        label.fontColor = [UIColor blackColor];
        label.fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 48.0 : 24.0;
        label.position = CGPointMake(0, label.fontSize / -3 - 2);
        label.text = number.lastObject;
        [node addChild:label];
        
        [self addChild:node];
        
        previousTime = currentTime;
        
        timeInterval -= FBTweakValue(@"0", @"0", @"Time Interval Decrement", 0.008, 0.0, 0.1);;
    }
    
    if (self.gameOver) return;
    
    [self enumerateChildNodesWithName:@"Block" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.physicsBody.velocity.dy > self.velocity && node.position.y > self.size.height) {
            self.gameOver = YES;
            *stop = YES;
        }
    }];
    
    if (self.gameOver) {
        NSParameterAssert(self.delegate);
        NSParameterAssert([self.delegate respondsToSelector:@selector(gameOverWithScore:)]);
        [self.delegate gameOverWithScore:self.score];
    }
}

- (BOOL)didChangeInputString:(NSString *)inputString
{
    static SKEmitterNode *staticEmitter;
    if (!staticEmitter) staticEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"]];
    
    __block BOOL found = NO;
    [self enumerateChildNodesWithName:@"Block" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.userData[@(inputString.integerValue)]) {
            SKEmitterNode *emitter = [staticEmitter copy];
            emitter.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1.0];
            emitter.position = node.position;
            emitter.physicsBody.velocity = node.physicsBody.velocity;
            [self addChild:emitter];
            
            [node runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:0.25], [SKAction removeFromParent]]]];
            [emitter runAction:[SKAction sequence:@[[SKAction waitForDuration:0.25], [SKAction removeFromParent]]]];

            self.score++;
            
            found = YES;
        }
    }];
    
    if (!found) self.score--;
    
    return found;
}

@end
