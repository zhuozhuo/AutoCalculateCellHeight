//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02
//
//  Created by yongzhuoJiang on 16/9/12.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZHCalculateHeightModel.h"

@interface ZHCellHeightCalculator : NSObject

//系统计算高度后缓存进cache
-(void)setHeight:(CGFloat)height withCalculateheightModel:(ZHCalculateHeightModel *)model;

//根据model hash 获取cache中的高度,如过无则返回－1
-(CGFloat)heightForCalculateheightModel:(ZHCalculateHeightModel *)model;

//清空cache
-(void)clearCaches;

@end
