//
//  GkGkSimpleResultViewModel.m
//  RightHereMail
//
//  Created by pies on 2014/03/27.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkBaseSimpleResultViewModel.h"

@implementation GkGkBaseSimpleResultViewModel


- (id)initWithResults:(NSArray *)results
{

    self = [super init];
    if (self)
    {
        _resultList = results;
        [self setupModel];
        
    }
    return self;
}

- (void)setupModel
{
    NSLog(@"todo implements sub-class!!!!");
    abort();
}

- (UITableViewCell *)setupCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"todo implements sub-class!!!!");
    abort();
}

- (GkGkBaseSimpleResultViewData *)extractSelectedData:(NSIndexPath *)indexPath
{
    GkGkBaseSimpleResultViewData *result = [self generateInstanceResultData];
    NSObject *target = [_resultList objectAtIndex:[indexPath item]];
    result.resultData = target;
    return result;
}

- (GkGkBaseSimpleResultViewData *)generateInstanceResultData
{
    NSLog(@"todo implements sub-class!!!!");
    abort();
}


@end
