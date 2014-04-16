//
//  GkGkAdrSrcResultViewModel.m
//  RightHereMail
//
//  Created by pies on 2014/04/15.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkAdrSrcResultViewModel.h"

@implementation GkGkAdrSrcResultViewModel

- (void)setupModel
{
    NSLog(@"implements 4 Address Search ResultView!!!!");
}


// セル表示設定
- (UITableViewCell *)setupCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifer = @"CELL_ID";
    
    NSLog(@"render 4 Address Search ResultViews Cell!!!!");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifer];
        
    }
    if (cell && self.resultList)
    {
        NSDictionary *data = [self.resultList objectAtIndex:[indexPath item]];
        
        cell.textLabel.text = [data objectForKey:@"longName"];
        cell.detailTextLabel.text = [data objectForKey:@"name"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    
    return cell;
}

- (GkGkBaseSimpleResultViewData *)generateInstanceResultData
{
    return [[GkGkAdrSrcResultViewData alloc] init];
}

@end
