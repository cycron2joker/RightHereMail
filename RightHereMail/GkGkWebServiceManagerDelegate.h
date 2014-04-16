//
//  GkGkPWebServiceManager.h
//  RightHereMail
//
//  Created by pies on 2014/03/17.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GkGkWebServiceManager.h"
//#import "GkGkGeoSrcResult.h"

// Webサービス接続マネジャーdelegate
@protocol GkGkWebServiceManagerDelegate <NSObject>
- (void)service:(GkGkWebServiceManager *)service didFailWithErrorOnGkGkWebSvc:(NSError *)error;
- (void)service:(GkGkWebServiceManager *)service didReceiveCompleteOnGkGkWebSvc:(NSObject *)resultData;
- (void)didCancelServiceOnGkGkWebSvc:(GkGkWebServiceManager *)service;

@end
