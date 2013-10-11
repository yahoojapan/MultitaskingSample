//
//  BTDAppDelegate.h
//  BackgroundTransferDemo
//
//  Created by Ryosuke Hiramatsu (rhiramat@yahoo-corp.jp) on 2013/09/23.
//  Copyright (c) 2013年 Yahoo! JAPAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy) void (^backgroundSessionCompletionHandler)();

@end
