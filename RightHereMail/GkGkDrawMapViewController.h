//
//  GkGkDrawMapViewController.h
//  GMapTest
//
//  Created by pies on 2013/11/23.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GkGkAppDelegate.h"
#import "GkGkDrawView.h"
#import "GkGkDrawConfigViewController.h"

@interface GkGkDrawMapViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *mDrawContainerView;

@property (strong, nonatomic) IBOutlet UIImageView *myLocImage;


@property (nonatomic ,strong) GkGkDrawView *mDrawView;

@property (nonatomic ,strong) UIImage *drawMapImage;


@property (nonatomic ,strong) NSMutableArray *drawDataList;

@property (nonatomic ,strong) UIColor *curPenColor;
@property double curPenSize;



- (IBAction)doBackView:(id)sender;

- (IBAction)doUndoAction:(id)sender;
- (IBAction)doCallConfigView:(id)sender;

@end
