//
//  AppDelegate.m
//  NotificationsIOS8
//
//  Created by APP559 on 2014/6/30.
//  Copyright (c) 2014年 yume. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
            

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings
                                              settingsForTypes:types categories:[self prepareCategories]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    for (int index = 1; index <= 4; index++) {
        notification.fireDate = [[NSDate date] dateByAddingTimeInterval:index * 5];
        notification.alertBody = @"IOS 8 Notification";
        notification.category = @"INVITE_CATEGORY";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notification Callback

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // user has allowed receiving user notifications of the following types
    UIUserNotificationType allowedTypes = [notificationSettings types];
}

#pragma mark - Notification Process

//- (void)getReadyForNotification {
//    // ...
//    
//    // check to make sure we still need to show notification
//    UIUserNotificationSettings *currentSettings = [[UIApplication
//                                                    sharedApplication] currentUserNotificationSettings];
//    [self checkSettings:currentSettings];
//}

#pragma mark - Prepare Actions -> Group into Category

-(NSSet *)prepareCategories{
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];

    acceptAction.identifier = @"ACCEPT_IDENTIFIER";

    acceptAction.title = @"Accept";

    // Given seconds, not minutes, to run in the background
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    acceptAction.destructive = NO;

    // If YES requires passcode, but does not unlock the device
    acceptAction.authenticationRequired = NO;
    
    
    UIMutableUserNotificationAction *maybeAction = [[UIMutableUserNotificationAction alloc] init];
    maybeAction.identifier = @"MAYBE_IDENTIFIER";
    maybeAction.title = @"Maybe";
    maybeAction.activationMode = UIUserNotificationActivationModeBackground;
    maybeAction.destructive = NO;
    maybeAction.authenticationRequired = NO;
    
    
    UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
    declineAction.identifier = @"ACCEPT_IDENTIFIER";
    declineAction.title = @"Accept";
    declineAction.activationMode = UIUserNotificationActivationModeForeground;
    declineAction.destructive = YES;
    declineAction.authenticationRequired = YES;
    
    
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction, maybeAction, declineAction]
                    forContext:UIUserNotificationActionContextDefault];
    
//    NSSet *categories = [NSSet setWithObjects:inviteCategory, alarmCategory, ...
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    return categories;
}
@end
