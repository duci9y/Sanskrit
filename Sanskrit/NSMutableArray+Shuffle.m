//
//  NSMutableArray+Shuffle.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 14/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (void)shuffle
{
    NSInteger count = [self count];
    for (NSInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((UInt32)remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
