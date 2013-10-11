//
//  SPDViewController.h
//  SilentPushDemo
//
//  Created by Ryosuke Hiramatsu (rhiramat@yahoo-corp.jp) on 2013/09/23.
//  Copyright (c) 2013年 Yahoo! JAPAN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CRefreshCompletionHandler)(BOOL didReceiveNewPosts);

@interface SPDViewController : UIViewController

- (void)refreshWithCompletionHandler:(CRefreshCompletionHandler)completionHandler;

@end
