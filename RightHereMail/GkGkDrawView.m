//
//  GkGkDrawView.m
//  GMapTest
//
//  Created by pies on 2013/11/24.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkDrawView.h"

@implementation GkGkDrawView

// 継承したクラスをnib(storyboadから呼ぶ場合)
// イニシャライザはこのメソッド
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    // 背景色を透明にする
    UIColor *alphaColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [self setBackgroundColor:alphaColor];
    
    //_mLines = [[NSMutableArray alloc] init];
    NSLog(@"subview loaded(with coder)");
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景色を透明にする
        UIColor *alphaColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        [self setBackgroundColor:alphaColor];
        
       // _mLines = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)beginLine:(UIColor *)penColor penSize:(double)penSize
{
    GkGkLinePath *linePath = [[GkGkLinePath alloc] initWithColorAndPenSize:penColor penSize:penSize];
    [_mLines addObject:linePath];
}

- (void)setTouchPoint:(CGPoint)point
{
    GkGkLinePath *linePath = [_mLines lastObject];
    
    [linePath addPoint:point];
    
    // 再描画実行
    [self setNeedsDisplay];
    
}

- (void)setEndTouch:(CGPoint) point
{
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ([_mLines count] > 0) {
        
        for (GkGkLinePath *linePath in _mLines) {
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            BOOL first = TRUE;
            for (NSValue *objPt in linePath.points)
            {
                CGPoint pt = [objPt CGPointValue];
                
                if (first)
                {
                    first = FALSE;
                    [path moveToPoint:pt];
                    
                }
                else
                {
                    [path addLineToPoint:pt];
                }
            }
            [linePath.color set];
            [path setLineWidth:linePath.lineWith];
            [path stroke];
        }
    }
    
    
    //    if ([mLinePath isNeedDraw])
    //    {
    //        NSArray *drawPoints = [mLinePath getDrawPoints];
    //
    //        UIBezierPath *path = [UIBezierPath bezierPath];
    //
    //
    //        CGPoint startPt =[[drawPoints firstObject] CGPointValue];
    //        CGPoint endPt =[[drawPoints lastObject] CGPointValue];
    //        [path moveToPoint:startPt];
    //        [path addLineToPoint:endPt];
    //
    //        [mLinePath.color set];
    //        [path setLineWidth:mLinePath.lineWith];
    //
    //        [path stroke];
    //    }
    
    
    
    //    GkGkLinePath *path = [[GkGkLinePath alloc] init];
    
    ////    UIColor *alphaColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    ////    self.backgroundColor = alphaColor;
    //
    //    // sub view
    //    [[UIColor greenColor] setFill];
    //    [[UIColor redColor] setStroke];
    //
    //    UIBezierPath *testBox = [UIBezierPath bezierPathWithRect:CGRectMake(40, 100, 100, 100) ];
    //    [testBox setLineWidth:2];
    //    [testBox fill];
    //    [testBox stroke];
    //
    //    [self setNeedsDisplay];
    
}

@end
