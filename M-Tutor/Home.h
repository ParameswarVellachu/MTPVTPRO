//
//  Home.h
//  TabBar
//
//  Created by Vedavalli on 08/06/16.
//  Copyright © 2016 Vedavalli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface Home : UIViewController
{
    IBOutlet UIScrollView *scroll;
    AppDelegate *appDelegate;
    
    IBOutlet UIButton *btnMycourse;
    IBOutlet UIButton *btnFeaturecourse;
    IBOutlet UIButton *btnWish;
    IBOutlet UIButton *btnAskDoubt;
    IBOutlet UIButton *btnMyQlist;
    IBOutlet UIButton *btnSticky;
    IBOutlet UIButton *btnMyContest;
    IBOutlet UIButton *btnMyAboutus;

}
@end
