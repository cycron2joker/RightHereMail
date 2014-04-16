//
//  GkGkSimpleResultViewModel.h
//  RightHereMail
//
//  Created by pies on 2014/03/27.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GkGkBaseSimpleResultViewData.h"

@interface GkGkBaseSimpleResultViewModel : NSObject


@property (strong, nonatomic) NSArray *resultList;

- (id)initWithResults:(NSArray *)results;



- (UITableViewCell *)setupCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (GkGkBaseSimpleResultViewData *)generateInstanceResultData;

- (GkGkBaseSimpleResultViewData *)extractSelectedData:(NSIndexPath *)indexPath;



@end
