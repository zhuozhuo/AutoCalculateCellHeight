//
//  ZHCellHeightCalculator.m
//  AutoCalculateCellHeight
//
//  Created by yongzhuoJiang on 16/9/12.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCellHeightCalculator.h"

@interface ZHCellHeightCalculator ()
@property (strong, nonatomic, readonly) NSCache *cache;
@end

@implementation ZHCellHeightCalculator

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultConfigure];
    }
    return self;
}

-(void)defaultConfigure
{
    NSCache *cache = [NSCache new];
    cache.name = @"ZHCellHeightCalculator.cache";
    cache.countLimit = 200;
    _cache = cache;

}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: cache=%@",
            [self class], self.cache];
}

#pragma mark - Publci Methods
-(void)clearCaches
{
    [self.cache removeAllObjects];
}


-(void)setHeight:(CGFloat)height withCalculateheightModel:(ZHCalculateHeightModel *)model
{
    NSAssert(model != nil, @"Cell Model can't  nil");
    NSAssert(height > 0, @"cell height must great than 0");
    
    [self.cache setObject:[NSNumber numberWithFloat:height] forKey:@(model.hash)];
}


-(CGFloat)heightForCalculateheightModel:(ZHCalculateHeightModel *)model
{
    NSNumber *cellHeightNumber = [self.cache objectForKey:@(model.hash)];
    if (cellHeightNumber) {
        return [cellHeightNumber floatValue];
    }else
        return -1;
    
}
@end
