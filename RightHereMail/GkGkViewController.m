//
//  GkGkViewController.m
//  GMapTest
//
//  Created by pies on 2013/11/11.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkViewController.h"

@interface GkGkViewController ()

@end

@implementation GkGkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _markerRequiredTp = GkGkReqMrkTpSelectSender;
    confirmNotExistsMarker = [[UIAlertView alloc] initWithTitle:@"マーカー未設定"
                                                      message:@"マーカーが画面上にありません.\n中心にセットしますか？"
                                                     delegate:self
                                            cancelButtonTitle:@"NO"
                                            otherButtonTitles:@"YES",nil];

    confirmNotExistsQuery = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"みつかりません。"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK",nil];
    
    
    // 位置情報初期化
    [self setupLocationManager];
    
    // 外部サービス接続系処理の初期化
    [self setupOuterService];
    
    // notification設定
    NSNotificationCenter *nc =[NSNotificationCenter defaultCenter];
    // キーボード表示非表示通知
    [nc addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification  // 表示時の通知
             object:nil];
    [nc addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification // 非表示時の通知
             object:nil];
    
/*
    // 対応しないので、とりあえず、コメントアウト
    // 画面方向変更通知
    [nc addObserver:self
           selector:@selector(deviceDidRotate:)
               name:UIDeviceOrientationDidChangeNotification object:nil];
    
*/
    
    // 検索住所フィールド初期化
    _mTxtSrcAddress.delegate = self;
    UIView *accessoryView = [self generateCloseKeyboad];
    _mTxtSrcAddress.inputAccessoryView = accessoryView;

    // 地図コンポーネント初期化
    [self setupMapCompornent];
    
    
    [_mapView bringSubviewToFront:_mToolBar];
    _mapView.layer.zPosition = 0;
    
    
    _mToolBar.layer.zPosition = 1;
    
    _mToolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self setupProcessGirdView];
    
    
    NSLog(@"viewDidLoad end.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 位置情報初期化
- (void)setupLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 500;
    
    [locationManager startUpdatingLocation];
}




// 地図コンポーネント初期化
- (void)setupMapCompornent
{

    // JR東京駅を初期位置にする
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.681382
                                                            longitude:139.766084
                                                                 zoom:16];
    
    [_mapView setCamera:camera];
    //_mapView.myLocationEnabled = YES;
    _mapView.buildingsEnabled = NO;
    _mapView.indoorEnabled = NO;
    _mapView.mapType = kGMSTypeNormal;
    _mapView.delegate = self;
    
    //_mapView.settings.myLocationButton = YES;
    _mapView.settings.compassButton = YES;
    
    
    // 目標地図マーカー初期化
    targetMarker = [[GMSMarker alloc] init];
    
    // 最寄り駅コンポーネント
    [self resetNearestStationCompornent];

}

// 最寄り駅コンポーネント初期化
- (void)resetNearestStationCompornent
{
    // 最寄り駅マーカー
    if (nsMarker)
    {
        nsMarker.map = nil;
    }
    // ２回目以降、再描画されないのでインスタンスを作り直す
    nsMarker = [[GMSMarker alloc] init];
    nsMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    nsMarker.appearAnimation = kGMSMarkerAnimationPop;
    nsMarker.tappable = YES;
    
    // 経路
    if (nsRoute)
    {
        nsRoute.map = nil;
    }
    nsRoute = [[GMSPolyline alloc] init];
    nsRoute.geodesic = YES;
    nsRoute.strokeWidth = 10.f;
    
}

// マーカータップイベント
-(BOOL) mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker
{
    if (marker == nsMarker)
    {
        // 最寄り駅マーカの場合、画面から消す
        [self resetNearestStationCompornent];
    }    
    return YES;
}


// 外部サービス処理セットアップ
- (void)setupOuterService
{

    // 住所検索エリア初期化
    [self setupAddrGeoSrcArea];

    // 最寄り駅検索エリア初期化
    [self setupSearchNearestStationView];
    
    // 共通結果ビューヘルパー初期化
    resultViewHelper = [[GkGkSimpleResultViewHelper alloc] initWithParent:self];
}


// 共通エラー通知
- (void)alertError:(NSString *)msg error:(NSError*)error
{
    NSLog(@"erro msg:%@" ,msg);
    if (error)
    {
        NSLog(@"error info:%@" ,error);
    }
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:msg
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:@"OK",nil] show];
}


- (CGFloat)heightByOrientation:(UIDeviceOrientation)o
{
    CGRect scRect = [UIScreen mainScreen].bounds;
    return UIDeviceOrientationIsLandscape(o) ? scRect.size.width : scRect.size.height;
}
- (CGFloat)widthByOrientation:(UIDeviceOrientation)o
{
    CGRect scRect = [UIScreen mainScreen].bounds;
    return UIDeviceOrientationIsLandscape(o) ? scRect.size.height : scRect.size.width;
}

- (CGRect)srcViewRect:(UIDeviceOrientation)orientation
{
//    CGRect scRect = [UIScreen mainScreen].bounds;
//    CGFloat width = (orientation == UIDeviceOrientationPortrait) ? scRect.size.width : scRect.size.height;
    return CGRectMake(0, 20, [self widthByOrientation:orientation], 40);
}

- (CGRect)srcAddrTxtRect:(UIDeviceOrientation)orientation
{
    CGFloat width = [self widthByOrientation:orientation];
    return CGRectMake(5, 5, width - 10 , 30);
}

- (CGRect)toolBarRect:(UIDeviceOrientation)orientation
{
    CGRect toolBarRect = _mToolBar.layer.frame;
    
    CGFloat width = [self widthByOrientation:orientation];
    //    CGRect viewRect = addrSrcView.layer.frame;
    return CGRectMake(toolBarRect.origin.x, toolBarRect.origin.y, width , toolBarRect.size.height);
}

// 住所検索初期化
- (void)setupAddrGeoSrcArea
{
    
    // 住所検索サービス初期化
    addressSearchService = [[GkGkAddressSearch alloc] init];
    addressSearchService.delegate = self;

    // 検索エリアViewの生成
    addrSrcView = [[UIView alloc] initWithFrame:[self srcViewRect:UIDeviceOrientationPortrait]];
    addrSrcView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:addrSrcView];

// TODO constraintsの設定は失敗したので後で考えよう。。。
//    addrSrcView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(addrSrcView);
//    
//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[addrSrcView]-0-|"
//                                                                              options:0
//                                                                              metrics:nil
//                                                                            views:viewsDictionary];
//    [self.view addConstraints:constraints];
    
    
    addrSrcView.layer.zPosition = 1;

    // 住所検索テキストボックス生成
    _mTxtSrcAddress = [[UITextField alloc] initWithFrame:CGRectZero];
    [_mTxtSrcAddress setReturnKeyType:UIReturnKeySearch];
    _mTxtSrcAddress.backgroundColor = [UIColor whiteColor];
    _mTxtSrcAddress.layer.borderWidth = 1;
    _mTxtSrcAddress.layer.borderColor = [[UIColor blackColor] CGColor];
    _mTxtSrcAddress.borderStyle = UITextBorderStyleRoundedRect;
//    mmTxtSrcAddress.translatesAutoresizingMaskIntoConstraints = NO;

    _mTxtSrcAddress.placeholder = @"検索する住所を入力";
    // 削除ボタン追加
    [_mTxtSrcAddress setClearButtonMode:UITextFieldViewModeWhileEditing];
    // キーボードを検索にする
    [_mTxtSrcAddress setReturnKeyType:UIReturnKeySearch];
    

    [addrSrcView addSubview:_mTxtSrcAddress];
    _mTxtSrcAddress.layer.zPosition = 1;
    _mTxtSrcAddress.layer.frame = [self srcAddrTxtRect:UIDeviceOrientationPortrait];


    UIView *accessoryView = [self generateCloseKeyboad];
    _mTxtSrcAddress.inputAccessoryView = accessoryView;
    _mTxtSrcAddress.delegate = self;

}

// 最寄り駅検索初期化
- (void)setupSearchNearestStationView
{
    
    // 最寄り駅検索モデル 初期化
    stationSearchService = [[GkGkNearestStationSearch alloc] init];
    stationSearchService.delegate = self;
    
    // 最寄駅ボタンViewの生成
    CGRect rct = CGRectMake(5, 65, 44, 44);
    nearestStationSrcView = [[UIView alloc] initWithFrame:rct];
    nearestStationSrcView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0];
    [self.view addSubview:nearestStationSrcView];
    UIImage *img = [UIImage imageNamed:@"rail.png"];
    _mBtnNStSrc = [[UIButton alloc] init];
    [_mBtnNStSrc setBackgroundImage:img forState:UIControlStateNormal];
    _mBtnNStSrc.frame = CGRectMake(0, 0, 44, 44);
    [nearestStationSrcView addSubview:_mBtnNStSrc];

    // 最寄り駅検索ボタンのイベント設定
    [_mBtnNStSrc addTarget:self action:@selector(tapNearestStationSrc:) forControlEvents:UIControlEventTouchUpInside];
}

// 最寄り駅検索タップイベント
- (IBAction)tapNearestStationSrc:(UIButton *)button
{
    NSLog(@"tap station search!");

    if (![_mapView.projection containsCoordinate:targetMarker.position])
    {
        NSLog(@"marker not exists on map 4 nearest stations...");
        [self askSetMarkerPosOnCenter:GkGkReqMrkTpSearchStation];
    }
    else
    {
        NSLog(@"marker exists on map 4 nearest stations.");
        [self startSearchNearestStations];
    }
}

// 最寄り駅検索実行
- (void)startSearchNearestStations
{
    if ([stationSearchService isConnecting])
    {
        NSLog(@"service processing now....");
        return;
    }

    // マーカー位置取得
    float lat = targetMarker.position.latitude;
    float lng = targetMarker.position.longitude;
    
    // ガード画面起動
    [self girdProcessing:YES];
    
    // 検索開始
    [stationSearchService searchStart:lat lng:lng];
}


// webサービス検索エラーイベント
- (void)service:(GkGkWebServiceManager *)service didFailWithErrorOnGkGkWebSvc:(NSError *)error
{
    [service setConnStatDisconnected];

    // ガード画面終了
    [self girdProcessing:NO];

    NSString *msg = @"検索出来ませんでした。";
//    NSString *msg;
//    if (service == stationSearchService)
//    {
//        msg = @"最寄り駅の検索に失敗しました.";
//    }
//    else {
//        msg = @"検索に失敗しました.";
//    }

    [self alertError:msg error:error];
}
// webサービス検索完了イベント
- (void)service:(GkGkWebServiceManager *)service didReceiveCompleteOnGkGkWebSvc:(NSObject *)resultData;
{
    
    [service setConnStatDisconnected];
    
    // ガード画面終了
    [self girdProcessing:NO];

    if (service == stationSearchService)
    {
        // 最寄り駅の検索完了処理を実行
        [self didReceiveComplete4SrcStation:(GkGkWebSrvResult*)resultData];
    }
    else
    {
        // 住所検索の場合
        [self didReceiveComplete4SrcAddr:(GkGkWebSrvResult*)resultData];
    }
}

// 住所検索完了イベント
- (void)didReceiveComplete4SrcAddr:(GkGkWebSrvResult *)result
{
    if (result.isNotFound)
    {
        [confirmNotExistsQuery setMessage:@"見つかりませんでした。"];
        [confirmNotExistsQuery show];
    }
    else
    {
        if ([[result searchResults] count] > 1)
        {
            // 取得結果が複数の場合、結果選択ビュー表示
            GkGkAdrSrcResultViewModel *model = [[GkGkAdrSrcResultViewModel alloc]
                                                initWithResults:[result searchResults]];
            [resultViewHelper showResultView:model];
        }
        else
        {
            // 取得結果が１件
            [self moveSearchAddressPoint:[[result searchResults] firstObject]];
        }
        
    }
}

// 検索した住所にマーカーをセット
- (void)moveSearchAddressPoint:(NSDictionary *)addrData
{
    float lat = [[addrData objectForKey:@"lat"] floatValue];
    float lng = [[addrData objectForKey:@"lng"] floatValue];
    
    [_mapView animateToLocation:CLLocationCoordinate2DMake(lat , lng)];
    
    [self setMarker:lat lng:lng];
}

// 最寄り駅検索完了イベント
- (void)didReceiveComplete4SrcStation:(GkGkWebSrvResult *)result
{
    if (result.isNotFound)
    {
        [confirmNotExistsQuery setMessage:@"見つかりませんでした。"];
        [confirmNotExistsQuery show];
    }
    else
    {
        if ([[result searchResults] count] > 1)
        {
        // 取得結果が複数
            // 結果ビュー処理モデル作成
            GkGkNStSrcResultViewModel *model = [[GkGkNStSrcResultViewModel alloc]
                                                initWithResults:[result searchResults]];
            // 結果選択ビューの表示
            [resultViewHelper showResultView:model];
        }
        else
        {
        // 取得結果が１件
            [self foundNearestStation:[[result searchResults] firstObject]];
        }
    }
    
}

// 最寄り駅見つかった処理
- (void)foundNearestStation:(NSDictionary *)stationPoint
{
    NSLog(@"found nearest station!");

    // 最寄り駅部品のリセット
    [self resetNearestStationCompornent];

    // 現在の視点
    CLLocationCoordinate2D curLoc = _mapView.camera.target;
    
    
    // 最寄り駅に視点移動
    double nsLng = [(NSNumber *)[stationPoint valueForKey:@"lng"] doubleValue];
    double nsLat = [(NSNumber *)[stationPoint valueForKey:@"lat"] doubleValue];
    CLLocationCoordinate2D nsLoc = CLLocationCoordinate2DMake(nsLat, nsLng);
    
    [_mapView animateToLocation:nsLoc];

    // 最寄り駅マーカーの座標設定
    nsMarker.position = nsLoc;
    nsMarker.map = _mapView;

/*
    // 最寄り駅までの経路探索実行
    NSMutableDictionary *locData = [[NSMutableDictionary alloc] init];
    [locData setValue:[[NSNumber alloc] initWithDouble:nsLoc.latitude] forKey:@"nsLoc.lat"];
    [locData setValue:[[NSNumber alloc] initWithDouble:nsLoc.longitude] forKey:@"nsLoc.lng"];
    [locData setValue:[[NSNumber alloc] initWithDouble:curLoc.latitude] forKey:@"curLoc.lat"];
    [locData setValue:[[NSNumber alloc] initWithDouble:curLoc.longitude] forKey:@"curLoc.lng"];
    [self performSelector:@selector(searchRoute4NearestStation:)
               withObject:locData afterDelay:0.5];
*/
    
    // 最寄り駅までの経路探索と経路描画
    // マーカー位置
    CLLocationCoordinate2D fromCoordinate = nsLoc;
    // 最寄り駅位置
    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(targetMarker.position.latitude ,
                                                                     targetMarker.position.longitude);
    // 経路開始-終了を設定
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                       addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                       addressDictionary:nil];
    // MKPlacemark から MKMapItem を生成
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    request.transportType = MKDirectionsTransportTypeWalking;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

    // ガード開始
    [self girdProcessing:YES];
    // 経路検索を実行
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         
         if (error)
         {
             [self alertError:@"経路検索に失敗しました." error:error];
         }
         
         if ([response.routes count] > 0)
         {
             MKRoute *route = [response.routes objectAtIndex:0];

             GMSMutablePath *nsPath = [GMSMutablePath path];
             // 経路を設定
             NSArray *routeSteps = route.steps;
             for (id obj in routeSteps) {
                 // do something with object
                 MKRouteStep *step = (MKRouteStep *)obj;
                 MKPolyline *pl = step.polyline;
                 [nsPath addCoordinate:pl.coordinate];
                 NSLog(@"...");
             
             }

             // 経路を描画
             nsRoute.map = nil;
             nsRoute.path = nsPath;
             nsRoute.map = _mapView;
             
             [_mapView animateToLocation:curLoc];
         }
         
         // ガード解除
         [self girdProcessing:NO];
         [_mapView setNeedsDisplay];
         
     }];
}

// 経路探索と描画
// deparacated
//- (void)searchRoute4NearestStation:(NSDictionary *)locData
//{
//
//    double nsLat = [(NSNumber *)[locData valueForKey:@"nsLoc.lat"] doubleValue];
//    double nsLng = [(NSNumber *)[locData valueForKey:@"nsLoc.lng"] doubleValue];
//    CLLocationCoordinate2D nsLoc = CLLocationCoordinate2DMake(nsLat, nsLng);
//    double curLat = [(NSNumber *)[locData valueForKey:@"curLoc.lat"] doubleValue];
//    double curLng = [(NSNumber *)[locData valueForKey:@"curLoc.lng"] doubleValue];
//    CLLocationCoordinate2D curLoc = CLLocationCoordinate2DMake(curLat, curLng);
//    
//    // 経路を引く
//    // 最寄り駅位置
//    CLLocationCoordinate2D fromCoordinate = nsLoc;
//    
//    // ターゲット位置
//    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(targetMarker.position.latitude ,
//                                                                     targetMarker.position.longitude);
//    
//    // 経路開始-終了を設定
//    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
//                                                       addressDictionary:nil];
//    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
//                                                       addressDictionary:nil];
//    // MKPlacemark から MKMapItem を生成
//    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
//    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
//    
//    // MKMapItem をセットして MKDirectionsRequest を生成
//    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
//    request.source = fromItem;
//    request.destination = toItem;
//    request.transportType = MKDirectionsTransportTypeWalking;
//    request.requestsAlternateRoutes = YES;
//    
//    // MKDirectionsRequest から MKDirections を生成
//    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
//    
//    // ガード開始
//    [self girdProcessing:YES];
//    
//    // 経路検索を実行
//    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
//     {
//         
//         if (error)
//         {
//             [self alertError:@"経路検索に失敗しました." error:error];
//         }
//         
//         if ([response.routes count] > 0)
//         {
//             MKRoute *route = [response.routes objectAtIndex:0];
//             //             NSLog(@"distance: %.2f meter", route.distance);
//             
//             GMSMutablePath *nsPath = [GMSMutablePath path];
//             
//             // 経路を設定
//             NSArray *routeSteps = route.steps;
//             for (id obj in routeSteps) {
//                 // do something with object
//                 MKRouteStep *step = (MKRouteStep *)obj;
//                 MKPolyline *pl = step.polyline;
//                 [nsPath addCoordinate:pl.coordinate];
//                 NSLog(@"...");
//                 
//             }
//             
//             // 経路を描画
//             nsRoute.map = nil;
//             nsRoute.path = nsPath;
//             nsRoute.map = _mapView;
//             
//         }
//         
//         [_mapView animateToLocation:curLoc];
//
//         // ガード解除
//         [self girdProcessing:NO];
//         
//     }];
//    
//}

// 検索結果選択キャンセルイベント
- (void)didCancelSimpleResultView
{
    NSLog(@"cancel from SimpleResultView...");
}
// 検索結果選択イベント
- (void)didSelectSimpleResultViewData:(GkGkBaseSimpleResultViewData *)resultData
{
    NSLog(@"select data from SimpleResultView!!!!");
    
    if ([resultData isKindOfClass:[GkGkNstSrcResultViewData class]])
    {
        // 最寄り駅検索結果選択の場合
        GkGkNstSrcResultViewData *nstSrcResult = (GkGkNstSrcResultViewData *)resultData;
        NSDictionary *nstSrcData = (NSDictionary *)nstSrcResult.resultData;
        [self foundNearestStation:nstSrcData];
    }
    else
    {
        // 住所検索の場合
        GkGkAdrSrcResultViewData *nstSrcResult = (GkGkAdrSrcResultViewData *)resultData;
        NSDictionary *addrData = (NSDictionary *)nstSrcResult.resultData;
        [self moveSearchAddressPoint:addrData];
        
    }
}

// 外部サービスキャンセルイベント
- (void)didCancelServiceOnGkGkWebSvc:(GkGkWebServiceManager *)service
{
    // インジケータ非表示
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [service setConnStatDisconnected];
    [self girdProcessing:NO];
}




/**
 * 処理中画面ガード処理.
 */
- (void)girdProcessing:(BOOL)processStat
{
    if (processStat)
    {
        // 処理中インジケータ、ガードViewの表示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [processGirdView setHidden:NO];
    }
    else
    {
        // 処理中インジケータ、ガードViewの非表示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [processGirdView setHidden:YES];
    }
}
// 処理中画面初期化
- (void)setupProcessGirdView
{
    // ガードViewの生成
    processGirdView = [[UIView alloc] initWithFrame:[self.view bounds]];
    processGirdView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:processGirdView];

    // Tweet送信セル
    UITapGestureRecognizer *girdViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapGirdView:)];
    processGirdView.userInteractionEnabled = YES;
    [processGirdView addGestureRecognizer:girdViewTap];
    processGirdView.layer.zPosition = 99;
    [self girdProcessing:NO];
}
// 処理中画面タップイベント
- (void)tapGirdView:(id)sender
{
    NSLog(@"tap gird view!!!!");
    
}


- (IBAction)callConfigView:(id)sender {
/*
//    AudioServicesPlaySystemSound(shutterSoundId);
    // シャッター音をならす
    AudioServicesPlaySystemSound(1108);
    UIGraphicsBeginImageContext(_mapView.frame.size);
//    _mapView.myLocationEnabled = FALSE;
//    _mapView.settings.myLocationButton = FALSE;
    [_mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(mapImage, self, nil, nil);
//    _mapView.myLocationEnabled = TRUE;
//    _mapView.settings.myLocationButton = TRUE;
*/
    // TODO ActionSheetを開きConfigとbookmark画面を切り替える
    if (YES)
    {
    // bookmarkの場合
        [self callBookmarkView];
        
    }
}

// ブックマーク画面移動
- (void)callBookmarkView
{
    [self performSegueWithIdentifier:@"segueBookmarkView" sender:self];
}


// 現在地移動
- (IBAction)goMylocation:(id)sender {

    if (![CLLocationManager locationServicesEnabled])
    {
        // 位置情報が無効
        [self alertError:@"位置情報を取得できません." error:nil];
        return;
    }

    if (myLocation)
    {
        float lat = myLocation.coordinate.latitude;
        float lng = myLocation.coordinate.longitude;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lng
                                                                     zoom:17];
        
        [_mapView setCamera:camera];
        [self setMarker:lat lng:lng];
    }
/*
    if ([CLLocationManager locationServicesEnabled] && startLocation)
    {
        startLocation = FALSE;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;

//        // 大幅変更位置情報
//        [locationManager startMonitoringSignificantLocationChanges];

        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        locationManager.distanceFilter = 500;
        
        [locationManager startUpdatingLocation];
    
    }
    else
    {
        startLocation = TRUE;
    }
*/
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if (textField == _mTxtSrcAddress) {
        NSLog(@"search");
        
        NSString *srcAddr = [_mTxtSrcAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![srcAddr isEqualToString:@""]) {
            
            [self searchLatitudeByAddr:srcAddr];
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
    UIView *accessoryView =_mTxtSrcAddress.inputAccessoryView;
    UIButton *closeBtn = [[accessoryView subviews] firstObject];
    closeBtn.frame = [self keyboardCloseBtnRect:accessoryView.frame];
        
}

// キーボード非表示通知
- (void)keyboardWillHide:(NSNotification *)notification {
    
}

// 画面向き変更通知
- (void)deviceDidRotate:(NSNotification *)notification {
    
    UIDevice *device = [notification object];
    UIDeviceOrientation orientation = [device orientation];
    
    addrSrcView.layer.frame = [self srcViewRect:orientation];

    _mTxtSrcAddress.layer.frame = [self srcAddrTxtRect:orientation];

//
    
    // TODO やってみたけど、うまくいかない。。。
    [_mToolBar.layer setFrame:[self toolBarRect:orientation]];
}


- (void)searchLatitudeByAddr:(NSString *)addr
{
    
    // インジケータ表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [addressSearchService searchStart:addr];

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
    const CGFloat btnWidth = 100.0;
    const CGFloat btnHeight = 30.0;
    
    CGFloat btnY = (CGRectGetHeight(viewRect) - btnHeight) / 2.0;
    CGFloat btnX = (CGRectGetWidth(viewRect) - btnWidth - 5.0);
    
    return  CGRectMake(btnX, btnY, btnWidth, btnHeight);
}


- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self setMarker:coordinate.latitude lng:coordinate.longitude];
}

- (void)setMarker:(float)lat lng:(float)lng
{
    targetMarker.position = CLLocationCoordinate2DMake(lat, lng);
    targetMarker.title = @"Right Here!";
    targetMarker.snippet = @"I'm right here!";
    targetMarker.map = _mapView;
    // 対象マーカーがセットされたので、最寄り駅をリセット
    [self resetNearestStationCompornent];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations start.");

/*
    [locationManager stopMonitoringSignificantLocationChanges];
    if (!startLocation)
    {
        [locationManager stopMonitoringSignificantLocationChanges];
    }

    startLocation = TRUE;
    CLLocation *loc = [locations lastObject];
*/
    
    
    CLLocation *loc = [locations lastObject];

    
    NSDate *evenDate = loc.timestamp;
    NSTimeInterval howRecent = [evenDate timeIntervalSinceNow];
    
    if (howRecent < 15.0)
    {        
        myLocation = loc;
    }
/*
    float lat = loc.coordinate.latitude;
    float lng = loc.coordinate.longitude;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lng
                                                                 zoom:17];
    
    [_mapView setCamera:camera];
    [self setMarker:lat lng:lng];
*/
}


- (void)askSetMarkerPosOnCenter:(GkGkRequireMarkerType)reqType
{
    _markerRequiredTp = reqType;
    [confirmNotExistsMarker show];
}

- (IBAction)callSelectView:(id)sender {
    
    if (![_mapView.projection containsCoordinate:targetMarker.position])
    {
        NSLog(@"marker not exists on map.");
        [self askSetMarkerPosOnCenter:GkGkReqMrkTpSelectSender];
    }
    else
    {
        NSLog(@"marker exists on map!");
//        [self performSegueWithIdentifier:@"segueSelectSender" sender:self];
        [self moveSelectSenderView];
    }
}


/**
 * 送信タイプ選択画面へ遷移
 */
- (void)moveSelectSenderView
{
    // appDelegateに現在の地図イメージを保持
    GkGkAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.myLocationMap = [self extractMapImage];
    appDelegate.lat = targetMarker.position.latitude;
    appDelegate.lng = targetMarker.position.longitude;

    [self performSegueWithIdentifier:@"segueSelectSender" sender:self];
}


- (UIImage *)extractMapImage
{
    UIGraphicsBeginImageContext(_mapView.frame.size);
    [_mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return mapImage;
//    UIImageWriteToSavedPhotosAlbum(mapImage, self, nil, nil);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"select idx:%d",(int)buttonIndex);
    
    if (confirmNotExistsMarker == alertView && buttonIndex == 1)
    {
        // 中心位置にマーカーをセット
        float lat = _mapView.camera.target.latitude;
        float lng = _mapView.camera.target.longitude;
        [self setMarker:lat lng:lng];
        [_mapView.layer setNeedsDisplay];
        [_mapView.layer displayIfNeeded];
        [self.view.layer setNeedsDisplay];
        [self.view.layer displayIfNeeded];
        [_mapView.layer display];
        [self.view.layer display];

        
        if (_markerRequiredTp == GkGkReqMrkTpSelectSender)
        {
            // 画面にいない時、ダイアログが再描画を邪魔するので、
            // 遅延して次ビュー遷移イベントを起動する
            NSLog(@"marker set 4 select sender....");
            [self performSelector:@selector(moveSelectSenderView)
                       withObject:nil afterDelay:0.5];
        }
        else {
            // 中心位置から最寄り駅検索処理を起動
            NSLog(@"marker set 4 search nearest stations....");
            [self startSearchNearestStations];
        }
        
    }
    
}

/**
 * seque戻り
 */
- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"First view return action invoked:[%@]" ,[segue identifier]);
    NSString *prevViewId = [segue identifier];

    if ([prevViewId isEqualToString:@"unwindFromBookMapView"])
    {
        // ブックマーク戻りの場合
        GkGkAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        float lat = appDelegate.bmLat;
        float lng = appDelegate.bmLng;

        if (lat != -1.0 && lng != -1.0)
        {
            [self moveToBookMarkPotision:lat lng:lng];
        }
    }
}

/**
 * bookmark移動
 */
- (void)moveToBookMarkPotision:(float)lat lng:(float)lng
{
    NSLog(@"start move to BookMark position.");
    [_mapView animateToLocation:CLLocationCoordinate2DMake(lat , lng)];
    [self setMarker:lat lng:lng];

}


@end
