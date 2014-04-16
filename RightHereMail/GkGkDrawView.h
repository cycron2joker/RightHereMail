//
//  GkGkDrawView.h
//  GMapTest
//
//  Created by pies on 2013/11/24.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GkGkLinePath.h"

@interface GkGkDrawView : UIView
{
//    NSMutableArray *mLines;
}

@property (nonatomic ,assign) NSMutableArray *mLines;
@property (nonatomic ,strong) UIColor *curPenColor;
@property double curPenSize;


- (void)beginLine:(UIColor *)penColor penSize:(double)penSize;
- (void)setTouchPoint:(CGPoint)point;
- (void)setEndTouch:(CGPoint) point;

    
@end
