//
//  SNJumbledScene.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 14/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNJumbledScene.h"
#import "SNDraggableNode.h"
#import "SNDataManager.h"
#import "NSMutableArray+Shuffle.h"
#import "UIColor+SNColors.h"
#import "SNHeaderNode.h"

@interface SNJumbledScene () <SNDraggableNodeDelegate>
@property (strong, nonatomic) NSArray *sentence;
@property (strong, nonatomic) NSMutableArray *grid;
@property (nonatomic) NSInteger dragging;
@property (nonatomic) CGFloat totalSize;
@property (nonatomic) NSInteger score;
@end

@implementation SNJumbledScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.header.showsTimer = YES;
        self.header.showsScore = YES;
        self.header.timer = 15;
        [self initSentence];
    }
    return self;
}

- (void)initSentence
{
    self.totalSize = 0;
    
    self.sentence = [[SNDataManager sharedInstance] randomSentence];
    [self initGrid];
    
    CGFloat fontSize = [self calculateFontSizeForSentence:[self.sentence componentsJoinedByString:@" "]];
    
    for (SNDraggableNode *node in self.children) {
        if ([node isKindOfClass:[SNDraggableNode class]]) {
            [node runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:0.1], [SKAction removeFromParent]]]];
        }
    }
    
    for (NSString *word in self.sentence) {
        SNDraggableNode *node = [SNDraggableNode spriteNodeWithColor:[UIColor sn_redColor] size:CGSizeMake(100, 50)];
        CGSize size = [word sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:fontSize]}];
        size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(1.0, 1.2));
        size.width += UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 12 : 6;
        node.size = size;
        
        node.delegate = self;
        node.userInteractionEnabled = YES;
        node.name = word;
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        label.fontColor = [UIColor whiteColor];
        label.fontSize = fontSize;
        label.text = word;
        
        label.position = CGPointMake(0, (label.fontSize / -3));
        
        [node addChild:label];
        
        node.position = CGPointMake(CGRectGetMidX(self.frame), -100);
        
        [self addChild:node];
        
        self.totalSize += node.size.width;
    }
}

- (void)setScore:(NSInteger)score
{
    [super setScore:score];
    self.header.score = score;
}

- (CGFloat)calculateFontSizeForSentence:(NSString *)sentence
{
    CGFloat maxSize = 42;
    BOOL stop = NO;
    CGFloat currentSize = maxSize;
    
    while (!stop) {
        CGSize size = [sentence sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:currentSize]}];
        size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(1.0, 1.2));
        size.width += UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 12 : 6;
        if (size.width < self.size.width - 16) stop = YES;
        else currentSize--;
    }
    
    return currentSize;
}

- (void)initGrid
{
    self.grid = [NSMutableArray arrayWithArray:self.sentence];
    [self.grid shuffle];
}

- (void)update:(NSTimeInterval)currentTime
{
    if (self.paused) return;
    static NSTimeInterval previousTime;
    
    if (currentTime - previousTime > 1.0) {
        previousTime = currentTime;
        self.header.timer--;
    }
    
    [self.grid sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [@([self nodeWithName:obj1].position.x) compare:@([self nodeWithName:obj2].position.x)];
    }];
    
    CGFloat xPos = (self.size.width - self.totalSize) / 2;
    CGFloat yPos = CGRectGetMidY(self.frame);
    
    for (NSString *word in self.grid) {
        SNDraggableNode *draggableNode = (SNDraggableNode *)[self nodeWithName:word];

        if (!draggableNode.dragging) {
            [draggableNode runAction:[SKAction moveTo:CGPointMake(xPos + draggableNode.size.width / 2, yPos) duration:0.1]];
        }
        xPos += draggableNode.size.width;
    }
    
    static BOOL isGreen = NO;
    
    if ([self.grid isEqualToArray:self.sentence] && !isGreen && !self.dragging) {
        isGreen = YES;
        for (SNDraggableNode *node in self.children) {
            if ([node isKindOfClass:[SNDraggableNode class]]) [node runAction:[SKAction colorizeWithColor:[UIColor sn_greenColor] colorBlendFactor:1.0 duration:0.15]];
        }
        self.header.timer += 5;
        self.score++;
        [self performSelector:@selector(initSentence) withObject:nil afterDelay:1.0];
    }
    else if (![self.grid isEqualToArray:self.sentence] && isGreen && !self.dragging) {
        isGreen = NO;
        for (SNDraggableNode *node in self.children) {
            if ([node isKindOfClass:[SNDraggableNode class]]) [node runAction:[SKAction colorizeWithColor:[UIColor sn_redColor] colorBlendFactor:1.0 duration:0.15]];
        }
    }
}

- (SKNode *)nodeWithName:(NSString *)name
{
    return [self childNodeWithName:name];
}

- (void)draggableNode:(SNDraggableNode *)node didBeginDraggingFromPoint:(CGPoint)point
{
    self.dragging++;
    node.zPosition = 5;
    [node runAction:[SKAction scaleTo:1.2 duration:0.1]];
    [node runAction:[SKAction moveTo:[self convertPoint:point fromNode:node] duration:0.1]];
}

- (void)draggableNode:(SNDraggableNode *)node didMoveTouchToPoint:(CGPoint)point
{
    [node runAction:[SKAction moveTo:[self convertPoint:point fromNode:node] duration:0.02]];
}

- (void)draggableNode:(SNDraggableNode *)node didEndTouchAtPoint:(CGPoint)point
{
    self.dragging--;
    node.zPosition = 0;
    [node runAction:[SKAction scaleTo:1.0 duration:0.1]];
    [node runAction:[SKAction moveTo:[self convertPoint:point fromNode:node] duration:0.1]];
}

@end
