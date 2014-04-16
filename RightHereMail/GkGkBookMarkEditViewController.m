//
//  GkGkBookMarkEditViewController.m
//  GMapTest
//
//  Created by pies on 2013/12/08.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkBookMarkEditViewController.h"

@interface GkGkBookMarkEditViewController ()

@end

@implementation GkGkBookMarkEditViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"start bookmarkedit view");

    [self setupBookMarkNameArea];
    
    [self setupTapEvent];
    
    [_txtBookMarkName becomeFirstResponder];

    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupBookMarkNameArea
{
    NSLog(@"setup bookmark input area start");
    
    
    UIView *accessoryView = [self generateCloseKeyboad];
    _txtBookMarkName.inputAccessoryView = accessoryView;
    _txtBookMarkName.delegate = self;
    // 削除ボタン追加
    [_txtBookMarkName setClearButtonMode:UITextFieldViewModeWhileEditing];

    [_txtBookMarkName setReturnKeyType:UIReturnKeyDone];
    
}

/**
 * キーボード閉じるエリア生成
 */
- (UIView *)generateCloseKeyboad
{
    // 閉じるボタン用view生成
    
    CGFloat closeViewHeight = 50.0;

    // screenSize
    CGRect scRect = [UIScreen mainScreen].bounds;
    
    UIView* accessoryView =
    [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(scRect),closeViewHeight)];
    // 半透明にするには、設定するカラーに半透明をかける
    accessoryView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

    // ボタンを作成する。
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    closeButton.frame = CGRectMake(210,10,btnWidth,btnHeight);
    closeButton.frame = [self keyboardCloseBtnRect:accessoryView.frame];
    
    
    // TODO 閉じるを画像もしくは多言語化
    [closeButton setTitle:@"閉じる" forState:UIControlStateNormal];
    
    // ボタンを押したときによばれる動作を設定する。
    [closeButton addTarget:self action:@selector(touchBackground:) forControlEvents:UIControlEventTouchUpInside];
    // ボタンをViewに貼る
    [accessoryView addSubview:closeButton];
    
    return accessoryView;
}

/**
 * キーボード閉じるボタンサイズ位置設定
 */
- (CGRect)keyboardCloseBtnRect:(CGRect)viewRect
{
    
    //    const CGFloat closeViewHeight = 50.0;
    const CGFloat btnWidth = 100.0;
    const CGFloat btnHeight = 30.0;
    
    CGFloat btnY = ((CGRectGetHeight(viewRect) - btnHeight) / 2.0);// + 10;
    CGFloat btnX = (CGRectGetWidth(viewRect) - btnWidth - 5.0);
    
    return  CGRectMake(btnX, btnY, btnWidth, btnHeight);
}


// キーボード完了ボタンクリックイベント
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if (textField == _txtBookMarkName)
    {
//        [self doSaveBookMark];
        if ([self doSaveBookMark])
        {
            [self doBackView];
        }
    }
    
    [self.view endEditing:YES];
    return YES;
}


- (IBAction)touchBackground:(id)sender {
    // 入力コントロール以外をタッチしたのでキーボードを閉じる
    [self.view endEditing:YES];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
    // キーボード画面サイズの取得
    CGRect keyboardRect; // キーボードのフレーム
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    
    // キーボードの位置サイズで閉じるボタンの位置サイズを設定
    UIView *accessoryView = _txtBookMarkName.inputAccessoryView;
    UIButton *closeBtn = [[accessoryView subviews] firstObject];
    closeBtn.frame = [self keyboardCloseBtnRect:accessoryView.frame];
    
}

// キーボード非表示通知
- (void)keyboardWillHide:(NSNotification *)notification {
    
}

// BookMark保存イベント
- (BOOL) doSaveBookMark
{
    GkGkAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    GkGkRHMManager *mng = [appDelegate dataManager];
    float lat = appDelegate.lat;
    float lng = appDelegate.lng;

    NSString *bmNm = [_txtBookMarkName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([bmNm isEqualToString:@""])
    {
        _txtBookMarkName.placeholder = @"ブックマーク名を入力して下さい";
        [_txtBookMarkName becomeFirstResponder];

        return NO;
    }
    _txtBookMarkName.placeholder = @"";
    

    GkGkBookMarkDao *dao = mng.bookMarkDao;
    BookMark *bmObj = [dao findByPoint:lat lng:lng];
    
    if (bmObj != nil)
    {
        // 同じ座標で既に存在
        UIActionSheet *as = [[UIActionSheet alloc] init];
        as.delegate = self;
        as.title = [NSString stringWithFormat:@"既に登録されています。\n上書きしますか？\nブックマーク名：[%@]" ,bmObj.title];
        [as addButtonWithTitle:@"上書き"];
        [as addButtonWithTitle:@"キャンセル"];
        as.cancelButtonIndex = 1;
        as.destructiveButtonIndex = 0;
        [as showInView:self.view];
        return NO;
    }
    else
    {
        // 新規のブックマーク
        [dao createBookMark:bmNm lat:lat lng:lng];
    }
    
    return YES;
}

// 上書き確認ActionSheet#delegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            // １番目のボタンが押されたときの処理を記述する
            [self overWriteBookMark];
            break;
        case 1:
            // ２番目のボタンが押されたときの処理を記述する
            [self doBackView];
            break;
    }
}

- (void)overWriteBookMark
{
    GkGkAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    GkGkRHMManager *mng = [appDelegate dataManager];
    float lat = appDelegate.lat;
    float lng = appDelegate.lng;
    NSString *bmNm = [_txtBookMarkName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    GkGkBookMarkDao *dao = mng.bookMarkDao;
    BookMark *bmObj = [dao findByPoint:lat lng:lng];
    
    if (bmObj != nil)
    {
        // 更新実行
        [dao updateBookMarkTitle:bmObj title:bmNm];
    }
    else
    {
        // 新規のブックマーク
        [dao createBookMark:bmNm lat:lat lng:lng];
    }
    [self doBackView];
    
}





- (void)setupTapEvent
{
    NSLog(@"setup tap event start");

    // 戻るセル
    UITapGestureRecognizer *cellBackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellBackView:)];
    _mCellBackView.userInteractionEnabled = YES;
    [_mCellBackView addGestureRecognizer:cellBackViewTap];
    
    NSLog(@"setup tap event end");
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSInteger section = [indexPath section];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"cellForRowAtIndexPath start");
    
    // static cellの場合は、存在しているので、superで取得
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell;
}

- (void)tapCellBackView:(id)sender
{
    NSLog(@"tap cell back view");
    [self doBackView];
//    [self performSegueWithIdentifier:@"unwindFromBMEdit" sender:self];
}

- (void)doBackView
{
    [self performSegueWithIdentifier:@"unwindFromBMEdit" sender:self];
}

//- (IBAction)doBackView:(id)sender {
//    
//    [self performSegueWithIdentifier:@"unwindFromBMEdit" sender:self];
//    
//    
//}

#pragma mark - Table view data source


@end
