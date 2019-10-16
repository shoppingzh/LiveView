//
//  AppDelegate.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import "MainUI.h"
#import "MessageUI.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [MainUI new];
    [self.window makeKeyAndVisible];
    
    // IQKeyboardManager设置
    IQKeyboardManager *km = [IQKeyboardManager sharedManager];
    km.enable = YES;
    km.enableAutoToolbar = NO; // 隐藏键盘上方的工具栏
    km.shouldResignOnTouchOutside = YES; // 点击外部收回键盘
    
    return YES;
}
@end
