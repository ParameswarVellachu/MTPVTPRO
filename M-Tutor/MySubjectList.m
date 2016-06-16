//
//  MySubjectList.m
//  M-Tutor
//
//  Created by MTCHNDT on 13/06/16.
//  Copyright © 2016 M-Tutor Pvt Ltd. All rights reserved.
//

#import "MySubjectList.h"

@interface MySubjectList ()

@end

@implementation MySubjectList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [self getAllData];
    arrSubjectList = [[NSMutableArray alloc] init];
    arrSubjectNameList = [[NSMutableArray alloc] init];
    dictSetSubjectName = [[NSMutableDictionary alloc]init];
    arrUnitList = [[NSMutableArray alloc] init];

    int nYear=1;
    for (int i=1; i<=nYear*2; i++)
    {
        [self getYearSemesterList:i];

    }
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark collectionView Delegates and Datasource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrSubjectNameList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [[cell viewWithTag:999] removeFromSuperview];
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
//    NSDictionary *dictCurrent = [arrUnitTopicList objectAtIndex:indexPath.row];
    /*
     
     Printing description of dictCurrent:
     {
     "@attributes" =     {
     name = "Evolution and impact of Electronics";
     };
     language =     {
     "@attributes" =         {
     name = English;
     };
     downloadurl = "http://content.m-tutor.com/mtutor/view/downloadfiles.php?qid=703542|topic=6637|type=source|from=app";
     lookup = "q_703542/c9995c5dc151a9323a49074f6be08612.json";
     videothumbnail = "http://content.m-tutor.com/images/20150916113347_5-cont.png";
     watch = "http://content.m-tutor.com/mtutor/web/autologin.php?qid=703542|topic=6637|autologin=yes";
     };
     }
     */
    
    // 2. TITLE PURPOSE
    //    NSString *strSubjectname = [[dictCurrent objectForKey:@"@attributes"] objectForKey:@"name"];
    UILabel *lblNewsTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, (cell.frame.size.height-25)/2, 136, 30)];
    lblNewsTitle.text = [arrSubjectNameList objectAtIndex:indexPath.row];
    lblNewsTitle.numberOfLines = 2;
    lblNewsTitle.lineBreakMode=NSLineBreakByTruncatingTail;
    lblNewsTitle.font = [UIFont boldSystemFontOfSize:12];
    lblNewsTitle.textColor = [UIColor blackColor];
    lblNewsTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lblNewsTitle.textAlignment=NSTextAlignmentCenter;
    lblNewsTitle.tag=999;
    [cell addSubview:lblNewsTitle];
    cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
    cell.layer.borderWidth=1;
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;


    //    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]]];
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_HEIGHT == IS_IPHONE_4 || SCREEN_HEIGHT == IS_IPHONE_5)
    {
        return CGSizeMake(140,75); //use height whatever you wants.
    }
    else if (SCREEN_HEIGHT == IS_IPHONE_6)
    {
        return CGSizeMake(160,125);
    }
    else if (SCREEN_HEIGHT == IS_IPHONE_6P)
    {
        return CGSizeMake(180,125);
    }
    return CGSizeMake(collectionView.bounds.size.width, 150);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [appDelegate showActivity];
    arrTopicsList = [[NSMutableArray alloc] init];
    [self getTopicsList:indexPath.row];
    nIndexDidselectItem=indexPath.row;
    
    [NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(customDidSelectedItemn) userInfo:nil repeats:NO];
    
    
//        NSLog(@":-->%@",[arrSubjectNameList objectAtIndex:indexPath.row]);
    //    NSLog(@":-->%@",[arrUnitList objectAtIndex:indexPath.row]);
    
}

-(void)customDidSelectedItemn
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyCourseView* myCourseList = [story instantiateViewControllerWithIdentifier:@"mycourseID"];
    myCourseList.arrCourseList=arrTopicsList;
    myCourseList.strTitleName=[arrSubjectNameList objectAtIndex:nIndexDidselectItem];
    [self.navigationController pushViewController:myCourseList animated:YES];
    [appDelegate hideActivity];

}

-(void) getTopicsList:(NSInteger )nIndex
{
    NSArray *arrTempTopics = [[NSArray alloc]init];
    arrTempTopics =[arrUnitList objectAtIndex:nIndex];
    for (NSDictionary *dict in arrTempTopics)
    {
        NSArray *arrTop=[[NSArray alloc]init];
        if([[dict valueForKey:@"topic"] isKindOfClass:[NSArray class]])
        {
            //Is array
            arrTop = [dict valueForKey:@"topic"];
            NSLog(@"Count:%ld",arrTop.count);
            NSLog(@"array");
            
            for (int i=0; i<arrTop.count; i++)
            {
                NSDictionary *dict = [arrTop objectAtIndex:i];
                [arrTopicsList addObject:dict];
            }

        }
        else if([[dict valueForKey:@"topic"] isKindOfClass:[NSDictionary class]])
        {
            //is dictionary
//              NSLog(@"dictionary:%@",[dict valueForKey:@"topic"]);
            {
                [arrTopicsList addObject:[dict valueForKey:@"topic"]];
            }

        }
        else
        {
            //is something else
        }
    }
}


/*
-(NSArray *) getSubjectList:(int) subNumber
{
    NSMutableArray *arrSubjectNameList = [[NSMutableArray alloc] init];
    NSDictionary *dictThissubject = [arrSubjectList objectAtIndex:subNumber];
    NSString *strSubjectname = [[dictThissubject objectForKey:@"@attributes"] objectForKey:@"name"];
//    arrUnitTemp = [dictThissubject valueForKey:@"unit"];
    [arrSubjectNameList addObject:strSubjectname];
    
    return arrSubjectNameList;
}
 */

//-(NSArray *) getYearSemesterList:(int) semNumber
//{
//    NSDictionary *dictThisItems = [arrSemesterList objectAtIndex:semNumber-1];
//    NSDictionary *dictBranch = [dictThisItems objectForKey:@"branch"];
//    NSArray *arrSubject = [dictBranch objectForKey:@"subject"];
//    [arrSubjectList addObject:arrSubject];
//
//    return arrSubject;
//}


-(void) getYearSemesterList:(int) semNumber
{
    NSDictionary *dictThisItems = [arrSemesterList objectAtIndex:semNumber-1];
    NSDictionary *dictBranch = [dictThisItems objectForKey:@"branch"];
    NSArray *arrSubject = [dictBranch objectForKey:@"subject"];
    [arrSubjectList addObject:arrSubject];

    
    for (int i=0; i<arrSubject.count; i++)
    {
        NSDictionary *dictThissubject = [arrSubject objectAtIndex:i];
        NSString *strSubjectname = [[dictThissubject objectForKey:@"@attributes"] objectForKey:@"name"];
        NSArray* arrTempUnit = [dictThissubject objectForKey:@"unit"];
        [arrUnitList addObject:arrTempUnit];
        [arrSubjectNameList addObject:strSubjectname];
        
    }
//    NSLog(@"arrUnit.count:%ld",arrUnitList.count);
//   // Writing it to file
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [[path objectAtIndex:0] stringByAppendingPathComponent:@"unitwithkey.plist"];
//    [arrUnitList writeToFile:filePath atomically:YES];
    
}


-(void)getAllData
{
    //    NSLog(@"appDelegate.dictXMLData:\n %@",appDelegate.dictXMLData);

    NSDictionary *dictCourse = [appDelegate.dictXMLData objectForKey:@"course"];
    arrSemesterList=[[NSArray alloc]init];
    arrSemesterList = [dictCourse objectForKey:@"semester"];

}



@end
