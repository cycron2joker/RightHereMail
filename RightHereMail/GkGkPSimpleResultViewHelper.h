//
//  GkGkPSimpleResultViewHelper.h
//  RightHereMail
//
//  Created by pies on 2014/04/03.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GkGkBaseSimpleResultViewData.h"

@protocol GkGkPSimpleResultViewHelper <NSObject>

- (void)doCancel;
- (void)doSelectCellData:(GkGkBaseSimpleResultViewData *)resultData;

@end
