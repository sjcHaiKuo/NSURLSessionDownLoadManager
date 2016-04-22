//
//  ZURLSessionDownLoadManager.h
//  URLSessionDownLoadManager
//
//  Created by yixin on 16/4/22.
//  Copyright © 2016年 com.z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZURLSessionDownLoadManager : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

typedef void (^DownLoadProgressBlock)(ZURLSessionDownLoadManager *manager, float progress, long long totalBytes);

typedef void (^DownSucessBlock)(ZURLSessionDownLoadManager *manager);

typedef void (^DownFaildBlock)(ZURLSessionDownLoadManager *manager);
/**
 *  Description session
 */
@property (nonatomic, strong) NSURLSession *backgroundSession;
/**
 *  Description 下载任务
 */
@property (nonatomic, strong)NSURLSessionDownloadTask *downloadTask;
/**
 *  Description 进度回调block
 */
@property (nonatomic, copy) DownLoadProgressBlock DownLoadProgressBlock;
/**
 *  Description 成功回调block
 */
@property (nonatomic, copy) DownSucessBlock DownSucessBlock;
/**
 *  Description 失败回调block
 */
@property (nonatomic, copy) DownFaildBlock DownFaildBlock;
/**
 *  Description 暂停保存的data
 */
@property (nonatomic, retain) NSMutableData *responseData;
/**
 *  Description 发起请求的request
 */
@property (nonatomic, strong) NSURLRequest *request;
/**
 *  Description 目标最终路径
 */
@property (nonatomic, copy) NSString *destinationPath;
/**
 *  Description       初始化方法
 *
 *  @param request    下载request
 *  @param tarPath    NSSearchPathForDirectoriesInDomains下的路径
 *  @param folderName 文件夹名称
 *  @param fileName   文件名称
 *  @param type       文件类型 即扩展名后缀
 *
 *  @return self
 */
- (id)initWithRequest:(NSURLRequest *)request TargetPath:(NSString *)tarPath folderName:(NSString *)folderName fileName:(NSString *)fileName Type:(NSString *)type;
/**
 *  Description    进度回调方法
 *
 *  @param block   进度回调block
 *  @param success 成功回调block
 *  @param failed  失败回调block
 */
- (void)setRequestDownloadProgressBlock:(void (^)(ZURLSessionDownLoadManager *manager,float Progress,long long totalBytes))block
                           SuccessBlock:(DownSucessBlock)success
                            FailedBlock:(DownFaildBlock) failed;
/**
 *  Description 暂停下载
 */
- (void) pause;
/**
 *  Description 恢复下载
 */
- (void) resume;

@end
