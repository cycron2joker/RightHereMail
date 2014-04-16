//
//  GkGkNearestStationSearch.h
//  RightHereMail
//
//  Created by pies on 2014/03/13.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GkGkWebSrvResult.h"
#import "GkGkWebServiceManager.h"
//#import "GkGkWebServiceManagerDelegate.h"

@interface GkGkNearestStationSearch : GkGkWebServiceManager

//@property (nonatomic ,strong) NSString *address;

// receive json data.



- (BOOL)searchStart:(float)lat lng:(float)lng;
- (void)cancel;



@end
