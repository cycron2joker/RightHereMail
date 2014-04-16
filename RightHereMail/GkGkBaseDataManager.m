//
//  GkgkBaseDataManager.m
//  HelloGkgk3
//
//  Created by pies on 2013/10/13.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkBaseDataManager.h"

@implementation GkGkBaseDataManager




- (id)initWithDaoObj:(NSString *)dbName
{
    self = [self initWithDbName:dbName];
    
    [self setupDaoObject];
    
    [self setupApplication];
    
    return self;
}


- (id)initWithDbName:(NSString *)dbName
{
    
    NSError *error = nil;
    NSPersistentStoreCoordinator *coordinator;

/*

 // NSManagedObjectModel
 NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Hoge" withExtension:@"momd"];
 NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
 // NSPersistentStoreCoordinator
 NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSURL *storeURL = [[paths objectAtIndex:0] URLByAppendingPathComponent:@"Hoge.sqlite"];
 [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
 // NSManagedObjectContext
 NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
 [context setPersistentStoreCoordinator:coordinator];
 
 
    
    
*/
    self = [super init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // ドキュメントDir取得
    NSURL *docDir = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
    
    
    
//    // DB格納dir
//    NSURL *dbDir = [docDir URLByAppendingPathComponent:@"db"];
//    
//    NSLog(@"docdir:%@" , docDir);
//    NSLog(@"dbdir:%@" , dbDir);
//    
//    if (![fileManager fileExistsAtPath:[docDir description]]) {
//        // Db格納dirが存在しない
//        NSLog(@"dbdir not exists.");
//        if (![fileManager createDirectoryAtURL:dbDir withIntermediateDirectories:YES
//                                   attributes:nil error:&error]) {
//            NSLog(@"db store dir create failed %@ %@, %@", dbDir ,error, [error userInfo]);
//            abort();
//        }
//        NSLog(@"dbdir created.");
//        
//    } else {
//        NSLog(@"dbdir exists.");
//    }

    NSURL *storeURL = [docDir URLByAppendingPathComponent:dbName];
    
//    if([fileManager fileExistsAtPath:[storeURL description]])
//    {
//        [fileManager removeItemAtURL:storeURL error:&error];
//    }

    
    
    NSLog(@"dbPath:%@" , storeURL);
//    NSURL *storeURL = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:dbName];
    
    error = nil;
    NSManagedObjectModel *nom =  [NSManagedObjectModel mergedModelFromBundles:nil];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:nom];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:coordinator];

	return self;
}


- (void)setupDaoObject
{
    // implement if need
}

- (void)setupApplication
{
    // implement if need
}

@end
