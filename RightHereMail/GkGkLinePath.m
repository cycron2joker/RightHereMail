//
//  GkGkLinePath.m
//  PriMeProto1
//
//  Created by pies on 2013/11/10.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkLinePath.h"

@implementation GkGkLinePath {
    
}

- (id)init
{
    return [self initWithColorAndPenSize:[UIColor blackColor] penSize:2.0];
}

- (id)initWithColorAndPenSize:(UIColor *)color penSize:(double)penSize
{
    self = [super init];

    _points = [[NSMutableArray alloc] init];
    _color = color;
    _lineWith = penSize;

    return self;
}




- (void)addPoint:(CGPoint)point
{
    NSValue *pointObj = [NSValue valueWithCGPoint:point];
    [_points addObject:pointObj];
}

- (BOOL)isNeedDraw
{
    if ([_points count] > 1)
    {
        return TRUE;
    }
    return FALSE;
}

- (NSArray *)getDrawPoints
{
    
    unsigned int lastIdx = [_points count] - 1;
    unsigned int prevIdx = lastIdx - 1;

    NSValue *prevPoint = [_points objectAtIndex:prevIdx];
    NSValue *lastPoint = [_points objectAtIndex:lastIdx];
    
    [_points lastObject];
    
    return @[prevPoint , lastPoint];
    
}



@end
