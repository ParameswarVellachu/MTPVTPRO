//
//  MyCourseView.h
//  TabBar
//
//  Created by MTCHNDT on 13/06/16.
//  Copyright © 2016 Vedavalli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MyCourseView : UIViewController<NSURLSessionDelegate>
{
    IBOutlet UITableView *tableCourseList;
    AppDelegate *appDelegate;
    IBOutlet UILabel *lblTitleName;

}
@property (nonatomic,retain) NSArray *arrCourseList;
@property (nonatomic,retain) NSString *strTitleName;

@end
