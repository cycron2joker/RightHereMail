//
//  GkGkSimpleResultViewHelper.m
//  RightHereMail
//
//  Created by pies on 2014/03/26.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkSimpleResultViewHelper.h"

@implementation GkGkSimpleResultViewHelper


- (id)initWithParent:(UIViewController *)parent
{
    self = [super init];
    if (self) {
        //
        _delegate = parent;
        _resultView = [[[NSBundle mainBundle] loadNibNamed:@"GkGkSimpleResultView" owner:self options:nil] firstObject];

        _resultView.delegate = self;
        
        [parent.view addSubview:_resultView];
        [_resultView bringSubviewToFront:parent.view];
        _resultView.layer.zPosition = 99;

        [_resultView setHidden:YES];
        
    }
    return self;
}

- (void)showResultView:(GkGkBaseSimpleResultViewModel *)model
{
    [_resultView showResult:model];
}

- (void)doCancel
{
    [_resultView setHidden:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelSimpleResultView)])
    {
        id<GkGkPSimpleResultVParent> parent = _delegate;
        [parent didCancelSimpleResultView];
    }
}
- (void)doSelectCellData:(GkGkBaseSimpleResultViewData *)resultData
{
    [_resultView setHidden:YES];

    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSimpleResultViewData:)])
    {
        id<GkGkPSimpleResultVParent> parent = _delegate;
        [parent didSelectSimpleResultViewData:resultData];
    }
    
}

@end
