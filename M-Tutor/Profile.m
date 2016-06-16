//
//  Profile.m
//  TabBar
//
//  Created by MTCHNDT on 13/06/16.
//  Copyright © 2016 Vedavalli. All rights reserved.
//

#import "Profile.h"
#import "AppDelegate.h"

@interface Profile ()

@end

@implementation Profile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender
{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController;
    viewController = [story instantiateViewControllerWithIdentifier:@"mainID"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    appDelegate.window.rootViewController = nav;
//
//    Home *homeVC = [story instantiateViewControllerWithIdentifier:@"firstID"];
//    homeVC.tabBarItem.title = @"Home";
//    
//    SecondTab *settingsVC = [story instantiateViewControllerWithIdentifier:@"secondID"];
//    settingsVC.tabBarItem.title = @"My Courses";
//    
//    appDelegate.tabBarController = [[UITabBarController alloc]init];
//    appDelegate.tabBarController.viewControllers = @[homeVC,settingsVC];
//    appDelegate.tabBarController.delegate = (id)self;
//    
//    ViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"homeID"];
//    [appDelegate.window setRootViewController:loginVC];
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
