//
//  SNNumericInputView.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 13/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNNumericInputView.h"
#import "UIColor+SNColors.h"

@interface SNNumericInputView ()
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (strong, nonatomic) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic) IBOutlet UIButton *crossButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (strong, nonatomic) IBOutlet UIButton *draggableButton;

@property (nonatomic) BOOL dragging;
@end

@implementation SNNumericInputView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *rootView = [[NSBundle mainBundle] loadNibNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"SNNumericInputView_iPad" : @"SNNumericInputView_iPhone") owner:self options:nil].firstObject;
    [self addSubview:rootView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[root]|" options:0 metrics:nil views:@{@"root": self.rootView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[root]|" options:0 metrics:nil views:@{@"root": self.rootView}]];
    self.rootView.translatesAutoresizingMaskIntoConstraints = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.buttonWidthConstraint.constant = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 96 : 72;
    
    [self.displayLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    self.displayLabel.text = @" ";
    
    self.leftConstraint.constant = self.bounds.size.width / 2 - ((self.buttonWidthConstraint.constant * 3 + 2) / 2);
    
    for (UIButton *button in self.buttons) {
        button.backgroundColor = [UIColor sn_buttonColor];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.draggableButton pointInside:[touches.anyObject locationInView:self.draggableButton] withEvent:event]) {
        self.dragging = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.dragging) {
        if ([touches.anyObject locationInView:self].x > self.bounds.size.width - 3 * self.buttonWidthConstraint.constant) return;
        if ([touches.anyObject locationInView:self].x < 8 + self.buttonWidthConstraint.constant / 2) return;
        [UIView animateWithDuration:0.05 animations:^{
            self.leftConstraint.constant = [touches.anyObject locationInView:self].x - self.draggableButton.frame.size.width / 2;
        }];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.dragging) {
        if ([touches.anyObject locationInView:self].x > self.bounds.size.width - 3 * self.buttonWidthConstraint.constant) return;
        if ([touches.anyObject locationInView:self].x < 8 + self.buttonWidthConstraint.constant / 2) return;
        [UIView animateWithDuration:0.05 animations:^{
            self.leftConstraint.constant = [touches.anyObject locationInView:self].x - self.draggableButton.frame.size.width / 2;
        }];
    }

    self.dragging = NO;
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if (![self.delegate respondsToSelector:@selector(didChangeInputString:)]) return;
    if ([self.displayLabel.text isEqualToString:@" "]) self.displayLabel.text = @"";
    
    self.displayLabel.text = [self.displayLabel.text stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    
    [self.displayLabel.layer removeAnimationForKey:@"evaporate"];
    [self.displayLabel.layer removeAnimationForKey:@"shake"];
}

- (IBAction)crossPressed:(UIButton *)sender {
    self.displayLabel.text = @" ";
}

- (IBAction)enterPressed:(UIButton  *)sender {
    if ([self.delegate didChangeInputString:self.displayLabel.text]) {
        CATransition *fade = [CATransition animation];
        fade.duration = 0.0;
        fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        fade.type = kCATransitionFade;
        fade.delegate = self;
        
        [self.displayLabel.layer addAnimation:fade forKey:@"pushUp"];
        
        self.displayLabel.textColor = [UIColor sn_greenColor];
    }
    else {
        self.displayLabel.textColor = [UIColor sn_redColor];
        
        CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        keyframe.duration = 1.2;
        keyframe.values = @[@0, @16, @-16, @16, @-16, @16, @0];
        keyframe.keyTimes = @[@0.0, @(1/7.0), @(2/7.0), @(3/7.0), @(4/7.0), @(5/7.0), @(5.5/7.0), @1.0];
        keyframe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        [self.displayLabel.layer addAnimation:keyframe forKey:@"shake"];
        
        [UIView animateWithDuration:0.1 delay:keyframe.duration - 0.5 options:0 animations:^{
            self.displayLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.displayLabel.textColor = [UIColor blackColor];
            self.displayLabel.text = @" ";
            self.displayLabel.alpha = 1.0;
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        CATransition *pushAway = [CATransition animation];
        pushAway.duration = 0.4;
        pushAway.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        pushAway.type = kCATransitionPush;
        pushAway.subtype = kCATransitionFromTop;
        
        [self.displayLabel.layer addAnimation:pushAway forKey:@"evaporate"];
        
        self.displayLabel.text = @" ";
        self.displayLabel.textColor = [UIColor blackColor];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"])
        self.crossButton.hidden = ![self.displayLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

- (void)dealloc
{
    [self.displayLabel removeObserver:self forKeyPath:@"text"];
}

@end
