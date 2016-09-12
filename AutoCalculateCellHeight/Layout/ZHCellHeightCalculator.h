//
//  ZHCellHeightCalculator.h
//  AutoCalculateCellHeight
//
//  Created by yongzhuoJiang on 16/9/12.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZHCalculateHeightModel.h"

@interface ZHCellHeightCalculator : NSObject

-(void)setHeight:(CGFloat)height withCalculateheightModel:(ZHCalculateHeightModel *)model;

-(CGFloat)heightForCalculateheightModel:(ZHCalculateHeightModel *)model;

-(void)clearCaches;

@end
