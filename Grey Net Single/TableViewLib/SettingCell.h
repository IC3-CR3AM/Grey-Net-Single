//
//  SettingCell.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingModel;
@interface SettingCell : UITableViewCell
/**封装Cell*/
+ (instancetype)settingCellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) SettingModel *items;
@end
