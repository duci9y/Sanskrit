//
//  main.m
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 11/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SNAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([SNAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            return 0;
        }
    }
}
