//
//  GkgkBaseDao.h
//  HelloGkgk3
//
//  Created by pies on 2013/10/13.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GkGkBaseDao : NSObject
- (id)initWithContext:(NSManagedObjectContext *)ctx tablename:(NSString *)tblNm;
- (int)countAll;
- (NSError *)removeEntity:(NSManagedObject *)entity;
- (NSError *)saveRecord;

- (NSEntityDescription *)entityDescription;
- (NSFetchRequest *)request;
- (NSSortDescriptor *)sortDescriptor:(NSString *)sortIdx accending:(BOOL)accending;



@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSString *tableName;
@end
