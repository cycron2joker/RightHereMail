//
//  GkGkNearestStationSearch.m
//  RightHereMail
//
//  Created by pies on 2014/03/13.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkNearestStationSearch.h"

@implementation GkGkNearestStationSearch


static NSString* const STATION_SRC_URL = @"http://express.heartrails.com/api/json?method=getStations";

- (id)init
{
    self = [super init];
//    self.responseData = nil;
    return self;
}

- (BOOL)searchStart:(float)lat lng:(float)lng
{

    // URL生成
    NSString *srcUrl = [NSString stringWithFormat:@"%@&x=%f&y=%f", STATION_SRC_URL ,lng ,lat];
    NSURL *url = [NSURL URLWithString:srcUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    // 接続開始
    [self startConnection:request];
//    
//    self.error = nil;
//    self.responseData = nil;
//    self.responseData = [NSMutableData data];
//    
//    // 接続開始
//    connection = [NSURLConnection connectionWithRequest:request delegate:self];
//    [self setConnStatConnecting];
    
    return TRUE;
}

/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [self setConnStatReceived];
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [self setConnStatReceived];
    [self.responseData appendData:data];
}

// エラーハンドリング
- (void)handleError:(NSError *)error
{
    self.error = nil;
    [self setConnStatErrored];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(service:didFailWithErrorOnGkGkWebSvc:)])
    {
        // エラーイベント通知
        [self.delegate service:self didFailWithErrorOnGkGkWebSvc:error];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self setConnStatErrored];
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self handleError:error];
}
*/
 
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSError *parseError;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                               options:NSJSONReadingAllowFragments error:&parseError];
    // parse失敗
    if (parseError)
    {
        NSLog(@"Received Json parse failed! Error - %@ %@",
              [parseError localizedDescription],
              [parseError userInfo]);
        [self handleError:parseError];
        return;
    }
    
    // JSONパース処理
    
    GkGkWebSrvResult *srcResult = [[GkGkWebSrvResult alloc] init];
    NSLog(@"nearest station search result:%@",jsonObject);

    NSArray *results = [[jsonObject objectForKey:@"response"] objectForKey:@"station"];
    if ([results count] > 0)
    {
        for (NSDictionary *stData in results) {
            
            NSString *distance = [stData objectForKey:@"distance"];
            NSString *line = [stData objectForKey:@"line"];
            NSString *stationName = [stData objectForKey:@"name"];
            NSString *lat = [stData objectForKey:@"y"];
            NSString *lng = [stData objectForKey:@"x"];
            NSDictionary *result = @{@"stationName" : stationName,
                                     @"line" : line,
                                     @"lng" : lng,
                                     @"lat" : lat,
                                     @"distance" : distance
                                     };
            [srcResult addSearchResult:result];
        }
        
    }
    
/*
 response =     {
 station =         (
 {
 distance = 150m;
 line = "\U795e\U6238\U5e02\U6d77\U5cb8\U7dda";
 name = "\U4e09\U5bae\U30fb\U82b1\U6642\U8a08\U524d";
 next = "<null>";
 postal = 6510087;
 prefecture = "\U5175\U5eab\U770c";
 prev = "\U65e7\U5c45\U7559\U5730\U30fb\U5927\U4e38\U524d";
 x = "135.195977";
 y = "34.691805";
 },
 {
 distance = 350m;
 line = "\U962a\U6025\U795e\U6238\U672c\U7dda";
 name = "\U4e09\U5bae";
 next = "<null>";
 postal = 6500012;
 prefecture = "\U5175\U5eab\U770c";
 prev = "\U6625\U65e5\U91ce\U9053";
 x = "135.192857";
 y = "34.693142";
 },
 {
 distance = 350m;
 line = "\U962a\U795e\U672c\U7dda";
 name = "\U4e09\U5bae";
 next = "\U6625\U65e5\U91ce\U9053";
 postal = 6510096;
 prefecture = "\U5175\U5eab\U770c";
 prev = "\U5143\U753a";
 x = "135.195231";
 y = "34.693819";
 },
 {
 distance = 420m;
 line = "\U30dd\U30fc\U30c8\U30a2\U30a4\U30e9\U30f3\U30c9\U7dda";
 name = "\U8cbf\U6613\U30bb\U30f3\U30bf\U30fc";
 next = "\U30dd\U30fc\U30c8\U30bf\U30fc\U30df\U30ca\U30eb";
 postal = 6510084;
 prefecture = "\U5175\U5eab\U770c";
 prev = "\U4e09\U5bae";
 x = "135.19946";
 y = "34.689366";
 }
 );
 };
 }

 
*/

    [self setConnStatFinished];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(service:didReceiveCompleteOnGkGkWebSvc:)])
    {
        // 受信完了通知
        [self.delegate service:self didReceiveCompleteOnGkGkWebSvc:srcResult];
    }
}


- (void)cancel
{
    
    
}




@end
