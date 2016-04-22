//
//  ZURLSessionDownLoadManager.m
//  URLSessionDownLoadManager
//
//  Created by yixin on 16/4/22.
//  Copyright © 2016年 com.z. All rights reserved.
//

#import "ZURLSessionDownLoadManager.h"
#import "CommenMethod.h"
#import "AppDelegate.h"
#define WeakObj(obj) __weak typeof(obj) Weak##obj = obj;
@implementation ZURLSessionDownLoadManager
{
    long long TotalLength;
}
#pragma mark - package method
- (NSURLSession *)GetbackgroundSession
{
    NSURLSession *session = nil;
    NSURLSessionConfiguration *configuration;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[@"com.z" stringByAppendingString:[CommenMethod getCurrentTime]]];
    } else {
        configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:[@"com.z" stringByAppendingString:[CommenMethod getCurrentTime]]];
    }
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    return session;
}
#pragma mark - initial method
- (id)initWithRequest:(NSURLRequest *)request TargetPath:(NSString *)tarPath folderName:(NSString *)folderName fileName:(NSString *)fileName Type:(NSString *)type
{
    if (self= [super init]) {
        self.destinationPath = [NSString stringWithFormat:@"%@/%@/%@%@",tarPath,folderName,fileName,type];
        self.request = [NSURLRequest requestWithURL:request.URL];
        [[NSURLCache sharedURLCache]removeCachedResponseForRequest:request];
        self.responseData=[NSMutableData data];
        self.backgroundSession = [self GetbackgroundSession];
        self.downloadTask = [_backgroundSession downloadTaskWithRequest:request];
        [self.downloadTask resume];
    }
    return  self;
}
#pragma mark - progress
- (void)setRequestDownloadProgressBlock:(void (^)(ZURLSessionDownLoadManager *, float, long long))block SuccessBlock:(DownSucessBlock)success FailedBlock:(DownFaildBlock)failed
{
    self.DownLoadProgressBlock = block;
    self.DownSucessBlock = success;
    self.DownFaildBlock = failed;
}

#pragma mark - NSURLSessionDownloadDelegate

//这个方法用来跟踪下载数据并且根据进度刷新ProgressView
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (downloadTask == self.downloadTask) {
        if (self.DownSucessBlock) {
            float progress = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
            self.DownLoadProgressBlock(self,progress,TotalLength);
        }
        TotalLength = totalBytesExpectedToWrite;
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%@",[location description]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL = [NSURL fileURLWithPath:_destinationPath];
    NSError *errorCopy;
    [fileManager removeItemAtPath:[destinationURL absoluteString] error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationURL error:&errorCopy];
    NSLog(@"_destinationPath:::::::::::::::::::%@",_destinationPath);
    [fileManager removeItemAtURL:location error:NULL];
    WeakObj(self)
    if (self.DownSucessBlock&&success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Weakself.DownSucessBlock(Weakself);
        });
    } else {
        //NSLog(@"复制文件发生错误: %@", [errorCopy localizedDescription]);
    }
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error == nil) {
        NSLog(@"任务: %@ 成功完成", task);
        if (self.DownSucessBlock) {
        }
    } else {
        NSLog(@"任务: %@ 发生错误: %@", task, [error localizedDescription]);
        if (self.DownFaildBlock) {
            self.DownFaildBlock(self);
        }
    }
    self.downloadTask = nil;
}

#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    NSLog(@"所有任务已完成!");
}
#pragma mark - 暂停下载
- (void) pause
{
    //暂停
    NSLog(@"暂停下载");
    [_downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        self.responseData = [resumeData mutableCopy];
    }];
    _downloadTask=nil;
}
#pragma mark - 恢复下载
- (void) resume
{
    //恢复
    NSLog(@"恢复下载");
    if(!self.responseData){
        _downloadTask=[_backgroundSession downloadTaskWithRequest:_request];
    }else{
        _downloadTask=[_backgroundSession downloadTaskWithResumeData:self.responseData];
    }
    [_downloadTask resume];
}


@end
