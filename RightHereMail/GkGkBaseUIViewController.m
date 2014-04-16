//
//  GkgkBaseUIViewController.m
//  ChocoMail
//
//  Created by pies on 2013/10/17.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkBaseUIViewController.h"

@interface GkGkBaseUIViewController ()

@end

@implementation GkGkBaseUIViewController

-(id)dataManager
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate dataManager];
}

- (BOOL)judge4inchiDisplay
{
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect = sc.bounds;
    if (rect.size.height > 500) {
        return YES;
    } else {
        return NO;
    }
}


@end
