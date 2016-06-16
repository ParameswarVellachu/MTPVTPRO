//
//  SignIn.h
//  M-Tutor
//
//  Created by MACMINI-Shenoy on 09/05/16.
//  Copyright © 2016 MACMINI-Shenoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignIn : UIViewController<UITextFieldDelegate,NSXMLParserDelegate>
{
    NSArray *arrSemesterList;
    IBOutlet UITextField *txtUserMobileOrEmail;
    IBOutlet UITextField *txtUserPwd;
    IBOutlet UIActivityIndicatorView *activityView;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;


//- (IBAction)forget:(id)sender;


@end

