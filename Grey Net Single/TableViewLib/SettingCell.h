//
//  SettingCell.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "audioController.h"

@class SettingModel;
@interface SettingCell : UITableViewCell
@property (strong, nonatomic) audioController * ac;

/**封装Cell*/
+ (instancetype)settingCellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) SettingModel *items;
/**开关*/
@property (strong, nonatomic) UISwitch *mySwitch;
@end
