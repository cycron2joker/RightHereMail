//
//  GkGkGeoSrcResult.h
//  AddresSearchTest
//
//  Created by pies on 2013/11/14.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GkGkWebSrvResult : NSObject
{

    NSMutableArray *results;
}

- (NSArray *)searchResults;
- (id)init;
- (BOOL)isNotFound;

- (void)addSearchResult:(NSDictionary *)result;

@end
