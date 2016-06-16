//
//  MyCourseView.m
//  TabBar
//
//  Created by MTCHNDT on 13/06/16.
//  Copyright © 2016 Vedavalli. All rights reserved.
//

#import "MyCourseView.h"

@interface MyCourseView ()

@end

@implementation MyCourseView
@synthesize arrCourseList;
@synthesize strTitleName;

- (IBAction)goBackTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    lblTitleName.text=self.strTitleName;
    [tableCourseList setSeparatorColor:[UIColor redColor]];

    

//     [appDelegate hideActivity];
    
    // Do any additional setup after loading the view.
    
    
//     NSLog(@"count:-->%@",self.arrCourseList);

    
//    self.arrCourseList = [[NSArray alloc]initWithObjects:@"Evolution and impact of Electronics & Evolution and impact of Electronics & Evolution and impact of Electronics",@"Evolution and impact of Electronics",@"Evolution and impact of Electronics & Evolution and impact of Electronics & Evolution and impact of Electronics11",@"Evolution and impact of Electronics1 & Evolution and impact of Electronics & Evolution and impact of Electronics",@"Evolution and impact of Electronics",@"Evolution and impact of Electronics",@"Evolution and impact of Electronics",@"Evolution and impact of Electronics",@"Evolution and impact of Electronics",@"Evolution and impact of Electronics",@"Evolution and impact of Electronics",@"Evolution and impact of Electronics", nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return [self.arrCourseList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    
    NSDictionary *dictCurrent = [self.arrCourseList objectAtIndex:indexPath.row];

    /*
     
     {
     "@attributes" =         {
     name = "Clausius theorem, Helmholtz free energy and Gibbs free energy functions";
     };
     language =         {
     "@attributes" =             {
     name = English;
     };
     downloadurl = "http://content.m-tutor.com/mtutor/view/downloadfiles.php?qid=575|topic=768|type=source|from=app";
     lookup = "q_575/295f46350eca67ca3c3a4b21800a5c7a.json";
     videothumbnail = "http://content.m-tutor.com/images/20160102152548_7_Content.png";
     watch = "http://content.m-tutor.com/mtutor/web/autologin.php?qid=575|topic=768|autologin=yes";
     };

     */
    // Set the data for this cell:
    [[cell viewWithTag:999] removeFromSuperview];

    UIView *viewContainer = [[UIView alloc]init];
    viewContainer.tag=999;
    viewContainer.frame=CGRectMake(0, 0, SCREEN_WIDTH, 98);
    viewContainer.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    viewContainer.layer.borderColor=[UIColor redColor].CGColor;
    viewContainer.layer.masksToBounds=0.5;
    cell.backgroundColor=[UIColor grayColor];
    
//    // 1. THUMBNAIL  PURPOSE
//    UIImageView *imgNews = [[UIImageView alloc]initWithFrame:CGRectMake(15, (75-55)/2, 55, 55)];
//    NSString *strThumbImgUrl =[[dictCurrent objectForKey:@"language"] objectForKey:@"videothumbnail"];
//    
//    // NSString *strThumbImgUrl =@""; testing Purpose
//    if (!strThumbImgUrl ||[strThumbImgUrl isEqualToString:@""])
//    {
//        imgNews.image = [UIImage imageNamed:@"pomma.png"];
//    }

    // 1. THUMBNAIL  PURPOSE
    UIImageView *imgNews = [[UIImageView alloc]initWithFrame:CGRectMake(15, (75-55)/2, 55, 55)];
    NSString *strThumbImgUrl =[[dictCurrent objectForKey:@"language"] objectForKey:@"videothumbnail"];
    if (!strThumbImgUrl ||[strThumbImgUrl isEqualToString:@""])
    {
        imgNews.image = [UIImage imageNamed:@"noImg.png"];
    }
    else
    {
        NSString * newString = [strThumbImgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:newString]];
        if (imageData==nil)
            imgNews.image = [UIImage imageNamed:@"noImg.png"];
        else
        {
        //imgNews.image = [UIImage imageWithData:imageData];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:newString]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgNews.image = [UIImage imageWithData:imageData];
                    
                });
            });
        }
    }

    
    [viewContainer addSubview:imgNews];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, SCREEN_WIDTH-100, 45)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor blackColor];
    lblName.text = [[dictCurrent objectForKey:@"@attributes"] objectForKey:@"name"];
    
    lblName.numberOfLines = 2;
    lblName.lineBreakMode = NSLineBreakByTruncatingTail;
    lblName.font = [UIFont systemFontOfSize:12];

    
    [viewContainer addSubview:lblName];
    
    UIView *viewLineSeparator = [[UIView alloc]init];
    viewLineSeparator.tag=999;
    viewLineSeparator.frame=CGRectMake(15, imgNews.frame.origin.y+imgNews.frame.size.height+5, SCREEN_WIDTH-30, 0.5);
    viewLineSeparator.backgroundColor=[UIColor grayColor];
    [viewContainer addSubview:viewLineSeparator];

    
    // 3. DOUBT PURPOSE
    UIButton *buttonAsk = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAsk setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonAsk.titleLabel setFont:[UIFont systemFontOfSize:11]];
    buttonAsk.frame = CGRectMake(20, imgNews.frame.origin.y+imgNews.frame.size.height+5, 100, 25);
    [buttonAsk setImage:[UIImage imageNamed:@"help-ask.png"] forState:UIControlStateNormal];
    [buttonAsk setImage:[UIImage imageNamed:@"help-ask.png"] forState:UIControlStateHighlighted];
    [buttonAsk setTitle:[NSString stringWithFormat:@"Ask A Doubt"] forState:UIControlStateNormal];
    buttonAsk.tag=indexPath.row;
    buttonAsk.userInteractionEnabled = YES;
    [buttonAsk setImageEdgeInsets:UIEdgeInsetsMake(5, -22.0f, 5, 0)];
    [buttonAsk addTarget:self action:@selector(selectedAskmeDoubtTapped:) forControlEvents:UIControlEventTouchUpInside];
    viewLineSeparator.backgroundColor=[UIColor grayColor];

    [viewContainer addSubview:buttonAsk];
    
    
    // 4. Favourites
    UIImageView *imgFav = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-47, imgNews.frame.origin.y+imgNews.frame.size.height+11, 8, 8)];
    {
        imgFav.image = [UIImage imageNamed:@"plain-heart.png"];
    }

    [viewContainer addSubview:imgFav];
    
    
    UILabel *lblLikesCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75+42, imgNews.frame.origin.y+imgNews.frame.size.height+5, 30, 20)];
    lblLikesCount.textAlignment=NSTextAlignmentLeft;
    lblLikesCount.backgroundColor=[UIColor clearColor];
    lblLikesCount.textColor=[UIColor blackColor];
    lblLikesCount.text = @"256";
    lblLikesCount.numberOfLines = 2;
    lblLikesCount.lineBreakMode = NSLineBreakByTruncatingTail;
    lblLikesCount.font = [UIFont systemFontOfSize:10];
    [viewContainer addSubview:lblLikesCount];

    
    
    [cell addSubview:viewContainer];
    
    
    
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedRow = (int)indexPath.row;
    NSLog(@"touch on row %d", selectedRow);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([tableCourseList respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableCourseList setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableCourseList respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableCourseList setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)selectedAskmeDoubtTapped:(id)sender
{
    
    //    [APP_DELEGATE showProgressViewWithText:@""];
    
    UIButton *senderButton = (UIButton *)sender;
    
    NSInteger nTag = [senderButton tag];
    
    
    printf("button index:%ld,",(long)nTag);
    
    //    NSInteger nSection = nTag/100;
    //    NSInteger nItemNo = nTag%100;
    
    
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
