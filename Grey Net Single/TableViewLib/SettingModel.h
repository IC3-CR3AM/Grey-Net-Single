//
//  SettingModel.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/7.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

//define block
typedef void (^myBlock)(void);
@interface SettingModel : NSObject
//title
/**标题文字*/
@property (copy, nonatomic) NSString *title;

/**图标*/
@property (copy, nonatomic) NSString *icon;

/**block*/
@property (copy, nonatomic) myBlock myBlocks;

/**添加cell的标题和icon*/
+ (instancetype)settingModelWithTitle:(NSString *)title andIcon:(NSString *)icon;

/**只添加cell的标题*/
+ (instancetype)settingModelWithTitle:(NSString *)title;

@end
