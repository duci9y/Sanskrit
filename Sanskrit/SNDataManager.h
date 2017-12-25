//
//  SNDataManager.h
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 11/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNDataManager : NSObject

- (NSArray *)randomNumberForDifficulty:(NSUInteger)difficulty;

- (NSArray *)randomSentence;

- (NSArray *)randomColour;

+ (SNDataManager *)sharedInstance;

- (void)saveScoreForNumbersGame:(NSInteger)score;
- (void)saveScoreForJumbledGame:(NSInteger)score;
- (void)saveScoreForColoursGame:(NSInteger)score;

@end
