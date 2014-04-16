//
//  GkGkBaseWebServiceManager.m
//  RightHereMail
//
//  Created by pies on 2014/03/17.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkWebServiceManager.h"

@implementation GkGkWebServiceManager


-(id)init
{
    self = [super init];
    [self setConnStatDisconnected];
    self.delegate = nil;
    self.responseData = nil;
    self.timeout = 60.0;
    connection = nil;
    
    return self;
}

- (BOOL)isConnecting
{
    if (self.connectionState == GkGkConnStatConnecting
        || self.connectionState == GkGkConnStatReceived)
    {
        return YES;
    }
    return NO;
}
- (BOOL)hasError
{
    return self.connectionState == GkGkConnStatErrored;
}

- (void)setConnStatDisconnected
{
    self.connectionState = GkGkConnStatDisconnected;
}


- (void)setConnStatConnecting
{

    self.connectionState = GkGkConnStatConnecting;

}

- (void)setConnStatReceived
{
    
    self.connectionState = GkGkConnStatReceived;
    
}

- (void)setConnStatErrored
{
    
    self.connectionState = GkGkConnStatErrored;
    
}

- (void)setConnStatFinished
{
    
    self.connectionState = GkGkConnStatFinished;
    
}

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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"todo implement sub-class.");
    abort();
}

- (void)startConnection:(NSURLRequest *)request
{
    self.error = nil;
    self.responseData = nil;
    self.responseData = [NSMutableData data];
    
    // 接続開始
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self setConnStatConnecting];
}


@end
