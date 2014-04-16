//
//  GkgkBaseDao.m
//  HelloGkgk3
//
//  Created by pies on 2013/10/13.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkBaseDao.h"

@implementation GkGkBaseDao

- (id)initWithContext:(NSManagedObjectContext *)ctx tablename:(NSString *)tblNm
{
    _context = ctx;
    _tableName = tblNm;
    
	return self;
}

- (NSEntityDescription *)entityDescription
{
    return [NSEntityDescription entityForName:_tableName inManagedObjectContext:_context];
}

- (NSFetchRequest *)request
{
    NSEntityDescription *entity = [self entityDescription];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entity];
    return req;
}

- (NSSortDescriptor *)sortDescriptor:(NSString *)sortIdx accending:(BOOL)accending
{
    return [[NSSortDescriptor alloc] initWithKey:sortIdx ascending:accending];
}


- (int)countAll
{

    NSFetchRequest *request = [self request];
    [request setResultType:NSDictionaryResultType];

    NSEntityDescription *entity = [request entity];
    NSDictionary *props = [entity propertiesByName];

    NSString* firstFldName = [[props allKeys] firstObject];
    
    NSExpression *keyPathExp = [NSExpression expressionForKeyPath:firstFldName];

    NSExpression *countExp = [NSExpression expressionForFunction:@"count:"
                                                      arguments:[NSArray arrayWithObject:keyPathExp]];
    
    NSExpressionDescription *expDesc = [[NSExpressionDescription alloc] init];
    [expDesc setName:@"countAll"];
    [expDesc setExpression:countExp];
    [expDesc setExpressionResultType:NSDecimalAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:expDesc]];

    NSError *error;
    NSArray *results = [_context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return -1;
    }
    
    
    if (results == nil) {
        NSLog(@"nodata");
        return -1;
    } else {
        
        NSDictionary *dict  = [results firstObject];
        NSDecimalNumber *recCnt = [dict valueForKey:@"countAll"];
        return [recCnt intValue];
    }
    return -1;
}

-(NSError *)saveRecord
{
    NSError *error = nil;
    [self.context save:&error];
    return error;
}

-(NSError *)removeEntity:(NSManagedObject *)entity
{
    [self.context deleteObject:entity];
    return [self saveRecord];
}


@end
