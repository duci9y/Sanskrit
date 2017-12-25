//
//  SNColoursScene.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 17/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNColoursScene.h"
#import "SNDraggableNode.h"
#import "SNDataManager.h"
#import "UIColor+SNColors.h"
#import "NSMutableArray+Shuffle.h"

@interface SNColoursScene () <SNDraggableNodeDelegate> {
    BOOL isGreen;
}

@property (nonatomic) NSInteger dragging;
@property (strong, nonatomic) NSArray *colours;

@property (strong, nonatomic) NSMutableArray *colourGridEnglish;
@property (strong, nonatomic) NSMutableArray *colourGridSanskrit;

@end

@implementation SNColoursScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        NSMutableArray *colours = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            NSArray *colour = [[SNDataManager sharedInstance] randomColour];
            while ([colours containsObject:colour]) {
                colour = [[SNDataManager sharedInstance] randomColour];
            }
            [colours addObject:colour];
        }
        
        self.colours = colours.copy;
        
        NSMutableArray *eng = [NSMutableArray array];
        NSMutableArray *san = [NSMutableArray array];
        
        for (NSArray *colour in self.colours) {
            [eng addObject:colour.firstObject];
            [san addObject:[colour.firstObject stringByAppendingString:@"s"]];
        }
        
        [eng shuffle];
        [san shuffle];
        
        self.colourGridEnglish = eng;
        self.colourGridSanskrit = san;
        
        [self initColours];
        
        self.header.showsTimer = YES;
        self.header.showsScore = NO;
        self.header.timer = 30;
    }
    return self;
}

- (CGFloat)calculateFontSizeForWord:(NSString *)sentence
{
    CGFloat maxSize = 42;
    BOOL stop = NO;
    CGFloat currentSize = maxSize;
    CGFloat maxHeight = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60 - 12 : 44 - 6;
    CGFloat maxWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 120 - 16 : 60 - 8;

    while (!stop) {
        CGSize size = [sentence sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:currentSize]}];
        size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(1.0, 1.2));
        size.width += UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 12 : 6;
        if (size.height < maxHeight && size.width < maxWidth) stop = YES;
        else currentSize--;
    }
    
    return currentSize;
}

- (void)initColours
{
    CGFloat fontSize = [self calculateFontSizeForWord:self.colours[0][1]];
    
    for (SNDraggableNode *node in self.children) {
        if ([node isKindOfClass:[SNDraggableNode class]]) {
            [node runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:0.1], [SKAction removeFromParent]]]];
        }
    }
    
    CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 120 : 60;
    CGFloat height = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60 : 44;
    CGFloat side = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80 : 44;
    
    for (NSArray *colour in self.colours) {
        SNDraggableNode *node = [SNDraggableNode spriteNodeWithColor:[UIColor sn_redColor] size:CGSizeMake(width, height)];
        node.name = [colour.firstObject stringByAppendingString:@"s"];
        
        node.delegate = self;
        node.userInteractionEnabled = YES;
        node.name = colour.firstObject;
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        label.fontColor = [UIColor whiteColor];
        label.fontSize = fontSize;
        label.text = colour.lastObject;
        
        label.position = CGPointMake(0, (label.fontSize / -3));
        
        [node addChild:label];
        
        node.position = CGPointMake(CGRectGetMidX(self.frame), -100);
        
        [self addChild:node];
        
        SNDraggableShapeNode *colourNode = [SNDraggableShapeNode node];
        colourNode.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-side / 2, -side / 2, side, side) cornerRadius:side / 2].CGPath;
        colourNode.fillColor = [[UIColor class] performSelector:NSSelectorFromString([colour.firstObject stringByAppendingString:@"Color"])];
        colourNode.strokeColor = [UIColor clearColor];
        colourNode.name = [colour.firstObject stringByAppendingString:@"s"];
        colourNode.delegate = self;
        colourNode.userInteractionEnabled = YES;
        colourNode.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height + 100);
        [self addChild:colourNode];
    }
}
- (void)update:(NSTimeInterval)currentTime
{
    if (self.paused) return;
    static NSTimeInterval previousTime;
    
    if (currentTime - previousTime > 1.0) {
        previousTime = currentTime;
        self.header.timer--;
    }
    
    {
        [self.colourGridSanskrit sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [@([self nodeWithName:obj1].position.x) compare:@([self nodeWithName:obj2].position.x)];
        }];
        
        CGFloat totalWidth = 5 * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80 : 44);
        CGFloat separator = (self.size.width - totalWidth) / 6;
        CGFloat xPos = separator;
        CGFloat yPos = CGRectGetMidY(self.frame) + 80 + 32;
        
        for (NSString *colourName in self.colourGridSanskrit) {
            SNDraggableNode *draggableNode = (SNDraggableNode *)[self nodeWithName:colourName];
            CGFloat width = (draggableNode.dragging ? 1.2 : 1.0) * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80 : 44);
            if (!draggableNode.dragging) {
                [draggableNode runAction:[SKAction moveTo:CGPointMake(xPos + width / 2, yPos) duration:0.1]];
            }
            xPos += width + separator;
        }
    }
    {
        [self.colourGridEnglish sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [@([self nodeWithName:obj1].position.x) compare:@([self nodeWithName:obj2].position.x)];
        }];
        
        CGFloat totalWidth = 5 * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 120 : 60);
        CGFloat separator = (self.size.width - totalWidth) / 6;
        CGFloat xPos = separator;
        CGFloat yPos = CGRectGetMidY(self.frame) - 80 - 32;
        
        for (NSString *colourName in self.colourGridEnglish) {
            SNDraggableNode *draggableNode = (SNDraggableNode *)[self nodeWithName:colourName];
            if (!draggableNode.dragging) {
                [draggableNode runAction:[SKAction moveTo:CGPointMake(xPos + draggableNode.size.width / 2, yPos) duration:0.1]];
            }
            xPos += draggableNode.size.width + separator;
        }
    }
    
    __block BOOL correct = YES;
    
    [self.colourGridEnglish enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if (![[obj stringByAppendingString:@"s"] isEqualToString:self.colourGridSanskrit[idx]]) correct = NO;
    }];
    
    if (correct && !self.dragging && !isGreen) {
        for (NSString *colour in self.colourGridEnglish) {
            isGreen = YES;
            SNDraggableNode *node = (SNDraggableNode *)[self childNodeWithName:colour];
            [node runAction:[SKAction colorizeWithColor:[UIColor sn_greenColor] colorBlendFactor:1.0 duration:0.1]];
        }
        NSInteger score = self.header.timer;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate gameOverWithScore:score];
        });
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
