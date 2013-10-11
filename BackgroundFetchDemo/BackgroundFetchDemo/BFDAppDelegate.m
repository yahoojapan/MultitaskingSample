//
//  BFDAppDelegate.m
//  BackgroundFetchDemo
//
//  Created by Ryosuke Hiramatsu (rhiramat@yahoo-corp.jp) on 2013/09/23.
//  Copyright (c) 2013年 Yahoo! JAPAN. All rights reserved.
//

#import "BFDAppDelegate.h"

@implementation BFDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Background Fetchが呼ばれる「最短の間隔」をセット
    // 必ずしもこの間隔で呼ばれるのではないので注意
    // "UIApplicationBackgroundFetchIntervalMinimum" はOSが設定する最短時間を意味する
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:
     UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

// Background Fetch用の処理メソッド
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Background Fetchが呼ばれた");
    
    // 表示中のviewControllerを取得
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    self.viewController = navController.viewControllers[0];
    
    // 更新処理を呼ぶ
    [self.viewController refreshWithCompletionHandler:^(BOOL didReceiveNewPosts) {
        if (didReceiveNewPosts) {
            completionHandler(UIBackgroundFetchResultNewData);
        }
        else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    }];
}


@end
