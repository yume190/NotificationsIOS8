NotificationsIOS8 (WWDC Session 713 What's new in ios notification)
=================

稍微看了一下Session 713(Notification)，這次主要在IOS8新增了一些功能
分別是：
 * User Notifications
 * Notification Actions
 * Remote Notifications
 * Location Notifications

首先，不管是使用 Remote 或者是 Local notification都必須要註冊，並且徵求使用者同意。

Notification 的 type 也跟之前的 Push 一樣分為 Badge, Sound, Alert

Notification 在不同的地方，顯示的Action數量也會不同

|地方                |手勢 |Action數量|
|:-----------------:|:---:|:-------:|
|lock screen        |向左滑|2 actions|
|notification center|向左滑|2 actions|
|banners            |往下拉|2 actions|
|alertview          |無   |4 actions|

Notification 主要有三大步驟

1. Register Action 
 * Action
 * Category
 * Settings
2. Send push Notification or schedule local notification
3. Handle Action

# IOS  7

 * User notifications (sound, badge, banner, alertiview, notification center,lock screen)
 * Silent notifications

# IOS 8
 * User Notifications
 * Notification Actions
 * Remote Notifications
 * Location Notifications

# User Notifications(remote or local notification)

 * Must register to use 
 * Require user approval
 * (必須註冊才能使用，並且徵求使用者同意)

### Register

    UIUserNotificationType types = UIUserNotificationTypeBadge |
      UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings
      settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication]
      registerUserNotificationSettings:mySettings];

---

    //UIApplicationDelegate Callback
     - (void)application:(UIApplication *)application
        didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings {
        // user has allowed receiving user notifications of the following types
        UIUserNotificationType allowedTypes = [notificationSettings types];
    }

---

    //Getting Settings
    - (void)getReadyForNotification {
       // ...
    
       // check to make sure we still need to show notification
       UIUserNotificationSettings *currentSettings = [[UIApplication
           sharedApplication] currentUserNotificationSettings];
       [self checkSettings:currentSettings];
    }

---

# Notification Actions

 * lock screen (left) 2 actions
 * notification center (left) 2 actions
 * banners (pull down) 2 actions
 * alertview 4 actions

## Notification 3個步驟

1. Register Action 
 * Action
 * Category
 * Setting
2. Send push Notification or schedule local notification
3. Handle Action

### Register Action

##### Actions

    UIMutableUserNotificationAction *acceptAction =
    [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    
    acceptAction.title = @"Accept";
    
    // yume
    // you will have on the order of seconds, not minutes, to run
    
    // Given seconds, not minutes, to run in the background 
    acceptAction.activationMode = UIUserNotificationActivationModeBackground; 
    acceptAction.destructive = NO;
    
    // If YES requires passcode, but does not unlock the device 
    acceptAction.authenticationRequired = NO;

---

##### Categories

|Category |Actions               |
|:-------:|:--------------------:|
|Invite   |Accept, Maybe, Decline|
|New mail |Mark as Read, Trash   |
|Tagged   |Like, Comment, Untag  |

    UIMutableUserNotificationCategory *inviteCategory =
    [[UIMutableUserNotificationCategory alloc] init];
    
    // yume
    // You'll include this identifier in your push payload and local notification
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction, maybeAction, declineAction]
        forContext:UIUserNotificationActionContextDefault];
    // yume
    // 2 action context
    // Default action context supports up to four actions (show first 2,只會顯示前2個)
    // minimal action context is used when there's only room for two actions

---

##### Setting

    NSSet *categories = [NSSet setWithObjects:inviteCategory, alarmCategory, ...
    
    UIUserNotificationSettings *settings =
       [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication]
    registerUserNotificationSettings:settings];
  
---

### Send push Notification or schedule local notification

##### Push notification

    // yume
    // You need to include the category identifier in your push payload
    // push payload has now been increased to 2KB
    {
       "aps" : {
          "alert" : "You’re invited!",
          "category" : "INVITE_CATEGORY",
       } 
    }

---

##### Local notification

    UILocalNotification *notification = [[UILocalNotification alloc] init]; ...
    
    notification.category = @"INVITE_CATEGORY";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification]

---

### Handle Action

...

# Remote notification

...

# Location notifications

define core location region objects and attach them to this notififcaion, so that the notification will fire when the user happens to come near, enter or exit a region.

只顯示第一次或always顯示

---

    //Core Location registration
    CLLocationManager *locMan = [[CLLocationManager alloc] init];
    
    locMan.delegate = self;
    
    // request authorization to track the user’s location
    [locMan requestWhenInUseAuthorization];

---

// Plist
Information Property List
 > NSLocationWhenInUseUsageDescription "Your description"

---

    // Core Location registration callbacks
    - (void)locationManager:(CLLocationManager *)manager
        didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
       // check status to see if we’re authorized
       BOOL canUseLocationNotifications = (status == kCLAuthorizationStatusAuthorizedWhenInUse);
    
       if (canUseLocationNotifications) {
          [self startShowingLocationNotifications];
       }
    
    }
    
    - (void)startShowingNotifications {
        UILocalNotification *locNotification = [[UILocalNotification alloc]
                                               init];
        locNotification.alertBody = @“You have arrived!”;
        locNotification.regionTriggersOnce = YES;
    
        locNotification.region = [[CLCircularRegion alloc]
                               initWithCenter:LOC_COORDINATE
    										  radius:LOC_RADIUS
    									 identifier:LOC_IDENTIFIER];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
