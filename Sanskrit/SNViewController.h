//
//  SNViewController.h
//  Sanskrit
//
//  Created by Deepanshu Utkarsh on 15/07/14.
//  Copyright (c) 2014 duci9y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNScene.h"
#import "SNGameOverScene.h"

@interface SNViewController : UIViewController <SNSceneDelegate, SNGameOverSceneDelegate>
@property (strong, nonatomic) IBOutlet SKView *skView;
@property (strong, nonatomic) SKScene *gameScene;
@end
