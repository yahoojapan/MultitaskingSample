//
//  BTDViewController.m
//  BackgroundTransferDemo
//
//  Created by Ryosuke Hiramatsu (rhiramat@yahoo-corp.jp) on 2013/09/23.
//  Copyright (c) 2013年 Yahoo! JAPAN. All rights reserved.
//

#import "BTDViewController.h"
#import "BTDAppDelegate.h"

#warning ready download url
static NSString *DownloadURLString = @"XXXXXXXXXX";


@interface BTDViewController ()
<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation BTDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // セッションの準備
    self.session = [self backgroundSession];
}


#pragma mark - IBAction

- (IBAction)downloadBtnTouched:(id)sender {
    NSLog(@"downloadBtnTouched");
    
    // 既にダウンロードが開始してれば何もしない
    if (self.downloadTask) {
        return;
    }
    
    NSURL *donwloadURL = [NSURL URLWithString:DownloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:donwloadURL];
    
    // ダウンロード開始
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
}


// backgroundSessionの準備
- (NSURLSession *)backgroundSession
{
	static NSURLSession *session = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        // IDを指定してConfigurationを設定
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration
                                                    backgroundSessionConfiguration:@"jp.co.yahoo.BackgroundTransferDemo"];
		session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
	});
	return session;
}

// completed
- (void)checkForAllDownloadsHavingCompleted
{
    NSLog(@"checkForAllDownloadsHavingCompleted");
    
	[self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
		NSUInteger count = [dataTasks count] + [uploadTasks count] + [downloadTasks count];
		if (count == 0)
        {
            // すべてのタスクが終了していれば完了とみなす
			NSLog(@"All tasks are finished");
			BTDAppDelegate *appDelegate = (BTDAppDelegate *)[[UIApplication sharedApplication] delegate];
            
			if (appDelegate.backgroundSessionCompletionHandler) {
				void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
				appDelegate.backgroundSessionCompletionHandler = nil;
				completionHandler();
                
                // 完了時にバッジをつける
                [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
			}
		}
	}];
}


// 読み込み中
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"didWriteData");
    
    if (downloadTask == self.downloadTask)
    {
        NSLog(@"progress[%f / %f]", (double)totalBytesWritten, (double)totalBytesExpectedToWrite);
    }
}


// 読み込み完了
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL
{
    NSLog(@"didFinishDownloadingToURL");
    
    // ファイルを保存する
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    
    NSURL *originalURL = [[downloadTask originalRequest] URL];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
    NSError *errorCopy;
    
    // For the purposes of testing, remove any esisting file at the destination.
    [fileManager removeItemAtURL:destinationURL error:NULL];
    BOOL success = [fileManager copyItemAtURL:downloadURL toURL:destinationURL error:&errorCopy];
    
    if (success)
    {
        // ローカルへ保存した画像ファイルを表示する
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationURL path]];
            self.imageView.image = image;
        });
    }
    else
    {
        NSLog(@"エラーが発生しました");
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
    
    if (error == nil)
    {
        NSLog(@"Task: %@ completed successfully", task);
    }
    else
    {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }
	
    NSLog(@"progress[%f / %f]", (double)task.countOfBytesReceived, (double)task.countOfBytesExpectedToReceive);
    
    self.downloadTask = nil;
	[self checkForAllDownloadsHavingCompleted];
}


// レジューム
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"didResumeAtOffset");
}




@end
