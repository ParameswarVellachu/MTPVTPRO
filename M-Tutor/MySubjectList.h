//
//  MySubjectList.h
//  M-Tutor
//
//  Created by MTCHNDT on 13/06/16.
//  Copyright © 2016 M-Tutor Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyCourseView.h"

@interface MySubjectList : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    AppDelegate *appDelegate;
    IBOutlet UICollectionView *_collectionView;
//    NSArray *arrSubjectList;
    NSArray *arrSemesterList;
    NSMutableArray *arrSubjectList;
    NSMutableArray *arrSubjectNameList, *arrUnitList, *arrTopicsList;
    NSMutableDictionary *dictSetSubjectName;
    NSInteger nIndexDidselectItem;
}
@end
