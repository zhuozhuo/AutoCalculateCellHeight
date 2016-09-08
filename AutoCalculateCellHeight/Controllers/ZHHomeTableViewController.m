//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02

//  Created by aimoke on 16/8/3.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHHomeTableViewController.h"
#import "ZHCustomLayoutTableViewController.h"


@interface ZHHomeTableViewController ()

@end

@implementation ZHHomeTableViewController


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPathRow:%ld",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:{
            ZHCustomLayoutTableViewController *customeVC = [[ZHCustomLayoutTableViewController alloc]init];
            [self.navigationController pushViewController:customeVC animated:YES];
        }
        break;
        default:
        break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
