//
//  ViewController.m
//  URLSessionDownLoadManager
//
//  Created by yixin on 16/4/22.
//  Copyright © 2016年 com.z. All rights reserved.
//

#import "ViewController.h"
#import "ZURLSessionDownLoadManager.h"
#import "SVProgressHUD.h"
@interface ViewController ()
{
    ZURLSessionDownLoadManager *manager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)download:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://devstreaming.apple.com/videos/wwdc/2015/1026npwuy2crj2xyuq11/102/102_platforms_state_of_the_union.pdf?dl=1"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    manager = [[ZURLSessionDownLoadManager alloc]initWithRequest:request TargetPath:paths[0] folderName:@"PDF" fileName:@"WWDC" Type:@".pdf"];
    [manager setRequestDownloadProgressBlock:^(ZURLSessionDownLoadManager *manager, float Progress, long long totalBytes) {
        [SVProgressHUD showProgress:Progress];
    } SuccessBlock:^(ZURLSessionDownLoadManager *manager) {
        [SVProgressHUD showSuccessWithStatus:@"下载成功"];
    } FailedBlock:^(ZURLSessionDownLoadManager *manager) {
        if (manager.downloadTask.state > 3) {//0 1 2 3分别代表正在下载、暂停、取消、完成
            [SVProgressHUD showSuccessWithStatus:@"下载失败"];
        }
    }];
}

- (IBAction)pause:(id)sender {
    [manager pause];
}

- (IBAction)resume:(id)sender {
    [manager resume];
}

@end
