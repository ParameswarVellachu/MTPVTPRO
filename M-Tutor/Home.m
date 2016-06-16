//
//  Home.m
//  TabBar
//
//  Created by Vedavalli on 08/06/16.
//  Copyright © 2016 Vedavalli. All rights reserved.
//

#import "Home.h"
#import "AskDoubtView.h"

@interface Home ()

@end

@implementation Home

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    scroll.contentSize = CGSizeMake(scroll.frame.size.width,700);
    
    [btnMycourse.layer setBorderWidth:1.0];
    [btnMycourse.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    [btnWish.layer setBorderWidth:1.0];
    [btnWish.layer setBorderColor:[[UIColor grayColor] CGColor]];

    [btnSticky.layer setBorderWidth:1.0];
    [btnSticky.layer setBorderColor:[[UIColor grayColor] CGColor]];

    [btnMyQlist.layer setBorderWidth:1.0];
    [btnMyQlist.layer setBorderColor:[[UIColor grayColor] CGColor]];

    [btnMyAboutus.layer setBorderWidth:1.0];
    [btnMyAboutus.layer setBorderColor:[[UIColor grayColor] CGColor]];

    [btnMyContest.layer setBorderWidth:1.0];
    [btnMyContest.layer setBorderColor:[[UIColor grayColor] CGColor]];

    [btnFeaturecourse.layer setBorderWidth:1.0];
    [btnFeaturecourse.layer setBorderColor:[[UIColor grayColor] CGColor]];

    [btnAskDoubt.layer setBorderWidth:1.0];
    [btnAskDoubt.layer setBorderColor:[[UIColor grayColor] CGColor]];

    
    btnMycourse.layer.cornerRadius=4;
    btnFeaturecourse.layer.cornerRadius=4;
    btnWish.layer.cornerRadius=4;
    btnAskDoubt.layer.cornerRadius=4;
    btnMyQlist.layer.cornerRadius=4;
    btnSticky.layer.cornerRadius=4;
    btnMyContest.layer.cornerRadius=4;
    btnMyAboutus.layer.cornerRadius=4;
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - button menu action 

-(IBAction)myCourseTapped:(id)sender
{
    self.tabBarController.selectedIndex = 1;

}
-(IBAction)featuredTapped:(id)sender
{
//    self.tabBarController.selectedIndex = 2;
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Feature Course"
                                  message:@"Under Processing....."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    
                                }];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}
-(IBAction)WishListTapped:(id)sender
{
    self.tabBarController.selectedIndex = 2;

}
-(IBAction)AskDoubtTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskDoubtView *home = (AskDoubtView *)[storyboard instantiateViewControllerWithIdentifier:@"askdoubtID"];
    [self.navigationController pushViewController:home animated:YES];
}

-(IBAction)questionListTapped:(id)sender
{
    
}
-(IBAction)stickNotedTapped:(id)sender
{
    
}
-(IBAction)contestTapped:(id)sender
{
    
}
-(IBAction)aboutUsTapped:(id)sender
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
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
