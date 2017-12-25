//
//  SNNumericInputView.h
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 13/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNNumericInputViewDelegate <NSObject>

- (BOOL)didChangeInputString:(NSString *)inputString;

@end

@interface SNNumericInputView : UIView

@property (weak, nonatomic) id<SNNumericInputViewDelegate> delegate;

@end
