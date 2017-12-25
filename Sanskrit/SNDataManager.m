//
//  SNDataManager.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 11/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import "SNDataManager.h"
#import "CHCSVParser.h"
#import "UIColor+SNColors.h"

@interface SNDataManager ()
@property (strong, nonatomic) NSDictionary *numbersData;
@property (strong, nonatomic) NSArray *sentences;
@property (strong, nonatomic) NSArray *colours;
@end

@implementation SNDataManager

- (id)init
{
    if (self = [super init]) {
        NSArray *text = [NSArray arrayWithContentsOfCSVFile:[[NSBundle mainBundle] pathForResource:@"Numbers" ofType:@"csv"]];
        NSMutableDictionary *numbers = [NSMutableDictionary dictionary];
        
        for (NSArray *keyValue in text) {
            numbers[@([keyValue.firstObject intValue])] = keyValue.lastObject;
        }
        
        self.numbersData = numbers.copy;

        @try {
            self.sentences = [NSArray arrayWithContentsOfCSVFile:[[NSBundle mainBundle] pathForResource:@"Sentences" ofType:@"csv"]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            if (!self.sentences) self.sentences = nil;
        }
        
        self.colours = [NSArray arrayWithContentsOfCSVFile:[[NSBundle mainBundle] pathForResource:@"Colours" ofType:@"csv"]];
    }
    return self;
}

- (void)saveScoreForNumbersGame:(NSInteger)score
{
    [self saveScore:score withKey:@"numbersGameScores"];
}

- (void)saveScoreForJumbledGame:(NSInteger)score
{
    [self saveScore:score withKey:@"jumbledGameScores"];
}

- (void)saveScoreForColoursGame:(NSInteger)score
{
    [self saveScore:score withKey:@"coloursGameScores"];
}

- (void)saveScore:(NSInteger)score withKey:(NSString *)key
{
    NSMutableArray *scores = [[NSUserDefaults standardUserDefaults] arrayForKey:key].mutableCopy;
    if (!scores) scores = [NSMutableArray array];
    [scores addObject:@(score)];
    [scores sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]];
    
    NSArray *toSave = [scores subarrayWithRange:NSMakeRange(0, (scores.count > 10 ? 10 : scores.count))];
    [[NSUserDefaults standardUserDefaults] setObject:toSave forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)randomNumberForDifficulty:(NSUInteger)difficulty
{
    NSUInteger number = arc4random() % ((difficulty * 20) + 1);
    if (!number) number = 1;
    
    return @[@(number), self.numbersData[@(number)]];
}

- (NSArray *)randomSentence
{
    NSUInteger index = arc4random() % self.sentences.count;
    return [self.sentences[index][0] componentsSeparatedByString:@" "];
}

- (NSArray *)randomColour
{
    NSUInteger index = arc4random() % self.colours.count;
    return self.colours[index];
}

+ (SNDataManager *)sharedInstance
{
    static SNDataManager *sharedInstance;
    if (!sharedInstance) sharedInstance = [[SNDataManager alloc] init];
    return sharedInstance;
}

@end
