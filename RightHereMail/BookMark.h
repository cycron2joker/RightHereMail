//
//  BookMark.h
//  RightHereMail
//
//  Created by pies on 2013/12/11.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BookMark : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSDate * create;

@end
