//
//  GkGkAppDelegate.h
//  RightHereMail
//
//  Created by pies on 2013/12/08.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GkGkApplicationDeligate.h"
#import "GkGkRHMManager.h"

@interface GkGkAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id dataManager;

@property (strong ,nonatomic) UIImage *myLocationMap;

@property float lat;
@property float lng;

@property float bmLat;
@property float bmLng;



@end
