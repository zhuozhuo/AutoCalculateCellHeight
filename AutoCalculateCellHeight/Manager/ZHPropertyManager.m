//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02

//  Created by aimoke on 16/8/3.
//  Copyright © 2016年 zhuo. All rights reserved.
//


#import "ZHPropertyManager.h"


@implementation ZHPropertyManager
+ (instancetype)shareZHPropertyManager
{
    static ZHPropertyManager *propertyManager = nil;
    static dispatch_once_t *oncePredicate;
    dispatch_once(oncePredicate, ^{
        propertyManager = [[ZHPropertyManager alloc] init];
    });
    return propertyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (UIFont *)getTitleFont
{
    return [UIFont boldSystemFontOfSize:18.0];
}

- (UIFont *)getContentFont
{
    return [UIFont systemFontOfSize:14.0];
}

- (UIFont *)getTimeFont
{
    return [UIFont systemFontOfSize:13.0];
}

@end
