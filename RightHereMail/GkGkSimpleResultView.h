//
//  GkGkSimpleResultView.h
//  RightHereMail
//
//  Created by pies on 2014/03/17.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GkGkBaseSimpleResultViewModel.h"
#import "GkGkPSimpleResultViewHelper.h"

@interface GkGkSimpleResultView : UIView <UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic ,weak) id<GkGkPSimpleResultViewHelper> delegate;

//- (void)show:(UIView *)parent results:(NSArray *)searchResults;

@property (strong, nonatomic) IBOutlet UIView *mContainerView;
@property (strong, nonatomic) IBOutlet UIButton *mBtnCancel;

@property (strong, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) GkGkBaseSimpleResultViewModel *model;

- (void)showResult:(GkGkBaseSimpleResultViewModel *)model;

- (IBAction)doCancel:(id)sender;


@end
