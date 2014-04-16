//
//  GkGkGeoSrcResult.m
//  AddresSearchTest
//
//  Created by pies on 2013/11/14.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkWebSrvResult.h"

@implementation GkGkWebSrvResult


- (id)init
{
    self = [super init];
    results = [[NSMutableArray alloc] init];
    return self;
}

- (BOOL)isNotFound
{
    return [results count] == 0;
}

- (void)addSearchResult:(NSDictionary *)result
{
    [results addObject:result];
}

- (NSArray *)searchResults
{
    return results;
}

@end
