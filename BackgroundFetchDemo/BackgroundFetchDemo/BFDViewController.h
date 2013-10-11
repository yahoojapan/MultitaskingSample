//
//  BFDViewController.h
//  BackgroundFetchDemo
//
//  Created by Ryosuke Hiramatsu (rhiramat@yahoo-corp.jp) on 2013/09/23.
//  Copyright (c) 2013年 Yahoo! JAPAN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CRefreshCompletionHandler)(BOOL didReceiveNewPosts);

@interface BFDViewController : UIViewController

- (void)refreshWithCompletionHandler:(CRefreshCompletionHandler)completionHandler;

@end
