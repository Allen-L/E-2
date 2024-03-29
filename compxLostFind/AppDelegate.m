//
//  AppDelegate.m
//  compxLostFind
//
//  Created by Compx on 14-5-1.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "SetViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RootViewController *rootVC=[[RootViewController alloc]init];
    UINavigationController *rootNAV=[[UINavigationController alloc]initWithRootViewController:rootVC];
    [rootNAV setNavigationBarHidden:YES animated:NO];
    
    
    
    
    //申明需要后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    
    
    SetViewController *setVC=[[SetViewController alloc]init];
    UINavigationController *setVcNAV=[[UINavigationController alloc] initWithRootViewController:setVC];
    [setVcNAV setNavigationBarHidden:YES animated:NO];
    
    
    
    self.window.rootViewController=rootNAV;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    application.applicationIconBadgeNumber = 0;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
    if (notification) {
        NSDictionary *userInfo =  notification.userInfo;
        NSString *obj = [userInfo objectForKey:@"key"];
        NSLog(@"%@",obj);
    }
}


@end
