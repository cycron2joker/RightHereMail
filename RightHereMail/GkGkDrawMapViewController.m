//
//  GkGkDrawMapViewController.m
//  GMapTest
//
//  Created by pies on 2013/11/23.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkDrawMapViewController.h"

@interface GkGkDrawMapViewController ()

@end

@implementation GkGkDrawMapViewController

    const static double DEF_PEN_SZ = 5.0;


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

    // 地図イメージのロード
    [_myLocImage setImage:[self appDelegate].myLocationMap];

    // 描画ビューの設定
    _mDrawView = [[GkGkDrawView alloc] initWithFrame:CGRectZero];
    [_mDrawContainerView addSubview:_mDrawView];
    _mDrawView.layer.frame = _mDrawContainerView.layer.frame;
    [_myLocImage bringSubviewToFront:_mDrawView];
//    _mDrawView.layer.zPosition= 2;

    _mDrawView.mLines = _drawDataList;
    
    
    _curPenColor = [UIColor blackColor];
    _curPenSize = DEF_PEN_SZ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GkGkAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mDrawView beginLine:_curPenColor penSize:_curPenSize];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    
    [_mDrawView setTouchPoint:point];
}

/**
 * 呼び出し画面戻り処理
 */
- (IBAction)doBackView:(id)sender
{
    NSLog(@"manual unwind from draw view!");
    
    
    UIGraphicsBeginImageContext(_mDrawContainerView.layer.frame.size);
    [_mDrawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *drawImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    NSLog(@"%f,%f", drawImage.size.width, drawImage.size.height);
    
    _drawMapImage = [self getWImage:_myLocImage.image frontImage:drawImage];

    
    
    
    [self performSegueWithIdentifier:@"uwindSegueSenderView" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueCallDrawConf"]) {
        
        GkGkDrawConfigViewController *v = segue.destinationViewController;
//        v.mSldPenWidth.value = _curPenSize;
        v.curPenSize = _curPenSize;
        v.curPenColor = _curPenColor;
        
//        //遷移先のViewControllerインスタンスを取得
//        GkGkDrawMapViewController *vc = segue.destinationViewController;
//        vc.drawDataList = _drawLines;
    }
}

/**
 * seque戻り
 */
- (IBAction)returnActionForSegue:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"uwindSegueDrawView"]) {
//        //遷移元のViewControllerインスタンスを取得
        GkGkDrawConfigViewController *v = segue.sourceViewController;
        _curPenSize = v.mSldPenWidth.value;
        _curPenColor = v.curPenColor;
        
//        GkGkDrawMapViewController *vc = segue.sourceViewController;
//        _drawMapImage = vc.drawMapImage;
//        [_mImgMyLoc setImage:_drawMapImage];
    }
    
    NSLog(@"unwind!!");
    
}




/**
 * 描画undo
 */
- (IBAction)doUndoAction:(id)sender {
    
    
    if ([_drawDataList count] > 0)
    {
        [_drawDataList removeLastObject];
        [_mDrawView setNeedsDisplay];
        
        
    }
}

/**
 * ペン設定呼び出し
 */
- (IBAction)doCallConfigView:(id)sender {

    [self performSegueWithIdentifier:@"segueCallDrawConf" sender:self];

}

-(UIImage*)getWImage:(UIImage*)bottomImage frontImage:(UIImage*)frontImage{
    int width = bottomImage.size.width;
    int height = bottomImage.size.height;
    
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [frontImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//}



@end
