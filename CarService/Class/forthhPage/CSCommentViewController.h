//
//  CSCommentViewController.h
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface CSCommentViewController : CommonViewController<UIGestureRecognizerDelegate>

@property (nonatomic,retain) NSDictionary *orderInfoDic;

- (IBAction)commentButtonPressed:(id)sender;
- (IBAction)starButtonPressed:(id)sender;

@end
