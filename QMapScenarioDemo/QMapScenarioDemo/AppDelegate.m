//
//  AppDelegate.m
//  QMapScenarioDemo
//
//  Created by KeithCao on 2022/10/17.
//

#import "AppDelegate.h"
#import "EntryViewController.h"
#import <QMapKit/QMapKit.h>
#import <QMapKit/QMSSearchKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Configure API Key.
    [QMapServices sharedServices].APIKey = @"您的Key";
    [QMSSearchServices sharedServices].apiKey = @"您的Key";
    
    if ([QMapServices sharedServices].APIKey.length == 0 || [QMSSearchServices sharedServices].apiKey.length == 0)
    {
        NSLog(@"Please configure API key before using QMapKit.framework");
    }
    
    EntryViewController *entry = [[EntryViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entry];
    
    self.window.rootViewController = navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // 隐私协议开关，since 4.5.6
    [[QMapServices sharedServices] setPrivacyAgreement:YES];
    
    return YES;
}



@end
