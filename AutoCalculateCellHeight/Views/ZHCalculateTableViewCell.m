//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02

//  Created by aimoke on 16/8/3.
//  Copyright © 2016年 zhuo. All rights reserved.
//


#import "ZHCalculateTableViewCell.h"


@implementation ZHCalculateTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setters
- (void)setModel:(ZHCalculateHeightModel *)model
{
    _model = model;
    self.TitleLabel.text = model.title;
    self.ContentLabel.text = model.content;
    self.showImgView.image = model.imageName.length > 0 ? [UIImage imageNamed:model.imageName] : nil;
    self.UseNameLabel.text = model.username;
    self.TimeLabel.text = model.time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
