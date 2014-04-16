//
//  GkGkBookMarkDao.m
//  RightHereMail
//
//  Created by pies on 2013/12/11.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkBookMarkDao.h"

@implementation GkGkBookMarkDao


- (NSArray *)listAll
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // 検索対象のエンティティを指定します。
    NSEntityDescription *entity
        = [NSEntityDescription entityForName:self.tableName inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];

    // 作成日降順
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"create" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *fetchedResultsController
    = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                          managedObjectContext:self.context
                                            sectionNameKeyPath:nil
                                                     cacheName:nil];
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return [[NSArray alloc] init];
    }
    return [fetchedResultsController fetchedObjects];
}


- (BookMark *)findByPoint:(float)lat lng:(float)lng
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity
        = [NSEntityDescription entityForName:self.tableName inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // １行のみ
    [fetchRequest setFetchBatchSize:1];
    
    // 作成日降順
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"create" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSPredicate *pred
        = [NSPredicate predicateWithFormat:@"lat = %f and lng = %f", lat, lng];
    [fetchRequest setPredicate:pred];
    
    
    NSFetchedResultsController *fetchedResultsController
        = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                              managedObjectContext:self.context
                                                sectionNameKeyPath:nil
                                                         cacheName:nil];
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    NSArray *results = [fetchedResultsController fetchedObjects];
    
    if ([results count] == 0)
    {
        return nil;
    }
    
    return [results objectAtIndex:0];
}

- (void)createBookMark:(NSString *)titile lat:(float)lat lng:(float)lng
{
    NSLog(@"start create bookmark %@,%f,%f" ,titile ,lat ,lng);
    BookMark* entity = (BookMark *)[NSEntityDescription insertNewObjectForEntityForName:self.tableName
                                                                 inManagedObjectContext:self.context];
    entity.title = titile;
    entity.lat = [NSNumber numberWithFloat:lat];
    entity.lng = [NSNumber numberWithFloat:lng];
    entity.create = [NSDate date];

    NSError *error = [self saveRecord];
    
    if (error != nil)
    {
        NSLog(@"error occured(bookmark create.) %@, %@ ", error, [error userInfo]);
    }
}

- (void)updateBookMarkTitle:(BookMark *)bm title:(NSString *)title
{
    bm.title = title;
    bm.create = [NSDate date];
    NSError *error = [self saveRecord];
    if (error != nil)
    {
        NSLog(@"error occured(bookmark update.) %@, %@ ", error, [error userInfo]);
    }
}

- (void)removeBookMark:(BookMark *)bm
{

    NSError *error = [self removeEntity:bm];
    if (error != nil)
    {
        NSLog(@"error occured(bookmark remove.) %@, %@ ", error, [error userInfo]);
    }
}

@end
