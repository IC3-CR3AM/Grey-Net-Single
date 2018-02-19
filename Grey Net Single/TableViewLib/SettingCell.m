//
//  SettingCell.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "SettingCell.h"
#import "SettingModel.h"
#import "SettingArrowModel.h"
#import "SettingSwitchModel.h"
#import "SettingLabelModel.h"
@interface SettingCell()
/**箭头*/
@property (strong, nonatomic) UIImageView *arrowView;
/**开关*/
@property (strong, nonatomic) UISwitch *mySwitch;
/**标签文字*/
@property (strong, nonatomic) UILabel *myLabel;
@end
@implementation SettingCell

- (UIImageView *)arrowView{
    if (_arrowView == nil){
        UIImage *img = [UIImage imageNamed:@"00.jpg"];
//        UIImageOrientation a0 = img.imageOrientation;
        UIImage *image = [UIImage imageWithCGImage:img.CGImage scale:2.0 orientation:UIImageOrientationDown];
//        UIImageOrientation a2 = image.imageOrientation;
        UIImageView * imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = CGRectMake(0, 0, 50, 20);
        _arrowView = imgView;
    }
    return _arrowView;
}
- (UISwitch *)mySwitch{
    if (_mySwitch == nil) {
        _mySwitch = [[UISwitch alloc] init];
    }
    [_mySwitch setOn:YES];
    return _mySwitch;
}
- (UILabel *)myLabel{
    if (_myLabel == nil) {
        _myLabel = [[UILabel alloc] init];
        _myLabel.backgroundColor = [UIColor orangeColor];
        _myLabel.frame = CGRectMake(0, 0, 100, 20);
    }
    return _myLabel;
}

+ (instancetype)settingCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"SettingCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setItems:(SettingModel *)items{
    
    _items = items;
    /**1.设置数据*/
    [self setupData];
    /**2.设置右边内容*/
    [self setupRightContent];
}
#pragma mark--设置数据
- (void)setupData{
    self.imageView.image = [UIImage imageNamed:self.items.icon];
    self.textLabel.text = self.items.title;
}
#pragma mark--设置右边内容
- (void)setupRightContent{
    
    /**如果是箭头模型类,cell的accessoryView显示箭头*/
    if ([self.items isKindOfClass:[SettingArrowModel class]]) {
        self.accessoryView = self.arrowView;
    }else if ([self.items isKindOfClass:[SettingSwitchModel class]]){
        self.accessoryView = self.mySwitch;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([self.items isKindOfClass:[SettingLabelModel class]]){
        self.accessoryView = self.myLabel;
        self.myLabel.backgroundColor = [UIColor orangeColor];
    }else{
        self.accessoryView = nil;
    }
}
@end
