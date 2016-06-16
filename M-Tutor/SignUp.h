//
//  SignUp.h
//  M-Tutor
//
//  Created by Vedavalli on 10/05/16.
//  Copyright © 2016 MACMINI-Shenoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUp : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtUsermobileNo;
    IBOutlet UITextField *txtUserEmailID;
    IBOutlet UITextField *txtUserUniqueCode;
    IBOutlet UITextField *txtUserPwd;
    IBOutlet UITextField *txtUserConfirmPwd;

    IBOutlet UIActivityIndicatorView *activityView;

}

@property (weak, nonatomic) IBOutlet UIScrollView *signupScroll;
//@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
//@property (weak, nonatomic) IBOutlet UITextField *txtUsermobileNo;
//@property (weak, nonatomic) IBOutlet UITextField *txtUserEmailID;
//@property (weak, nonatomic) IBOutlet UITextField *txtUserUniqueCode;
//@property (weak, nonatomic) IBOutlet UITextField *txtUserPwd;
//@property (weak, nonatomic) IBOutlet UITextField *txtUserConfirmPwd;


@end
