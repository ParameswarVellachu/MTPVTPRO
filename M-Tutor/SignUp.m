//
//  SignUp.m
//  M-Tutor
//
//  Created by Vedavalli on 10/05/16.
//  Copyright © 2016 MACMINI-Shenoy. All rights reserved.
//

#import "SignUp.h"
#import "Reachability.h"
#import "ViewController.h"
#import "SignIn.h"


@interface SignUp ()<NSURLSessionDelegate>
{
    NSString *strMobileNumber;
    NSString *strEmailID;
    BOOL boolMobileExists;
    BOOL boolEmailExists;
    BOOL boolFromSignUp;
}

@end

@implementation SignUp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    strMobileNumber=@"";
    strEmailID=@"";
    boolMobileExists = NO;
    boolEmailExists = NO;
    boolFromSignUp = NO;
    
    [activityView setHidden:YES];
    [activityView stopAnimating];
    
    
    
     [self.signupScroll setContentSize:(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+200))];
     // Do any additional setup after loading the view, typically from a nib.
     UILabel *lblLeftPaddingName = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 25, 1) ];
     UILabel *lblLeftPaddingEmail = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 25, 1) ];
     UILabel *lblLeftPaddingMobile = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 25, 1) ];
     UILabel *lblLeftPaddingCode = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 25, 1) ];
     UILabel *lblLeftPaddingPwd = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 25, 1) ];
     UILabel *lblLeftPaddingConfirmPwd = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 25, 1) ];
    
     txtUserName.leftView = lblLeftPaddingName;
     txtUserName.leftViewMode = UITextFieldViewModeAlways;
    
     txtUserEmailID.leftView = lblLeftPaddingEmail;
     txtUserEmailID.leftViewMode = UITextFieldViewModeAlways;
    
     txtUsermobileNo.leftView = lblLeftPaddingMobile;
     txtUsermobileNo.leftViewMode = UITextFieldViewModeAlways;
    
     txtUserUniqueCode.leftView = lblLeftPaddingCode;
     txtUserUniqueCode.leftViewMode = UITextFieldViewModeAlways;
    
     txtUserPwd.leftView = lblLeftPaddingPwd;
     txtUserPwd.leftViewMode = UITextFieldViewModeAlways;
    
     txtUserConfirmPwd.leftView = lblLeftPaddingConfirmPwd;
     txtUserConfirmPwd.leftViewMode = UITextFieldViewModeAlways;


}

- (IBAction)goBackTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)SignUp:(id)sender
{
    [txtUserName resignFirstResponder];
    [txtUsermobileNo resignFirstResponder];
    [txtUserEmailID resignFirstResponder];
    [txtUserUniqueCode resignFirstResponder];
    [txtUserPwd resignFirstResponder];
    [txtUserConfirmPwd resignFirstResponder];
    
    boolFromSignUp = YES;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"You seem to be offline. Please check your network connection.");
        [self showAlertFor:@"Mtutor" withMsg:@"You seem to be offline. Please check your network connection" withTag:104];
        return;
    }
    
    if ([txtUserName.text isEqualToString:@""] || [txtUserName.text length]==0)     {
        [self showAlertFor:@"Mtutor" withMsg:@"Please enter username" withTag:4];
        return;
    }
    
    if ([txtUsermobileNo.text isEqualToString:@""] || [txtUsermobileNo.text length]==0) {
        [self showAlertFor:@"Mtutor" withMsg:@"Please enter mobile number" withTag:4];
        return;
    }
    
    if ([txtUserUniqueCode.text isEqualToString:@""] || [txtUserUniqueCode.text length]==0) {
        [self showAlertFor:@"Mtutor" withMsg:@"Please enter promo code" withTag:4];
        return;
    }
    
    if ([txtUserPwd.text isEqualToString:@""] || [txtUserPwd.text length]==0) {
        [self showAlertFor:@"Mtutor" withMsg:@"Please enter password" withTag:4];
        return;
    }
    
    if ([txtUserConfirmPwd.text isEqualToString:@""] || [txtUserConfirmPwd.text length]==0) {
        [self showAlertFor:@"Mtutor" withMsg:@"Please enter confirm password" withTag:4];
        return;
    }

    
    BOOL boolMobileOrEmail =  [self isNumeric:txtUsermobileNo.text];
    if(boolMobileOrEmail==YES)
    {
        NSUInteger length = [txtUsermobileNo.text length];
        if (length > 10 || length <10) {
            NSLog(@"Mobile number cannot exceed more than 10 digit");
            [self showAlertFor:@"Mtutor" withMsg:@"Mobile number must be 10 digit" withTag:0];
            return;
        }
        else
        {
            strMobileNumber = [NSString stringWithFormat:@"91%@",txtUsermobileNo.text];
            [self MobileValidationThread];
        }
    }
    else
    {
        [self showAlertFor:@"Mtutor" withMsg:@"Please enter valid mobile number" withTag:0];
        return;
    }
}

- (void)parsMobileValidation
{
    if ([txtUserEmailID.text isEqualToString:@""] || [txtUserEmailID.text length]==0) {
        
//        [NSThread detachNewThreadSelector:@selector(SignUpThread) toTarget:self withObject:nil];
        [self SignUpThread];
    }
    else
    {
        //email validation
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        //Valid email address
        
        if ([emailTest evaluateWithObject:txtUserEmailID.text] == YES)
        {
            //Do Something
            NSLog(@"email in proper format");
            strEmailID = txtUserEmailID.text;
            [self EmailValidationThread];
//            [NSThread detachNewThreadSelector:@selector(SignUpThread) toTarget:self withObject:nil];
            
        }
        else
        {
            [self showAlertFor:@"Mtutor" withMsg:@"Please enter valid email" withTag:0];
            return;
        }
    }
}
 
 

//
//-(IBAction)SignUp:(id)sender
//{
//    [NSThread detachNewThreadSelector:@selector(MobileValidationThread) toTarget:self withObject:nil];
//}

- (void)SignUpThread
{
    [activityView setHidden:NO];
    [activityView startAnimating];

    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [formatter stringFromDate:date];
    NSLog(@"%@",strDate);
    
    NSString *strEmpty = @"";
    
//    NSString *strUrl = [NSString stringWithFormat:@"http://192.168.100.140/mtutorlive/gateway/mtutorAPI_1.php?requestedon=%@&type=register&name=vedavalli&password=12345&emailid=vedavalli159@gmail.com&mobilenumber=919094038159&promocode=UAGQSCVV&imei=%@&deviceid=%@&notificationkey=%@&mac=%@",strDate,strEmpty,strEmpty,strEmpty,strEmpty];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://192.168.100.140/mtutorlive/gateway/mtutorAPI_1.php?requestedon=%@&type=register&name=%@&password=%@&emailid=%@&mobilenumber=%@&promocode=%@&imei=%@&deviceid=%@&notificationkey=%@&mac=%@",strDate,txtUserName.text,txtUserPwd.text,strEmailID,strMobileNumber,txtUserUniqueCode.text,strEmpty,strEmpty,strEmpty,strEmpty];
    NSLog(@"URL: %@", strUrl);
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURL * url = [NSURL URLWithString:strUrl];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            NSDictionary *Dictjson = [NSJSONSerialization
                                                                                      JSONObjectWithData:data
                                                                                      options:kNilOptions
                                                                                      error:nil];
                                                            NSLog(@"dict: %@", Dictjson);
                                                            if (Dictjson == NULL) {
                                                                
                                                                [activityView stopAnimating];
                                                                [activityView setHidden:YES];
                                                                [self showAlertFor:@"Mtutor" withMsg:@"Data is null" withTag:4];

                                                            }
                                                            else
                                                            {
                                                                if ([[Dictjson objectForKey:@"returnmsg"] isEqualToString:@"success"]) {
                                                                    
                                                                    [activityView stopAnimating];
                                                                    [activityView setHidden:YES];
                                                                    
                                                                    NSLog(@"%@",[Dictjson objectForKey:@"userid"]);
                                                                    
                                                                    UIAlertController * alert=   [UIAlertController
                                                                                                  alertControllerWithTitle:@"Mtutor"
                                                                                                  message:@"Successfully Registered"
                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                                    
                                                                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                                         {
                                                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                                             SignIn *signin = (SignIn *)[storyboard instantiateViewControllerWithIdentifier:@"signinID"];
                                                                                             [self presentViewController:signin animated:YES completion:nil];
                                                                                         }];
                                                                    [alert addAction:ok];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                }
                                                                else
                                                                {
                                                                    [activityView stopAnimating];
                                                                    [activityView setHidden:YES];
                                                                    [self showAlertFor:@"Mtutor" withMsg:@"Login error" withTag:4];
                                                                }
                                                            }
                                                        }
                                                        else
                                                        {
                                                            [activityView stopAnimating];
                                                            [activityView setHidden:YES];
                                                            [self showAlertFor:@"Mtutor" withMsg:@"Login error" withTag:4];

                                                        }
                                                    }];
    [dataTask resume];
}

- (void)MobileValidationThread
{
    
    [activityView setHidden:NO];
    [activityView startAnimating];

    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [formatter stringFromDate:date];
    NSLog(@"%@",strDate);
    
    strMobileNumber = [NSString stringWithFormat:@"91%@",txtUsermobileNo.text];

//    NSString *strUrl = [NSString stringWithFormat:@"http://online.m-tutor.com/mtutor/gateway/mtutorAPI_1.php?requestedon=%@&type=suservalidation&mobilenumber=919094038159&emailid=vedavalli159@gmail.com",strDate];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://192.168.100.140/mtutorlive/gateway/mtutorAPI_1.php?requestedon=%@&type=uservalidation&mobilenumber=%@",strDate,strMobileNumber];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURL * url = [NSURL URLWithString:strUrl];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            NSDictionary *Dictjson = [NSJSONSerialization
                                                                                      JSONObjectWithData:data
                                                                                      options:kNilOptions
                                                                                      error:nil];
                                                            NSLog(@"dict: %@", Dictjson);
                                                            if (Dictjson == NULL) {
                                                                
                                                                [activityView stopAnimating];
                                                                [activityView setHidden:YES];
                                                                [self showAlertFor:@"Mtutor" withMsg:@"Data is null" withTag:4];

                                                            }
                                                            else
                                                            {
                                                                if ([[Dictjson objectForKey:@"returncode"] isEqualToString:@"200"]) {
                                                                    NSLog(@"New mobile number");
                                                                    boolMobileExists = YES;
                                                                    
                                                                    if (boolFromSignUp==YES) {
                                                                        [self parsMobileValidation];
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    NSLog(@"email ID / MSISDN already exists");
                                                                    boolMobileExists = YES;
                                                                    [self showAlertFor:@"Mtutor" withMsg:@"email ID / MSISDN already exists" withTag:0];
                                                                    return;
                                                                }
                                                            }
                                                            [activityView stopAnimating];
                                                            [activityView setHidden:YES];
                                                        }
                                                        else
                                                        {
                                                            [activityView stopAnimating];
                                                            [activityView setHidden:YES];
                                                            [self showAlertFor:@"Mtutor" withMsg:@"Signup error" withTag:4];

                                                        }

                                                    }];
    [dataTask resume];
}

- (void)EmailValidationThread
{
    [activityView setHidden:NO];
    [activityView startAnimating];

    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [formatter stringFromDate:date];
    NSLog(@"%@",strDate);
    
    //    NSString *strUrl = [NSString stringWithFormat:@"http://online.m-tutor.com/mtutor/gateway/mtutorAPI_1.php?requestedon=%@&type=suservalidation&mobilenumber=919094038159&emailid=vedavalli159@gmail.com",strDate];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://192.168.100.140/mtutorlive/gateway/mtutorAPI_1.php?requestedon=%@&type=uservalidation&emailid=%@",strDate,strEmailID];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURL * url = [NSURL URLWithString:strUrl];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            NSDictionary *Dictjson = [NSJSONSerialization
                                                                                      JSONObjectWithData:data
                                                                                      options:kNilOptions
                                                                                      error:nil];
                                                            NSLog(@"dict: %@", Dictjson);
                                                            if (Dictjson == NULL) {
                                                                [activityView stopAnimating];
                                                                [activityView setHidden:YES];
                                                                [self showAlertFor:@"Mtutor" withMsg:@"Data is null" withTag:4];

                                                            }
                                                            else
                                                            {
                                                                if ([[Dictjson objectForKey:@"returncode"] isEqualToString:@"200"]) {
                                                                    
                                                                    NSLog(@"New mobile number");
                                                                    boolEmailExists = YES;
                                                                    if (boolFromSignUp==YES) {
                                                                        [self SignUpThread];
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    NSLog(@"email ID / MSISDN already exists");
                                                                    boolEmailExists = YES;
                                                                    [self showAlertFor:@"Mtutor" withMsg:@"email ID / MSISDN already exists" withTag:0];
                                                                    return;
                                                                }
                                                            }
                                                            [activityView stopAnimating];
                                                            [activityView setHidden:YES];

                                                        }
                                                        else
                                                        {
                                                            [activityView stopAnimating];
                                                            [activityView setHidden:YES];
                                                            [self showAlertFor:@"Mtutor" withMsg:@"Signup error" withTag:4];
                                                        }

                                                    }];
    [dataTask resume];
}

-(void)showAlertFor:(NSString *)titleText withMsg:(NSString *)Msg withTag:(NSInteger)tagVal{
    

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleText message:Msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        alertController.view.tag=tagVal;
        [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL)isNumeric:(NSString*)inputString{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}


#pragma mark---
#pragma mark    TextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==2) {
        
        /*
        boolFromSignUp = NO;
        if ([txtUsermobileNo.text isEqualToString:@""] || [txtUsermobileNo.text length]==0) {
            [self showAlertFor:@"Mtutor" withMsg:@"Please enter mobile number" withTag:1];
        }
        else
        {
            if (boolMobileExists==NO) {
                
                BOOL isValidMobileNo =  [self isNumeric:txtUsermobileNo.text];
                if (isValidMobileNo==YES) {
                    NSUInteger length = [txtUsermobileNo.text length];
                    if (length > 10 || length <10) {
                        NSLog(@"Mobile number must be 10 digit");
                        [self showAlertFor:@"Mtutor" withMsg:@"Mobile number must be 10 digit" withTag:0];
                    }
                    else
                    {
                        strMobileNumber = [NSString stringWithFormat:@"91%@",txtUsermobileNo.text];
                        [NSThread detachNewThreadSelector:@selector(MobileValidationThread) toTarget:self withObject:nil];
                    }
                }
            }
        }
        boolEmailExists = NO;
         */
        
        
    }
    
    else if (textField.tag==3)
    {
        boolMobileExists = NO;
        
        if ([txtUserEmailID.text isEqualToString:@""] || [txtUserEmailID.text length]==0) {
            
        }
        else
        {
            //email validation
            NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
            //Valid email address
            
            if ([emailTest evaluateWithObject:txtUserEmailID.text] == YES)
            {
                //Do Something
                NSLog(@"email in proper format");
                strEmailID = [NSString stringWithFormat:@"%@",txtUserEmailID.text];
                if (boolEmailExists==NO) {
                    [NSThread detachNewThreadSelector:@selector(EmailValidationThread) toTarget:self withObject:nil];
                }
            }
            else
            {
                [self showAlertFor:@"Mtutor" withMsg:@"Please enter valid email id" withTag:0];
                return;
            }
        }

    }
    
    else if (textField.tag==4)
    {
        /*
        if ([txtUserEmailID.text isEqualToString:@""] || [txtUserEmailID.text length]==0) {
            
        }
        else
        {
            //email validation
            NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
            //Valid email address
            
            if ([emailTest evaluateWithObject:txtUserEmailID.text] == YES)
            {
                //Do Something
                NSLog(@"email in proper format");
                strEmailID = [NSString stringWithFormat:@"%@",txtUserEmailID.text];
                if (boolEmailExists==NO) {
                    [NSThread detachNewThreadSelector:@selector(EmailValidationThread) toTarget:self withObject:nil];
                }
            }
            else
            {
                [self showAlertFor:@"Mtutor" withMsg:@"Please enter valid email id" withTag:0];
                return;
            }
        }
        
        */
        
        boolFromSignUp = NO;
        if ([txtUsermobileNo.text isEqualToString:@""] || [txtUsermobileNo.text length]==0) {
            [self showAlertFor:@"Mtutor" withMsg:@"Please enter mobile number" withTag:1];
        }
        else
        {
            if (boolMobileExists==NO) {
                
                BOOL isValidMobileNo =  [self isNumeric:txtUsermobileNo.text];
                if (isValidMobileNo==YES) {
                    NSUInteger length = [txtUsermobileNo.text length];
                    if (length > 10 || length <10) {
                        NSLog(@"Mobile number must be 10 digit");
                        [self showAlertFor:@"Mtutor" withMsg:@"Mobile number must be 10 digit" withTag:0];
                    }
                    else
                    {
                        strMobileNumber = [NSString stringWithFormat:@"91%@",txtUsermobileNo.text];
                        [NSThread detachNewThreadSelector:@selector(MobileValidationThread) toTarget:self withObject:nil];
                    }
                }
            }
        }
        boolEmailExists = NO;

    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self.view setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    return [textField resignFirstResponder];
}

//Declare a delegate, assign your textField to the delegate and then include these methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag==3 || textField.tag==4) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 25, 1)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
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
