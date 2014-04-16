//
//  GkgkBaseDataManager.h
//  HelloGkgk3
//
//  Created by pies on 2013/10/13.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GkGkBaseDataManager : NSObject

- (id)initWithDbName:(NSString *)dbName;
- (id)initWithDaoObj:(NSString *)dbName;
- (void)setupDaoObject;
- (void)setupApplication;


@property (strong, nonatomic) NSManagedObjectContext *context;

@end
