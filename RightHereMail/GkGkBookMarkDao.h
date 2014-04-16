//
//  GkGkBookMarkDao.h
//  RightHereMail
//
//  Created by pies on 2013/12/11.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkBaseDao.h"
#import "BookMark.h"

@interface GkGkBookMarkDao : GkGkBaseDao

- (BookMark *)findByPoint:(float)lat lng:(float)lng;
- (void)createBookMark:(NSString *)titile lat:(float)lat lng:(float)lng;
- (void)updateBookMarkTitle:(BookMark *)bm title:(NSString *)title;
- (void)removeBookMark:(BookMark *)bm;
- (NSArray *)listAll;

@end
