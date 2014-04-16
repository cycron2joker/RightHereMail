//
//  GkGkRHMManager.m
//  RightHereMail
//
//  Created by pies on 2013/12/10.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkRHMManager.h"

@implementation GkGkRHMManager


/**
 * Dao初期化.
 */
- (void)setupDaoObject
{
    // DAO準備
    [super setupDaoObject];
    
    // bookmark dao
    _bookMarkDao = [[GkGkBookMarkDao alloc] initWithContext:self.context tablename:@"BookMark"];

    
}


@end
