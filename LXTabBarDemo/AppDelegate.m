//
//  AppDelegate.m
//  LXTabBarDemo
//
//  Created by lixuepeng on 2023/2/24.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorWithRed:247.f/256.f green:247.f/256.f blue:250.f/256.f alpha:1];
    [self.window makeKeyAndVisible];
    
    MyTabBarController *tab = [[MyTabBarController alloc] init];
    self.window.rootViewController = tab;
    return YES;
}

@end
