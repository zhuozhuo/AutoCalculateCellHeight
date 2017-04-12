//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02

//  Created by aimoke on 16/8/3.
//  Copyright © 2016年 zhuo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ZHCalculateHeightModel.h"


@interface ZHCalculateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImgView;
@property (weak, nonatomic) IBOutlet UILabel *UseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) ZHCalculateHeightModel *model;
@end
