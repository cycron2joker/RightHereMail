//
//  GkGkLinePath.h
//  PriMeProto1
//
//  Created by pies on 2013/11/10.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GkGkLinePath : NSObject {
    
}

@property (nonatomic ,strong) UIColor *color;
@property (nonatomic ,strong) NSMutableArray *points;
@property double lineWith;

- (id)initWithColorAndPenSize:(UIColor *)color penSize:(double)penSize;
- (void)addPoint:(CGPoint)point;
- (BOOL)isNeedDraw;
- (NSArray *)getDrawPoints;

@end
