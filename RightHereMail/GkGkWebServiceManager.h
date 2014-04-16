//
//  GkGkBaseWebServiceManager.h
//  RightHereMail
//
//  Created by pies on 2014/03/17.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>


// Webサービス接続マネジャー基底
@interface GkGkWebServiceManager : NSObject
{
    NSURLConnection *connection;
}

// 接続ステータス定義
enum GkGkConnectionStatus
{
    GkGkConnStatDisconnected,
    GkGkConnStatConnecting,
    GkGkConnStatReceived,
    GkGkConnStatFinished,
    GkGkConnStatCanceled,
    GkGkConnStatErrored
};

@property enum GkGkConnectionStatus connectionState;

@property (nonatomic ,weak) id delegate;

@property (nonatomic ,strong) NSError *error;

@property (nonatomic ,strong) NSMutableData *responseData;

@property (nonatomic) double timeout;


- (void)setConnStatDisconnected;
- (void)setConnStatConnecting;
- (void)setConnStatReceived;
- (void)setConnStatErrored;
- (void)setConnStatFinished;
- (BOOL)isConnecting;
- (BOOL)hasError;

- (void)startConnection:(NSURLRequest *)request;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)handleError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;



@end

// Webサービス接続マネジャーdelegate
@protocol GkGkWebServiceManagerDelegate <NSObject>
- (void)service:(GkGkWebServiceManager *)service didFailWithErrorOnGkGkWebSvc:(NSError *)error;
- (void)service:(GkGkWebServiceManager *)service didReceiveCompleteOnGkGkWebSvc:(NSObject *)resultData;
- (void)didCancelServiceOnGkGkWebSvc:(GkGkWebServiceManager *)service;

@end
