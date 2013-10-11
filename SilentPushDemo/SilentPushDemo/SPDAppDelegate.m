//
//  SPDAppDelegate.m
//  SilentPushDemo
//
//  Created by Ryosuke Hiramatsu (rhiramat@yahoo-corp.jp) on 2013/09/23.
//  Copyright (c) 2013年 Yahoo! JAPAN. All rights reserved.
//

#import "SPDAppDelegate.h"

@implementation SPDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // PUSH通知を登録
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge|
      UIRemoteNotificationTypeSound|
      UIRemoteNotificationTypeAlert)];
    
    return YES;
}
							
// デバイストークン発行成功
- (void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken{
    // デバイストークンを登録
}

// デバイストークン発行失敗
- (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)err{
    // エラー処理
}

// 通常のpushから起動
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 処理
}

// silent pushから起動
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 処理
    
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
