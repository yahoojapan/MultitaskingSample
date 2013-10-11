//
//  SPDViewController.m
//  SilentPushDemo
//
//  Created by Ryosuke Hiramatsu (rhiramat@yahoo-corp.jp) on 2013/09/23.
//  Copyright (c) 2013年 Yahoo! JAPAN. All rights reserved.
//

#import "SPDViewController.h"

@interface SPDViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *dataList;

@end

@implementation SPDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataList = @[].mutableCopy;
}

- (void)refreshWithCompletionHandler:(CRefreshCompletionHandler)completionHandler {
    // サーバにデータを問い合わせるなど、コンテンツ更新処理をここに
    
    // このサンプルではダミーとして、更新した日時をデータに追加する
    [_dataList addObject:[NSDate date]];
    [self.tableView reloadData];
    
    NSLog(@"データを更新しました");
    
    // 更新結果をcompletionHandlerに渡す
    completionHandler(YES);
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self dateToStr:_dataList[indexPath.row]];
    
    return cell;
}

- (NSString *)dateToStr:(NSDate *)date {
    // NSDate -> NSString
    NSDateFormatter *outputFormatter = NSDateFormatter.new;
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [outputFormatter stringFromDate:date];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // do nothing
}


@end
