//
//  GkGkBookMarkViewController.m
//  GMapTest
//
//  Created by pies on 2013/12/07.
//  Copyright (c) 2013年 pies. All rights reserved.
//

#import "GkGkBookMarkViewController.h"

@interface GkGkBookMarkViewController ()

@end

@implementation GkGkBookMarkViewController


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

    [self initTableView];
    
    [self initNavigationArea];
    
    
    GkGkAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.bmLat = -1.0;
    appDelegate.bmLng = -1.0;

}



- (void) initNavigationArea
{

    _nvItem.rightBarButtonItem = self.editButtonItem;

    
}

- (void)initTableView
{
    [self loadBookMarkList];

    _tblBookMarks.dataSource = self;
    _tblBookMarks.delegate = self;
    NSLog(@"initTableView end.");
}

- (void)loadBookMarkList
{
    GkGkAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    GkGkRHMManager *mng = [appDelegate dataManager];
    GkGkBookMarkDao *dao = mng.bookMarkDao;
    
    listBookMark = [[NSMutableArray alloc] initWithArray:[dao listAll]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listBookMark count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifer = @"CELL_ID";
    
    if (tableView == _tblBookMarks) {

        return [self titleTagCellForRowAtIndexPath:indexPath];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    return cell;
}

- (UITableViewCell *)titleTagCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TtlTagCellIdentifer = @"BM_CELL_ID";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"作成日時：yyyy/MM/dd HH:mm:ss"];
    
    UITableViewCell *cell = [_tblBookMarks dequeueReusableCellWithIdentifier:TtlTagCellIdentifer];
    NSInteger idx = [indexPath item];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TtlTagCellIdentifer];
    }

    BookMark *bm = [listBookMark objectAtIndex:idx];
    cell.textLabel.text = [bm title];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;

    cell.detailTextLabel.text = [df stringFromDate:[bm create]];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
//    if (firstSelectValue != nil && [firstSelectValue isEqualToString:cell.textLabel.text]) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        firstSelectValue = nil;
//    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSLog(@"titleTagCellForRowAtIndexPath:%d end." ,(int)idx);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = [indexPath item];

    if (tableView == _tblBookMarks)
    {

        BookMark *bm = [listBookMark objectAtIndex:idx];
        GkGkAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.bmLat = [bm.lat floatValue];
        appDelegate.bmLng = [bm.lng floatValue];
        
//        [self performSegueWithIdentifier:@"unwindFromBookMapViewWithBM" sender:self];
        [self performSegueWithIdentifier:@"unwindFromBookMapView" sender:self];
    }
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BookMark *bm = [listBookMark objectAtIndex:indexPath.row];
        [listBookMark removeObject:bm];
        
        GkGkAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        GkGkRHMManager *mng = [appDelegate dataManager];
        GkGkBookMarkDao *dao = mng.bookMarkDao;
        [dao removeBookMark:bm];

        [_tblBookMarks deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{

    [super setEditing:editing animated:animated];
    [_tblBookMarks setEditing:editing animated:animated];
    
}



- (IBAction)doBackView:(id)sender {

    [self performSegueWithIdentifier:@"unwindFromBookMapView" sender:self];
    
}


@end
