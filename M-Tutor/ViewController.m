//
//  ViewController.m
//  M-Tutor
//
//  Created by Vedavalli on 10/06/16.
//  Copyright © 2016 M-Tutor Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "SignIn.h"
#import "SignUp.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[btnRegister layer] setCornerRadius:10.0f];
    [[btnRegister layer] setBorderWidth:1.0f];
    [[btnRegister layer] setBorderColor:[UIColor whiteColor].CGColor];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)Login:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignIn *signin = (SignIn *)[storyboard instantiateViewControllerWithIdentifier:@"signinID"];
    [self.navigationController pushViewController:signin animated:YES];
}

- (IBAction)Register:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUp *signup = (SignUp *)[storyboard instantiateViewControllerWithIdentifier:@"signupID"];
    [self.navigationController pushViewController:signup animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
