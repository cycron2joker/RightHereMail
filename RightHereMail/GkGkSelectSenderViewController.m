//
//  GkGkSelectSenderViewController.m
//  GMapTest
//
//  Created by pies on 2013/11/23.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkAppDelegate.h"
#import "GkGkSelectSenderViewController.h"

@interface GkGkSelectSenderViewController ()

enum SEC_OPE {
    sectionMapDraw,
    sectionBookMark,
    sectionSelectSender,
    sectionBackView
};

typedef enum SEC_OPE SEC_OPE;

enum SEL_OPE {
    selectSendMail,
    selectTwitter
};

typedef enum SEL_OPE SEL_OPE;

@end

@implementation GkGkSelectSenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"select_sender_view load start");
    
    
    // appDelegateに現在の地図イメージを保持
    GkGkAppDelegate *appDelegate = [self appDelegate];
    UIImage *mapImage = appDelegate.myLocationMap;
    [_mImgMyLoc setImage:mapImage];

    
    _mImgMyLoc.layer.borderWidth = 1;
    _mImgMyLoc.layer.borderColor = [[UIColor blackColor] CGColor];
    _mImgMyLoc.layer.cornerRadius = 5;

    
    // 添付フラグon
    _mAttachSwitch.on = YES;

    // 描画イメージ初期化
    _drawMapImage = NULL;
    // パスリスト初期化
    _drawLines = [[NSMutableArray alloc] init];
    
    
    [self setupTapEvent];
    

    NSLog(@"select_sender_view load end");
}


- (GkGkAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}


- (void)setupTapEvent
{
    NSLog(@"setup tap event start");

    // 地図イメージ
    UITapGestureRecognizer *myLocImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMylocationImage:)];
    _mImgMyLoc.userInteractionEnabled = YES;
    [_mImgMyLoc addGestureRecognizer:myLocImgTap];
    
    // 戻るセル
    UITapGestureRecognizer *cellBackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellBackView:)];
    _mCellBackView.userInteractionEnabled = YES;
    [_mCellBackView addGestureRecognizer:cellBackViewTap];
    
    // bookmarkセル
    UITapGestureRecognizer *cellBookMarkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellEditBookMark:)];
    _mCellBMEdit.userInteractionEnabled = YES;
    [_mCellBMEdit addGestureRecognizer:cellBookMarkTap];

    // メール送信セル
    UITapGestureRecognizer *cellSendMailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellSendMail:)];
    _mCellSendMail.userInteractionEnabled = YES;
    [_mCellSendMail addGestureRecognizer:cellSendMailTap];
    
    // Tweet送信セル
    UITapGestureRecognizer *cellTweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellTweet:)];
    _mCellTweet.userInteractionEnabled = YES;
    [_mCellTweet addGestureRecognizer:cellTweetTap];
    
    NSLog(@"setup tap event end");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tapMylocationImage:(id)sender
{
    NSLog(@"tap location image");
    [self performSegueWithIdentifier:@"segueCallDrawMap" sender:self];
}

- (void)tapCellBackView:(id)sender
{
    NSLog(@"tap cell back view");
    [self backView];
}

- (void)tapCellEditBookMark:(id)sender
{
    NSLog(@"tap cell edit bookmark");
    [self startupBookMarkRegView];
}

- (void)tapCellSendMail:(id)sender
{
    NSLog(@"tap cell send mail");
    [self startupMailView];
}

- (void)tapCellTweet:(id)sender
{
    NSLog(@"tap cell tweet");
    [self startupTwitterView];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSLog(@"detect table-cell touched");
    
    // static-cellのせいかどうか分からないが、
    // tapの仕方によってsegueの移動が見かけ上しない事がある
    // なので、丸ごとgestureイベントでtapを検知する事にする
    
//    NSInteger section = [indexPath section];
//    NSInteger selectedIdx;
//
//    switch (section)
//    {
//        case sectionBackView:
//            [self backView];
//            break;
//            
//        case sectionBookMark:
//            [self startupBookMarkRegView];
//            break;
//
//        case sectionSelectSender:
//
//            selectedIdx = indexPath.row;
//            if (selectedIdx == selectSendMail)
//            {
//                [self startupMailView];
//            }
//            else
//            {
//                [self startupTwitterView];                
//            }
//            break;
//            
//        default:
//            break;
//    }
}

- (void)backView
{
    NSLog(@"execute backview");
    [self performSegueWithIdentifier:@"unwindSeguePointMapView" sender:self];
}

- (void)startupBookMarkRegView
{
    NSLog(@"execute call edit bookmarkview");
    [self performSegueWithIdentifier:@"segueBookMarkRegView" sender:self];
    
}


- (UIImage *)attachMapImage
{
    
    if (!_mAttachSwitch.on)
    {
        return nil;
    }
    
    UIImage *atcMapImg = nil;

    
    if (_drawMapImage)
    {
        atcMapImg = _drawMapImage;
    }
    else
    {
        GkGkAppDelegate *appDelegate = [self appDelegate];
        atcMapImg = appDelegate.myLocationMap;
    }

    return atcMapImg;
}

- (NSString *)myLocationUrlStr
{
    GkGkAppDelegate *appDelegate = [self appDelegate];
    float lat = appDelegate.lat;
    float lng = appDelegate.lng;
    return [NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f", lat,lng];
}


- (void)startupMailView
{

    
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    // 題名を設定
    [mailPicker setSubject:@"今ココ！"];

    // メール本文を設定
//    NSString *msgBody =  [NSString stringWithFormat:@"ここにいます。\nhttp://maps.google.com/maps?q=%f,%f+(Right+here!!!)", lat,lng];
//    NSString *msgBody =  [NSString stringWithFormat:@"ここにいます。\nhttp://maps.google.com/maps?q=%f,%f", lat,lng];
    NSString *msgBody =  [NSString stringWithFormat:@"ここにいます。\n%@", [self myLocationUrlStr]];
    
    //http://maps.google.com/maps?q=35.656573,139.69952+(Right+here!!!)
    
    [mailPicker setMessageBody:msgBody isHTML:NO];
    
    // 宛先を設定
    //    [mailPicker setToRecipients:[NSArray arrayWithObjects:@"aaa@bbb", @"ccc@ddd", nil]];
    
    // 添付ファイルを設定
    UIImage *atcMapImg = [self attachMapImage];
    if (atcMapImg)
    {
        NSData* fileData = UIImagePNGRepresentation(atcMapImg);
        [mailPicker addAttachmentData:fileData mimeType:@"image/png" fileName:@"map.png"];
    }
    
    /*
     NSString *imagePath = [NSString stringWithFormat:@"%@/test.gif" , [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
     NSData* fileData = [NSData dataWithContentsOfFile:imagePath];
     [mailPicker addAttachmentData:fileData mimeType:@"image/gif" fileName:imagePath];
     */
    
    // メール送信用のモーダルビューを表示
    [self presentViewController:mailPicker animated:TRUE completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result){
        case MFMailComposeResultCancelled:  // キャンセル
            break;
        case MFMailComposeResultSaved:      // 保存
            break;
        case MFMailComposeResultSent:       // 送信成功
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
            //                                                            message:@"送信に成功しました"
            //                                                           delegate:nil
            //                                                  cancelButtonTitle:nil
            //                                                  otherButtonTitles:@"OK", nil];
            //            [alert show];
            //            [alert release];
            
            // TODO 飛ばしたら、最初の画面に戻す?
            
            break;
        }
        case MFMailComposeResultFailed:     // 送信に失敗した場合
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                        message:@"送信に失敗しました"
                                        delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"OK", nil];
            [alert show];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];  // iOS6以降
}

- (void)startupTwitterView
{
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    void (^completion) (SLComposeViewControllerResult result) = ^(SLComposeViewControllerResult result) {
        [composeViewController dismissViewControllerAnimated:YES completion:nil];
    };
    [composeViewController setCompletionHandler:completion];
    
    NSString *tweetMsg =  @"今ココ!\n";//[NSString stringWithFormat:@"今ココ!\n%@", [self myLocationUrlStr]];
    [composeViewController setInitialText:tweetMsg];
    [composeViewController addURL:[NSURL URLWithString:[self myLocationUrlStr] ]];
    
    UIImage *atcMapImg = [self attachMapImage];
    if (atcMapImg)
    {
        [composeViewController addImage:atcMapImg];
    }
    [self presentViewController:composeViewController animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueCallDrawMap"]) {
        //遷移先のViewControllerインスタンスを取得
        GkGkDrawMapViewController *vc = segue.destinationViewController;
        vc.drawDataList = _drawLines;
    }
}

/**
 * seque戻り
 */
- (IBAction)returnActionForSegue:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"uwindSegueSenderView"]) {
        //遷移元のViewControllerインスタンスを取得
        GkGkDrawMapViewController *vc = segue.sourceViewController;
        _drawMapImage = vc.drawMapImage;
        [_mImgMyLoc setImage:_drawMapImage];
    }
    
    NSLog(@"unwind!!");
}


@end
