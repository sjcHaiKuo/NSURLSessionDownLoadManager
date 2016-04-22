//
//  AppDelegate.h
//  URLSessionDownLoadManager
//
//  Created by yixin on 16/4/22.
//  Copyright © 2016年 com.z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void (^backgroundSessionCompletionHandler)();

@end

