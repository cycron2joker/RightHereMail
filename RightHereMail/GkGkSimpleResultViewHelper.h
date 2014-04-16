//
//  GkGkSimpleResultViewHelper.h
//  RightHereMail
//
//  Created by pies on 2014/03/26.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GkGkSimpleResultView.h"
#import "GkGkBaseSimpleResultViewModel.h"
#import "GkGkPSimpleResultViewHelper.h"




@interface GkGkSimpleResultViewHelper : NSObject <GkGkPSimpleResultViewHelper>



@property (nonatomic ,weak) id delegate;

@property (nonatomic ,strong) IBOutlet GkGkSimpleResultView *resultView;



- (id)initWithParent:(UIViewController *)parent;
- (void)showResultView:(GkGkBaseSimpleResultViewModel *)model;
//- (void)doCancel;
//- (void)selectCellData:(NSObject*)selectData;


@end

@protocol GkGkPSimpleResultVParent <NSObject>

- (void)didCancelSimpleResultView;
- (void)didSelectSimpleResultViewData:(GkGkBaseSimpleResultViewData *)resultData;

@end
