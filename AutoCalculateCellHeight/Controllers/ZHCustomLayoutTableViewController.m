//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02

//  Created by aimoke on 16/8/3.
//  Copyright © 2016年 zhuo. All rights reserved.
//


#define CellIdentifier @"ZHCellIdentifier"

#import "ZHCustomLayoutTableViewController.h"
#import "ZHCalculateTableViewCell.h"
#import "ZHCellHeightCalculator.h"


@interface ZHCustomLayoutTableViewController ()
{
    NSArray *dataArray;
    ZHCellHeightCalculator *heightCalculator;
}

@property (nonatomic, strong) ZHCalculateTableViewCell *prototypeCell;
@end


@implementation ZHCustomLayoutTableViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    heightCalculator = [[ZHCellHeightCalculator alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZHCalculateTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
    self.tableView.estimatedRowHeight = 100;
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self initialData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods
- (void)initialData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *array = [dic objectForKey:@"feed"];
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        ZHCalculateHeightModel *model = [[ZHCalculateHeightModel alloc] initWithDictionary:dic];
        [muArray addObject:model];
    }
    dataArray = [NSArray arrayWithArray:muArray];
}


#pragma mark － TableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCalculateHeightModel *model = model = [dataArray objectAtIndex:indexPath.row];

    CGFloat height = [heightCalculator heightForCalculateheightModel:model];
    if (height > 0) {
        NSLog(@"cache height");
        return height;
    } else {
        NSLog(@"calculate height");
    }
    ZHCalculateTableViewCell *cell = self.prototypeCell;
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureCell:cell atIndexPath:indexPath]; //必须先对Cell中的数据进行配置使动态计算时能够知道根据Cell内容计算出合适的高度

    /*------------------------------重点这里必须加上contentView的宽度约束不然计算出来的高度不准确-------------------------------------*/
    CGFloat contentViewWidth = CGRectGetWidth(self.tableView.bounds);
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    [cell.contentView addConstraint:widthFenceConstraint];
    // Auto layout engine does its math
    CGFloat fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [cell.contentView removeConstraint:widthFenceConstraint];
    /*-------------------------------End------------------------------------*/

    CGFloat cellHeight = fittingHeight + 2 * 1 / [UIScreen mainScreen].scale; //必须加上上下分割线的高度
    [heightCalculator setHeight:cellHeight withCalculateheightModel:model];
    return cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCalculateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark Configure Cell Data
- (void)configureCell:(ZHCalculateTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.model = [dataArray objectAtIndex:indexPath.row];
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
