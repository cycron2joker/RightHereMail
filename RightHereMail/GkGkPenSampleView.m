//
//  GkGkPenSampleView.m
//  GMapTest
//
//  Created by pies on 2013/11/29.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkPenSampleView.h"

@implementation GkGkPenSampleView




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

        _curPenSize = 3;
        _curPenColor = [UIColor blackColor];
        
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{

    CGRect vRect = self.layer.frame;
    
    
    float x = vRect.size.width / 2;
    float y = vRect.size.height / 2;
    

    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y)
                                                         radius:((_curPenSize / 2) + 1)
                                                     startAngle:0
                                                       endAngle:((M_PI * 360)/ 180)
                                                      clockwise:YES];

    [_curPenColor set];
    [aPath setLineWidth:1];
    [aPath fill];
    [aPath stroke];
    
    
    

}

@end
