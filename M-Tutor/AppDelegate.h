//
//  AppDelegate.h
//  M-Tutor
//
//  Created by Vedavalli on 10/06/16.
//  Copyright © 2016 M-Tutor Pvt Ltd. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define IS_IPHONE_4 480.0
#define IS_IPHONE_5 568.0
#define IS_IPHONE_6 667.0
#define IS_IPHONE_6P 736.0

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
    UILabel                 *label;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, strong) NSMutableDictionary *dictXMLData;
@property(nonatomic) BOOL shouldRotate;

@property (strong, nonatomic) UITabBarController *tabBarController;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)loginUserInfoPlist :(NSDictionary *)dictUserinfo;
-(void)logoutUserInfoPlist;

-(void)setTabbar;

- (void)hideActivity;
- (void)showActivity;

@end

