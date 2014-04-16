//
//  GkGkBookMarkEditViewController.h
//  GMapTest
//
//  Created by pies on 2013/12/08.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GkGkAppDelegate.h"

//@interface GkGkBookMarkEditViewController : UIViewController
@interface GkGkBookMarkEditViewController : UITableViewController <UITextFieldDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtBookMarkName;
@property (strong, nonatomic) IBOutlet UIView *imgBookMarkMap;

@property (strong, nonatomic) IBOutlet UITableViewCell *mCellSaveBookMark;

@property (strong, nonatomic) IBOutlet UITableViewCell *mCellBackView;

//- (IBAction)doBackView:(id)sender;

@end
