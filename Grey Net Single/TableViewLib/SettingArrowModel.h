//
//  SettingArrowModel.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "SettingModel.h"
/**2.1继承SettingModel*/
@interface SettingArrowModel : SettingModel

/**2.2增加自己的私有类,设置要跳转的控制器*/
@property (assign, nonatomic) Class desClass;

/**2.3设置跳转控制器方法,私有方法,只有箭头才可以跳转控制器*/
+ (instancetype)settingModelWithTitle:(NSString *)title andIcon:(NSString *)icon andDesClass:(Class)desClass;

@end
