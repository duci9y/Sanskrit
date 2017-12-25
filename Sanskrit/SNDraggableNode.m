//
//  SNDraggableNode.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 14/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNDraggableNode.h"

@interface SNDraggableNode ()
@property (nonatomic, readwrite) BOOL dragging;
@property (weak, nonatomic) UITouch *touch;
@end

@implementation SNDraggableNode

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touch) return;
    
    self.dragging = YES;
    
    self.touch = touches.anyObject;
    [self.delegate draggableNode:self didBeginDraggingFromPoint:[self.touch locationInNode:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.touch) return;
    
    [self.delegate draggableNode:self didMoveTouchToPoint:[self.touch locationInNode:self]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.touch) return;
    
    self.dragging = NO;
    [self.delegate draggableNode:self didEndTouchAtPoint:[self.touch locationInNode:self]];
    self.touch = nil;
}

@end

@interface SNDraggableShapeNode ()
@property (nonatomic, readwrite) BOOL dragging;
@property (weak, nonatomic) UITouch *touch;
@end

@implementation SNDraggableShapeNode

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touch) return;
    
    self.dragging = YES;
    
    self.touch = touches.anyObject;
    [self.delegate draggableNode:self didBeginDraggingFromPoint:[self.touch locationInNode:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.touch) return;
    
    [self.delegate draggableNode:self didMoveTouchToPoint:[self.touch locationInNode:self]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.touch) return;
    
    self.dragging = NO;
    [self.delegate draggableNode:self didEndTouchAtPoint:[self.touch locationInNode:self]];
    self.touch = nil;
}

@end
