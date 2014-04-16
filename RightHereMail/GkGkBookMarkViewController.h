//
//  GkGkBookMarkViewController.h
//  GMapTest
//
//  Created by pies on 2013/12/07.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GkGkAppDelegate.h"

//@interface GkGkBookMarkViewController : UITableViewController
@interface GkGkBookMarkViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UIView *naviContainerView;
    UINavigationBar *naviBar;
    NSString *firstSelectValue;
    NSString *selectTagValue;
    
    NSMutableArray *listBookMark;
}

@property (strong, nonatomic) IBOutlet UITableView *tblBookMarks;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEditBm;
//@property (strong, nonatomic) IBOutlet UINavigationBar *nvBm;
@property (strong, nonatomic) IBOutlet UINavigationItem *nvItem;

- (IBAction)doBackView:(id)sender;

@end
