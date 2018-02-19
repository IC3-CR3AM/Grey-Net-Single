//
//  SettingModel.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/7.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel
+ (instancetype)settingModelWithTitle:(NSString *)title andIcon:(NSString *)icon{
    /**创建数据模型,这里用self调用的好处是其他类使用时不用转换*/
    SettingModel *items = [[self alloc] init];
    items.icon = icon;
    items.title = title;
    return items;
}
+ (instancetype)settingModelWithTitle:(NSString *)title{
    return [self settingModelWithTitle:title andIcon:nil];
}
@end
