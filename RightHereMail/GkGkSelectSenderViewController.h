//
//  GkGkSelectSenderViewController.h
//  GMapTest
//
//  Created by pies on 2013/11/23.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>

#import "GkGkDrawMapViewController.h"


@interface GkGkSelectSenderViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{

    //GkGkNearestStationSearch *stationSearch;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *mImgMyLoc;

@property (strong, nonatomic) IBOutlet UISwitch *mAttachSwitch;

@property (strong ,nonatomic) NSMutableArray *drawLines;
@property (strong ,nonatomic) UIImage *drawMapImage;

@property (strong, nonatomic) IBOutlet UITableViewCell *mCellBMEdit;

@property (strong, nonatomic) IBOutlet UITableViewCell *mCellSendMail;

@property (strong, nonatomic) IBOutlet UITableViewCell *mCellTweet;

@property (strong, nonatomic) IBOutlet UITableViewCell *mCellBackView;


@end
