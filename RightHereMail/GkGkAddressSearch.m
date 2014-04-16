//
//  GkGkAddressSearch.m
//  RightHereMail
//
//  Created by pies on 2014/04/15.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkAddressSearch.h"

@implementation GkGkAddressSearch

static NSString* const GEO_SRC_URL = @"http://maps.googleapis.com/maps/api/geocode/json?address=";

- (BOOL)searchStart:(NSString *)targetAddr
{

    // 住所をエスケープしてURL生成
    NSString *escapedString =  [targetAddr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *srcUrl = [NSString stringWithFormat:@"%@%@&sensor=false", GEO_SRC_URL ,escapedString];
    NSURL *url = [NSURL URLWithString:srcUrl];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    
    
    // 接続開始
    [self startConnection:request];
    
    return TRUE;
}

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
    NSLog(@"%@",[jsonObject objectForKey:@"status"]);
    if ([[jsonObject objectForKey:@"status"] isEqualToString:@"OK"]) {
        
        NSArray *geoList = [jsonObject objectForKey:@"results"];
        
        for (NSDictionary *geoData in geoList) {
            
            NSArray *addrStrArr = [geoData objectForKey:@"address_components"];
            NSString *longName = [[addrStrArr firstObject] objectForKey:@"long_name"];
            NSString *addrName = [geoData objectForKey:@"formatted_address"];
            
            NSDictionary *points = [[geoData objectForKey:@"geometry"] objectForKey:@"location"];
            
            NSDictionary *result = @{@"name" : addrName,
                                     @"longName" : longName,
                                     @"lat" : [points objectForKey:@"lat"],
                                     @"lng" : [points objectForKey:@"lng"]
                                     };
            
            [srcResult addSearchResult:result];
        }
    }
    
    /*
     NSData *hoge;
     NSArray *hogeA;
     hoge = [jsonObject objectForKey:@"status"];
     NSLog(@"-------------------");
     NSLog(@"status:%@:%@" ,[jsonObject objectForKey:@"status"],hoge.class);
     
     hoge = [jsonObject objectForKey:@"results"];
     hogeA = [jsonObject objectForKey:@"results"];
     NSObject *fuga = [hogeA firstObject];
     NSLog(@"%@ %@",hoge.class ,fuga.class);
     
     NSLog(@"===========================");
     for (NSObject *data in fuga)
     {
     NSLog(@"-------------------");
     NSLog(@"%@ : %@" ,data.class ,data);
     NSLog(@"-------------------");
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
