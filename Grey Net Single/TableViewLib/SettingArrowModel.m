//
//  SettingArrowModel.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "SettingArrowModel.h"

@implementation SettingArrowModel

/**.m中实现的代码*/
+ (instancetype)settingModelWithTitle:(NSString *)title andIcon:(NSString *)icon andDesClass:(Class)desClass{
    
    SettingArrowModel *items = [[self settingModelWithTitle:title andIcon:icon] init];
    items.desClass = desClass;
    return items;
}

@end
