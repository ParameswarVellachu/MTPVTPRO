//
//  SignIn.m
//  Layout
//
//  Created by MACMINI-Shenoy on 02/05/16.
//  Copyright © 2016 MACMINI-Shenoy. All rights reserved.
//

#import "SignIn.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Home.h"

@interface SignIn ()<NSURLSessionDelegate>
{
    NSString *strMobileEmail;
    NSString *strMobileNumber;
    BOOL boolTxtfldSecure;
    NSString *strUserID;
    NSString *strUnivID;
    AppDelegate *appDelegate;
    BOOL isLoginSuccess;
    BOOL isCallServiceDaily;
    NSManagedObject *newContact;
    BOOL isBattery;
}

@end

@implementation SignIn

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.scroll setContentSize:(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+50))];
    
    UILabel *lbu = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 25, 1) ];
    UILabel *lbp = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 25, 1) ];
    txtUserMobileOrEmail.leftView = lbu;
    txtUserMobileOrEmail.leftViewMode = UITextFieldViewModeAlways;
    txtUserPwd.leftView = lbp;
    txtUserPwd.leftViewMode = UITextFieldViewModeAlways;

    // Do any additional setup after loading the view, typically from a nib.
    boolTxtfldSecure = NO;
    txtUserPwd.secureTextEntry = TRUE;
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    NSString *instructions= [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSLog(@"Instruction : %@",instructions);
    isLoginSuccess = NO;
    isCallServiceDaily = NO;
    
    [activityView setHidden:YES];
    [activityView stopAnimating];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"CourseDetails" inManagedObjectContext:context];
    
    isBattery = NO;
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateBatteryDetails) userInfo:nil repeats:YES];

}

- (IBAction)goBackTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBatteryDetails {
    // obtain the battery details
    CGFloat value = [[UIDevice currentDevice] batteryLevel];
    // value is from 0.0 to 1.0
    // if value is nagitive then its either in charge mode or its iOS Simulator
    int batteryInfo =(value*100);
    
    if (batteryInfo<=20) {
        if (isBattery==NO) {
            NSLog(@"Low battery from login page");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"M-Tutor" message:@"Low battery. Please Charge your device!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            isBattery = YES;
        }
        else
        {
            NSLog(@"Alert already came");
        }
    }
    else
    {
        NSLog(@"Enough battery");
        isBattery=NO;
    }
}

-(IBAction)ShowPassord:(id)sender
{
//    [self getSubjectList:1];

    if (boolTxtfldSecure==NO) {
        txtUserPwd.secureTextEntry = FALSE;
        boolTxtfldSecure=YES;
    }
    else
    {
        txtUserPwd.secureTextEntry = TRUE;
        boolTxtfldSecure=NO;
    }
}

-(IBAction)Login:(id)sender
{
//    [self getSubjectList:0];
    
    strMobileEmail = @"";
    strMobileNumber = @"";
    strUserID = @"";
    strUnivID = @"";
    
    [txtUserMobileOrEmail resignFirstResponder];
    [txtUserPwd resignFirstResponder];
    
    [self.view setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"You seem to be offline. Please check your network connection.");
        [self showAlertFor:@"Mtutor" withMsg:@"You seem to be offline. Please check your network connection" withTag:104];
        return;
    }
    
    if ([txtUserMobileOrEmail.text isEqualToString:@""] || [txtUserMobileOrEmail.text length]==0) {
        [self showAlertFor:@"Mtutor" withMsg:@"Please enter mobile number or email id" withTag:4];
        return;
    }
    
    if ([txtUserPwd.text isEqualToString:@""] || [txtUserPwd.text length]==0) {
        [self showAlertFor:@"Mtutor" withMsg:@"Please enter password" withTag:4];
        return;
    }
    
    BOOL boolMobileOrEmail =  [self isNumeric:txtUserMobileOrEmail.text];
    if(boolMobileOrEmail==YES)
    {
        NSUInteger length = [txtUserMobileOrEmail.text length];
        if (length > 10 || length <10) {
            NSLog(@"Mobile number must be 10 digit");
            [self showAlertFor:@"Mtutor" withMsg:@"Mobile number must 10 digit" withTag:0];
        }
        else
        {
            strMobileEmail = [NSString stringWithFormat:@"mobilenumber"];
            strMobileNumber = [NSString stringWithFormat:@"91%@",txtUserMobileOrEmail.text];
//            [NSThread detachNewThreadSelector:@selector(LoginThread) toTarget:self withObject:nil];
            [self LoginThread];
        }
    }
    else
    {
        NSLog(@"Not a number");
        //email validation
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        //Valid email address
        
        if ([emailTest evaluateWithObject:txtUserMobileOrEmail.text] == YES)
        {
            //Do Something
            NSLog(@"email in proper format");
            strMobileEmail = [NSString stringWithFormat:@"emailid"];
            strMobileNumber = [NSString stringWithFormat:@"%@",txtUserMobileOrEmail.text];
//            [NSThread detachNewThreadSelector:@selector(LoginThread) toTarget:self withObject:nil];
            [self LoginThread];
        }
        else
        {
            [self showAlertFor:@"Mtutor" withMsg:@"Please enter valid email or mobile number" withTag:0];
            return;
        }
    }
}

- (void)LoginThread
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
    
    NSString *strUrl = [NSString stringWithFormat:@"http://online.m-tutor.com/mtutor/gateway/mtutorAPI_1.php?requestedon=%@&type=verify&%@=%@&password=%@",strDate,strMobileEmail,strMobileNumber,txtUserPwd.text];
    
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
                                                            }
                                                            else
                                                            {
                                                                if ([[Dictjson objectForKey:@"returnmsg"] isEqualToString:@"success"]) {
                                                                    
                                                                    strUserID = [NSString stringWithFormat:@"%@",[Dictjson objectForKey:@"userid"]];
                                                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                                    [defaults setObject:strUserID forKey:@"userid"];
                                                                    [defaults synchronize];

//                                                                    [NSThread detachNewThreadSelector:@selector(UnivIDThread) toTarget:self withObject:nil];
                                                                    [self UnivIDThread];
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

- (void)UnivIDThread
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
    
    NSString *strUrl = [NSString stringWithFormat:@"http://online.m-tutor.com/mtutor/gateway/mtutorAPI_1.php?requestedon=%@&type=info&userid=%@",strDate,strUserID];
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
                                                            
//                                                            for(id key in Dictjson)
//                                                            {
//                                                                if ([[Dictjson objectForKey:key] isEqual:[NSNull null]] || [[Dictjson objectForKey:key]isEqualToString:@""]) {
//                                                                
//                                                                }
//                                                                else
//                                                                {
//                                                                    if ([key isEqualToString:@"status"] || [key isEqualToString:@"returncode"] || [key isEqualToString:@"univid"] || [key isEqualToString:@"otpverify"] || [key isEqualToString:@"returnmsg"] || [key isEqualToString:@"transactionid"] || [key isEqualToString:@"imei"] || [key isEqualToString:@"gender"] || [key isEqualToString:@"deviceapi"]) {
//                                                                        
//                                                                    }
//                                                                    else
//                                                                    {
//                                                                        NSLog(@"key=%@ value=%@", key, [Dictjson objectForKey:key]);
//                                                                    }
//                                                                }
//                                                            }
                                                            
                                                            if (Dictjson == NULL) {
                                                                [activityView stopAnimating];
                                                                [activityView setHidden:YES];
                                                            }
                                                            else
                                                            {
                                                                if ([[Dictjson objectForKey:@"returnmsg"] isEqualToString:@"success"]) {
                                                                    
                                                                    strUnivID = [NSString stringWithFormat:@"%@",[Dictjson objectForKey:@"univid"]];
//                                                                    [NSThread detachNewThreadSelector:@selector(videoListThread) toTarget:self withObject:nil];
                                                                    [appDelegate loginUserInfoPlist:Dictjson];
                                                                    [self videoListThread];
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

- (void)videoListThread
{
    [activityView setHidden:NO];
    [activityView startAnimating];

//    NSString *strUrl = [NSString stringWithFormat:@"http://content.m-tutor.com/mtutor/gateway/course.php?uid=%@&type=json",strUnivID];
    NSString *strUrl = [NSString stringWithFormat:@"http://content.m-tutor.com/mtutor/gateway/course.php?uid=%@&type=json&year=1",strUnivID];
    
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
                                                            }
                                                            else
                                                            {
                                                                [self SaveThread:Dictjson];
                                                                [self retrieveXMLDataForDaily];
                                                                NSDictionary *dictCourse = [Dictjson objectForKey:@"course"];
                                                                NSArray *arrCourse = [[dictCourse objectForKey:@"@attributes"] objectForKey:@"name"];
                                                                NSLog(@"Courses : %@",arrCourse);
                                                                arrSemesterList = [dictCourse objectForKey:@"semester"];
                                                                for (int i=0; i<arrSemesterList.count; i++)
                                                                {
//                                                                    NSDictionary *dictThis = [arrSemesterList objectAtIndex:i];
                                                                    
//                                                                    NSString *strName = [[dictThis objectForKey:@"@attributes"] objectForKey:@"name"];
                                                                    //                NSLog(@"strName : %@",strName);
                                                                    
//                                                                    NSDictionary *dictBranch = [dictThis objectForKey:@"branch"];
                                                                    //                NSLog(@"strName : %@",dictBranch);
                                                                }
                                                                
                                                                isLoginSuccess = YES;
                                                                
                                                                [activityView stopAnimating];
                                                                [activityView setHidden:YES];
                                                                
                                                                [NSTimer scheduledTimerWithTimeInterval:86400.0 target:self selector:@selector(DailyServiceCall) userInfo:nil repeats:YES];
                                                                
                                                                /*
                                                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                ViewController *viewController = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeid"];
                                                                ////    viewController.strName = [NSString stringWithFormat:@"%@ %@",txtUserMobileOrEmail.text,txtUserPwd.text];
                                                                [self.navigationController pushViewController:viewController animated:YES];
                                                                 */
                                                                
//                                                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                                                Home *home = (Home *)[storyboard instantiateViewControllerWithIdentifier:@"homeID"];
//                                                                ////    viewController.strName = [NSString stringWithFormat:@"%@ %@",txtUserMobileOrEmail.text,txtUserPwd.text];
//                                                                [self.navigationController pushViewController:home animated:YES];
                                                                
                                                                [appDelegate setTabbar];
                                                                
                                                                
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

- (void)SaveThread:(NSDictionary *)dict
{
    NSString *strUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSLog(@"User ID : %@",strUser);
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSManagedObjectContext *context = [self managedObjectContext];
    
//    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"CourseDetails" inManagedObjectContext:context];
//    [newDevice setValue:myData forKey:@"content"];
//    [newDevice setValue:strUser forKey:@"userid"];
    
        if (newContact) {
            [newContact setValue:myData forKey:@"content"];
            [newContact setValue:strUser forKey:@"userid"];
        }
        else
        {
            NSLog(@"Comes in else part");
        }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    
//    [self Login:nil];
//    if ([identifier isEqualToString:@"homeid"]) {
//        
//        if (isLoginSuccess==NO) {
//            NSLog(@"Name field cannot be empty");
//            return NO;
//        }
//        else
//        {
//            [self performSegueWithIdentifier:@"homeid" sender:nil];
//            return YES;
//        }
//    }
//    return isLoginSuccess;
//}


- (void)DailyServiceCall
{
    
    //    NSString *strUrl = [NSString stringWithFormat:@"http://content.m-tutor.com/mtutor/gateway/course.php?uid=%@&type=json",strUnivID];
    NSString *strUrl = [NSString stringWithFormat:@"http://content.m-tutor.com/mtutor/gateway/course.php?uid=%@&type=json",strUnivID];
    
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
                                                            
//                                                            NSDictionary *Dictjson = [[NSDictionary alloc] initWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", @"value1", @"key1", nil];
                                                            NSLog(@"dict: %@", Dictjson);
                                                            
                                                            if (Dictjson == NULL) {
                                                                
                                                            }
                                                            else
                                                            {
                                                                [self SaveThread:Dictjson];
                                                                [self retrieveXMLDataForDaily];
                                                            }
                                                        }
                                                        else
                                                        {
//                                                            [self showAlertFor:@"Mtutor" withMsg:@"Login error" withTag:4];
                                                        }
                                                    }];
    [dataTask resume];
}


- (void)retrieveXMLDataForDaily
{
    NSString *strUser= [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
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
        appDelegate.dictXMLData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)getSubjectList:(int)semNumber
{
    NSDictionary *dictThis = [arrSemesterList objectAtIndex:semNumber];
    NSDictionary *dictBranch = [dictThis objectForKey:@"branch"];
    NSArray *arrSubject = [dictBranch objectForKey:@"subject"];
    NSMutableArray *arrSubjectList = [[NSMutableArray alloc] init];

    for (int i=0; i<arrSubject.count; i++)
    {
        NSDictionary *dictTemp = [arrSubject objectAtIndex:i];
        [arrSubjectList addObject:[[dictTemp objectForKey:@"@attributes"] objectForKey:@"name"]];
    }
    NSLog(@"List of subjects : %@",arrSubjectList);
    return arrSubjectList;
}

-(NSArray *)getUnitList:(int)semNumber
{
    NSDictionary *dictThis = [arrSemesterList objectAtIndex:semNumber];
    NSDictionary *dictBranch = [dictThis objectForKey:@"branch"];
    NSArray *arrSubject = [dictBranch objectForKey:@"subject"];
    NSMutableArray *arrSubjectList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<arrSubject.count; i++)
    {
        NSDictionary *dictTemp = [arrSubject objectAtIndex:i];
        [arrSubjectList addObject:[[dictTemp objectForKey:@"@attributes"] objectForKey:@"name"]];
    }
    NSLog(@"List of subjects : %@",arrSubjectList);
    return arrSubjectList;
}

#pragma mark---
#pragma mark    TextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self.view setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    return [textField resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
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

@end


