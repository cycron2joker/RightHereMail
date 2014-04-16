//
//  GkGkDrawConfigViewController.m
//  GMapTest
//
//  Created by pies on 2013/11/28.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkDrawConfigViewController.h"

@interface GkGkDrawConfigViewController ()

enum PEN_COLOR {
    penColorBlack,
    penColorRed,
    penColorBlue
};

typedef enum PEN_COLOR PEN_COLOR;



@end

@implementation GkGkDrawConfigViewController

// 色設定セクション
int static const COLOR_SECTION = 1;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _mSldPenWidth.minimumValue = 1;// setMinimumValue:1];
    _mSldPenWidth.maximumValue = 10;// setMaximumValue:5];
    _mSldPenWidth.continuous = YES;
    [_mSldPenWidth addTarget:self
               action:@selector(changePenWidth:)
     forControlEvents:UIControlEventValueChanged];

    _mPenSizeView.curPenSize = _curPenSize;
    _mPenSizeView.curPenColor = _curPenColor;
    _mPenSizeView.layer.borderWidth = 1;
    _mPenSizeView.layer.borderColor = [[UIColor blackColor] CGColor];
    _mPenSizeView.layer.cornerRadius = 5;
    
    

    //[self.tableView.
    

    
/*
    else if ([_mPenSizeView.curPenColor isEqual:[UIColor redColor]])
    
        row = penColorRed;


    }
 */
//    else {
//        row = penColoBlue;
//    }



    
    
    
    
    
    [_mSldPenWidth setValue:_curPenSize animated:NO];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doBackView:(id)sender
{
    NSLog(@"manual unwind from draw view!");
    
    
    
    [self performSegueWithIdentifier:@"uwindSegueDrawView" sender:self];
    
    
    
    
//    [self performSegueWithIdentifier:@"uwindSegueSenderView" sender:self];
}
/*
-(int)roundSliderValue:(float)x {
    
    return lround(x);
    
    
    
    if (x < -1.5) {
        return -3;
    } else if (x < 1.0) {
        return 0;
    } else if (x < 3.0) {
        return 2;
    } else if (x < 5.5) {
        return 4;
    } else if (x < 8.5) {
        return 7;
    } else if (x < 11.0) {
        return 10;
    } else {
        return 12;
    }
}
 */
-(void)changePenWidth:(id)slider {
    
    
    [_mSldPenWidth setValue:lround(_mSldPenWidth.value) animated:NO];
    
    _mPenSizeView.curPenSize = _mSldPenWidth.value;
    [_mPenSizeView setNeedsDisplay];

    
    NSLog(@"penwidth:%f",_mSldPenWidth.value);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = [indexPath section];
    
    if (section == COLOR_SECTION)
    {
        
        NSLog(@"color setting");
        
        NSInteger selectedIdx = indexPath.row;
        
        // 選択したセルにチェック、その他のセルは解除
        for (NSInteger index=0; index < [self.tableView numberOfRowsInSection:COLOR_SECTION]; index++) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:COLOR_SECTION]];
            if (selectedIdx == index) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        _curPenColor = [self selectedColor:(int)selectedIdx];

        _mPenSizeView.curPenColor = _curPenColor;
        [_mPenSizeView setNeedsDisplay];
        
    }
    else
    {
        NSLog(@"not color setting");
        
    }
}

- (UIColor *)selectedColor:(int)idx
{
    UIColor *color;
    
    switch (idx)
    {
        case penColorBlack:
            color = [UIColor blackColor];
            break;
        case penColorRed:
            color = [UIColor redColor];
            break;
        default:
            color = [UIColor blueColor];
            break;
    }
    return color;
}
- (int)currentColorIdx
{
    if ([_curPenColor isEqual:[UIColor blackColor]])
    {
        return penColorBlack;
    }
    else if ([_curPenColor isEqual:[UIColor redColor]])
    {
        return penColorRed;
    }
    return penColorBlue;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSLog(@"cellForRowAtIndexPath start");
    
    // static cellの場合は、存在しているので、superで取得
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([indexPath section] == COLOR_SECTION)
    {
        
        int rowIdx = [indexPath row];
        BOOL chkMarkFlag = NO;
        int curColorIdx = [self currentColorIdx];
        
        if (curColorIdx == rowIdx)
        {
            chkMarkFlag = YES;
        }

        if (chkMarkFlag)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    }
    
    return cell;
}




#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 1;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
