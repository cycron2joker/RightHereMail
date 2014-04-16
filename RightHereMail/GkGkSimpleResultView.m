//
//  GkGkSimpleResultView.m
//  RightHereMail
//
//  Created by pies on 2014/03/17.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkSimpleResultView.h"

@implementation GkGkSimpleResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.frame  = [[UIScreen mainScreen] bounds];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    NSLog(@"start initWithCoder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.frame  = [[UIScreen mainScreen] bounds];
    }
    return self;
}


- (void)setupView
{
    // Initialization code
    
    // 透明にする
    //self.alpha = 0;
    
    //_mContainerView.layer.backgroundColor = [[UIColor greenColor] CGColor];

    // 自身のサイズを親のサイズに設定
    self.layer.frame  = [[UIScreen mainScreen] bounds];
    
    
    UIColor *color = [UIColor darkGrayColor];
    UIColor *alphaColor = [color colorWithAlphaComponent:0]; //透過率
    self.backgroundColor = alphaColor;
    
    _mContainerView.layer.backgroundColor = [alphaColor CGColor];
//    _mContainerView.layer.frame = [sc bounds];
    
    // UIButtonは背景色を設定できない。->Quazで動的に画像を作って設定するとできるぽい
    //    _mBtnCancel.backgroundColor = [UIColor whiteColor];
    
    CGRect gggg = _mBtnCancel.frame;
    
    gggg = _mContainerView.frame;
    
    _mBtnCancel.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    
    
    // 結果テーブル初期化
//    [self setupResultTableView:nil];
    
    
}

- (void)showResult:(GkGkBaseSimpleResultViewModel *)model
{

    [self setupView];
    
    _model = model;
    
    // 空セルの枠線除去
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [_mTableView setTableHeaderView:v];
    [_mTableView setTableFooterView:v];

    
    // 画面再描画の為に、 一旦、datasourceとdelegateをクリア
    _mTableView.dataSource = nil;
    _mTableView.delegate = nil;
    [_mTableView setNeedsDisplay];
    // delegate,datasource設定
    _mTableView.dataSource = self;
    _mTableView.delegate = self;

    [self setHidden:NO];
}


- (void)setupResultTableView:(NSArray *)lst
{
/*
    // 結果テーブル初期化
    mResults = lst;
    
    // 空セルの枠線除去
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [_mTblSrcResults setTableHeaderView:v];
    [_mTblSrcResults setTableFooterView:v];
    
    if (_mTblSrcResults.dataSource)
    {
        // 画面再描画の為に、
        // 一旦、datasourceとdelegateをクリア
        _mTblSrcResults.dataSource = nil;
        _mTblSrcResults.delegate = nil;
        [_mTblSrcResults setNeedsDisplay];
    }
    // delegate,datasource設定
    _mTblSrcResults.dataSource = self;
    _mTblSrcResults.delegate = self;
*/
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection start");
    if (_model)
    {
        return [_model.resultList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath start");
    
    return [_model setupCell:tableView indexPath:indexPath];
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 選択セルのデータ
    GkGkBaseSimpleResultViewData *resultData = [_model extractSelectedData:indexPath];
    [_delegate doSelectCellData:resultData];
}





- (IBAction)doCancel:(id)sender
{
    NSLog(@"tap cancel button...");
    [_delegate doCancel];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
