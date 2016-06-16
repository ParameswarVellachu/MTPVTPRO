//
//  AppDelegate.m
//  M-Tutor
//
//  Created by Vedavalli on 10/06/16.
//  Copyright © 2016 M-Tutor Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "Home.h"
#import "MyCourseView.h"
#import "FeatureView.h"
#import "WishlistView.h"
#import "Profile.h"
#import "MySubjectList.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize dictXMLData;
@synthesize shouldRotate;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController;
    
    NSString *check= [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSLog(@"UserID : %@",check);
    UINavigationController *nav;
    
    if ([check isEqualToString:@""] || check==nil) {
        
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"mainID"];
        nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = nav;

    }
    else
    {
        [self retrieveXMLData];
//        viewController = [storyboard instantiateViewControllerWithIdentifier:@"homeID"];
//        nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        
        /*
        Home *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeID"];
        homeVC.tabBarItem.title = @"Home";
        
        MyCourseView *myCourse = [storyboard instantiateViewControllerWithIdentifier:@"mycourseID"];
        myCourse.tabBarItem.title = @"My Courses";
        
        WishlistView *wishList = [storyboard instantiateViewControllerWithIdentifier:@"wishlistID"];
        wishList.tabBarItem.title = @"Wishlist";
        
        Profile *myProfile = [storyboard instantiateViewControllerWithIdentifier:@"profileID"];
        myProfile.tabBarItem.title = @"Profile";
        
        
        homeVC.tabBarItem.image = [[UIImage imageNamed:@"home-icon.png"]
                                   imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        myCourse.tabBarItem.image = [[UIImage imageNamed:@"mycourseMenu.png"]
                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        self.tabBarController = [[UITabBarController alloc]init];
        self.tabBarController.viewControllers = @[homeVC,myCourse,wishList,myProfile];
        self.tabBarController.delegate = (id)self;
        [self.window setRootViewController:self.tabBarController];
         */
        
        [self setTabbar];

//        ViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"loginID"];
//        viewController = [storyboard instantiateViewControllerWithIdentifier:@"homeID"];
//        [self.window setRootViewController:viewControllers];

    }
//    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}

-(void)setTabbar
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    Home *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeID"];
    homeVC.tabBarItem.title = @"Home";
    
    MySubjectList *mySubjectList = [storyboard instantiateViewControllerWithIdentifier:@"mysubjectID"];
    mySubjectList.tabBarItem.title = @"My Courses";
    
    WishlistView *wishList = [storyboard instantiateViewControllerWithIdentifier:@"wishlistID"];
    wishList.tabBarItem.title = @"Wishlist";
    
    Profile *myProfile = [storyboard instantiateViewControllerWithIdentifier:@"profileID"];
    myProfile.tabBarItem.title = @"Profile";
    
    
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"home-icon.png"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    mySubjectList.tabBarItem.image = [[UIImage imageNamed:@"mycourseMenu.png"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    wishList.tabBarItem.image = [[UIImage imageNamed:@"home-icon.png"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    myProfile.tabBarItem.image = [[UIImage imageNamed:@"mycourseMenu.png"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UINavigationController *nav1;
    nav1 = [[UINavigationController alloc]initWithRootViewController:homeVC];

    UINavigationController *nav2;
    nav2 = [[UINavigationController alloc]initWithRootViewController:mySubjectList];

    UINavigationController *nav3;
    nav3 = [[UINavigationController alloc]initWithRootViewController:wishList];

    UINavigationController *nav4;
    nav4 = [[UINavigationController alloc]initWithRootViewController:myProfile];

    self.tabBarController = [[UITabBarController alloc]init];
    self.tabBarController.viewControllers = @[nav1,nav2,nav3,nav4];

//    self.tabBarController.viewControllers = @[nav1,myCourse,wishList,myProfile];
    self.tabBarController.delegate = (id)self;
    [self.window setRootViewController:self.tabBarController];

}

- (void)retrieveXMLData
{
    NSString *strUser= [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSLog(@"Instruction : %@",strUser);
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"CourseDetails" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(userid = %@)",strUser];
    [request setPredicate:pred];
    
    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"No matches");
        
    } else {
        matches = objects[0];
        NSLog(@"matches found : %@",matches);
        
        NSData *data = [matches valueForKey:@"content"];
        //        NSLog(@"Data : %@",data);
        dictXMLData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //        NSLog(@"XML Parser : %@",dictXMLData);
    }
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.shouldRotate)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    else
        return UIInterfaceOrientationMaskPortrait;
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.M_Tutor" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"M_Tutor" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"M_Tutor.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Login & Logout

-(void)loginUserInfoPlist :(NSDictionary *)dictUserinfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSData* dictUserData = [NSKeyedArchiver archivedDataWithRootObject:dictUserinfo];
    [def setObject:dictUserData forKey:@"userinfo"];
    [def setBool:YES forKey:@"login-success"];
    [def synchronize];
}

-(void)logoutUserInfoPlist
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    {
        [def removeObjectForKey:@"userinfo"];
        [def removeObjectForKey:@"userid"];
    }
    [def synchronize];
}

#pragma mark - Progress bar

- (void)showActivity
{
    if (!activityIndicatorView)
        [self addActivityIndicator];
    [label setHidden:NO];
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
    self.window.userInteractionEnabled = NO;
    activityIndicatorView.center = self.window.center;
    [self.window bringSubviewToFront:activityIndicatorView];
    [self.window bringSubviewToFront:label];
    
}

- (void)hideActivity {
    
    if (activityIndicatorView) {
        if (activityIndicatorView.isAnimating)
            [activityIndicatorView stopAnimating];
    }
    [label setHidden:YES];
    self.window.userInteractionEnabled = YES;
}


- (void)addActivityIndicator {
    
    CGFloat labelX = 120.0 + 2;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(labelX + 10.0, 30.0f, self.window.bounds.size.width - (labelX + 2), self.window.frame.size.height)];
    
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    
    //    label.text=@"Please wait to download...";
    
    label.numberOfLines = 1;
    
    label.backgroundColor = [UIColor clearColor];
    
    label.textColor=[UIColor blackColor];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        label.frame=CGRectMake(labelX + 235.0, 30.0f, self.window.bounds.size.width - (labelX + 2), self.window.frame.size.height) ;
    }
    
    
    [self.window addSubview:label];
    
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicatorView.color=[UIColor colorWithRed:48/255.0f green:135/255.0f blue:233/255.0f alpha:1.0f];
    
    activityIndicatorView.frame = CGRectMake(0, 0, 100, 100);
    
    activityIndicatorView.center = self.window.center;
    
    activityIndicatorView.layer.cornerRadius = 10;
    
    activityIndicatorView.layer.opacity = .75;
    
    activityIndicatorView.hidesWhenStopped = YES;
    
    [self.window addSubview:activityIndicatorView];
    
}


@end
