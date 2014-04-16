//
//  GkGkDrawConfigViewController.h
//  GMapTest
//
//  Created by pies on 2013/11/28.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GkGkPenSampleView.h"

@interface GkGkDrawConfigViewController : UITableViewController


@property (strong, nonatomic) IBOutlet UISlider *mSldPenWidth;

@property (strong, nonatomic) IBOutlet GkGkPenSampleView *mPenSizeView;

@property (nonatomic ,strong) UIColor *curPenColor;
@property double curPenSize;

- (IBAction)doBackView:(id)sender;
@end
