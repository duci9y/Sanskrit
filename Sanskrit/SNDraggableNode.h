//
//  SNDraggableNode.h
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 14/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SNDraggableNode;

@protocol SNDraggableNodeDelegate <NSObject>

- (void)draggableNode:(SKNode *)node didBeginDraggingFromPoint:(CGPoint)point;
- (void)draggableNode:(SKNode *)node didMoveTouchToPoint:(CGPoint)point;
- (void)draggableNode:(SKNode *)node didEndTouchAtPoint:(CGPoint)point;

@end

@interface SNDraggableNode : SKSpriteNode

@property (nonatomic, getter = isDragging, readonly) BOOL dragging;
@property (weak, nonatomic) id delegate;

@end

@interface SNDraggableShapeNode : SKShapeNode

@property (nonatomic, getter = isDragging, readonly) BOOL dragging;
@property (weak, nonatomic) id delegate;

@end
