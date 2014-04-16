//
//  GkGkAddressSearch.h
//  RightHereMail
//
//  Created by pies on 2014/04/15.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkWebServiceManager.h"
#import "GkGkWebSrvResult.h"

@interface GkGkAddressSearch : GkGkWebServiceManager

- (BOOL)searchStart:(NSString *)targetAddr;
- (void)cancel;

@end
