//
//  GkGkViewController.h
//  GMapTest
//
//  Created by pies on 2013/11/11.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <AudioToolbox/AudioToolbox.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "GkGkAppDelegate.h"


#import "GkGkNearestStationSearch.h"
#import "GkGkAddressSearch.h"

#import "GkGkSelectSenderViewController.h"

#import "GkGkSimpleResultViewHelper.h"
#import "GkGkNStSrcResultViewModel.h"
#import "GkGkAdrSrcResultViewModel.h"
#import "GkGkAdrSrcResultViewData.h"

@interface GkGkViewController : UIViewController <UITextFieldDelegate,GMSMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate ,GkGkWebServiceManagerDelegate,GkGkPSimpleResultVParent>
{
    
    // ロケーションマネジャー
    CLLocationManager *locationManager;
    
    // 目標地図マーカー
    GMSMarker *targetMarker;

    // 最寄り駅地図マーカー
    GMSMarker *nsMarker;

    // 最寄り駅経路
    GMSPolyline *nsRoute;
    
    // 現在位置
    CLLocation *myLocation;
    
    
    // 住所検索エリア
    UIView *addrSrcView;

    // 最寄り駅検索ボタンビュー
    UIView *nearestStationSrcView;

    // 処理中ガードビュー
    UIView *processGirdView;
    
    // 画面にマーカーが無い場合の確認ダイアログ
    UIAlertView *confirmNotExistsMarker;

    // 検索結果が無い場合の確認ダイアログ
    UIAlertView *confirmNotExistsQuery;

    // 住所経緯度検索モデル
    GkGkAddressSearch *addressSearchService;

    // 最寄り駅経緯度検索サービス
    GkGkNearestStationSearch *stationSearchService;
    
    // 結果ビューhelper
    GkGkSimpleResultViewHelper *resultViewHelper;
    
    BOOL startLocation;
    
}

// マーカー未指定定義
enum GkGkRequireMarkerType
{
    GkGkReqMrkTpSelectSender,
    GkGkReqMrkTpSearchStation
} typedef GkGkRequireMarkerType;

@property  (nonatomic, assign) GkGkRequireMarkerType markerRequiredTp;


@property (strong, nonatomic) IBOutlet UIView *mSelectAddressView;



@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) IBOutlet UIToolbar *mToolBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *mCopyBtn;

- (IBAction)callConfigView:(id)sender;

- (IBAction)goMylocation:(id)sender;

- (IBAction)callSelectView:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *mTxtSrcAddress;

@property (strong, nonatomic) IBOutlet UIButton *mBtnNStSrc;


@end
