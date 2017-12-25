//
//  SNMyScene.h
//  Sanskrit
//

//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SNNumericInputView.h"
#import "SNScene.h"

@interface SNNumbersScene : SNScene <SNNumericInputViewDelegate>
@property (weak, nonatomic) id<SNSceneDelegate> delegate;
@end
