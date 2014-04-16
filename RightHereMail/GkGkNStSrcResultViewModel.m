//
//  GkGkNStSrcResultViewModel.m
//  RightHereMail
//
//  Created by pies on 2014/03/27.
//  Copyright (c) 2014年 pies. All rights reserved.
//

#import "GkGkNStSrcResultViewModel.h"

@implementation GkGkNStSrcResultViewModel


- (void)setupModel
{
    NSLog(@"implements 4 Nearest Station Search ResultView!!!!");
}


// セル表示設定
- (UITableViewCell *)setupCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifer = @"CELL_ID";
    
    NSLog(@"render 4 Nearest Station Search ResultViews Cell!!!!");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifer];
        
    }
    if (cell && self.resultList)
    {
        NSDictionary *data = [self.resultList objectAtIndex:[indexPath item]];
        
        cell.textLabel.text =  [NSString stringWithFormat:@"%@駅" ,
                                [data objectForKey:@"stationName"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)" ,
                                     [data objectForKey:@"line"],
                                     [data objectForKey:@"distance"]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
/*
        distance = 690m;
        line = "\U5927\U962a\U583a\U7b4b\U7dda";
        name = "\U5317\U6d5c";
        next = "\U583a\U7b4b\U672c\U753a";
        postal = 5410041;
        prefecture = "\U5927\U962a\U5e9c";
        prev = "\U5357\U68ee\U753a";
        x = "135.506605";
        y = "34.690926";
*/
        
    }

    return cell;
}

- (GkGkBaseSimpleResultViewData *)generateInstanceResultData
{
    return [[GkGkNstSrcResultViewData alloc] init];
}



@end
