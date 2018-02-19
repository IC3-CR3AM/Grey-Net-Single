//
//  SettingTableViewController.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//
/**设置cell数据*/

#import "SettingTableViewController.h"
#import "SettingModel.h"
#import "SettingSwitchModel.h"
#import "SettingArrowModel.h"
#import "Group.h"
#import "SettingCell.h"
#import "FCoverViewController.h"
#import "PingView.h"
#import "SSHView.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**1.设置第一组数据*/
    [self setupGroup1];
    /**2.设置第二组数据*/
    [self setupGroup2];
    //第三组
    [self setupGroup3];
}
#pragma mark--下载数据源
/**第一组*/
- (void)setupGroup1{
    
    SettingModel *ping = [SettingArrowModel settingModelWithTitle:@"Ping" andIcon:@"functionButton.png" andDesClass:[PingView class]];
    SettingModel *ssh = [SettingArrowModel settingModelWithTitle:@"SSH" andIcon:@"functionButton.png" andDesClass:[SSHView
                                                                                                                   class]];
    SettingModel *downloadTool = [SettingArrowModel settingModelWithTitle:@"Download Tool" andIcon:@"functionButton.png" andDesClass:[FCoverViewController class]];
    SettingModel *sqlmap = [SettingArrowModel settingModelWithTitle:@"Sqlmap" andIcon:@"functionButton.png" andDesClass:[FCoverViewController class]];
//    SettingModel *soundEffect = [SettingArrowModel settingModelWithTitle:@"帮助" andIcon:@"sound_Effect@2x.png" andDesClass:[HelpViewController class]];
    Group *group = [[Group alloc] init];
    group.items = @[ping,ssh,downloadTool,sqlmap];

    [self.dataArray addObject:group];
}
/**第二组*/
- (void)setupGroup2{
//    SettingModel *MoreUpdate = [SettingArrowModel settingModelWithTitle:@"检查新版本" andIcon:@"functionButton.png"];
//    MoreUpdate.myBlocks = ^{
        /**1.加载图片*/
//        [MBProgressHUD showMessage:@"程序猿正在玩命加载中"];
//#warning 如果有网络发送请求
        
        /**2.暂停几秒显示信息*/
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /**2.1隐藏HUD*/
//            [MBProgressHUD hideHUD];
            /**2.2反馈更新信息*/
//            [MBProgressHUD showError:@"当前是最新版本"];
            
//        });
        
//    };
    SettingModel *music = [SettingSwitchModel settingModelWithTitle:@"Music" andIcon:@"functionButton.png" ];
    SettingModel *help = [SettingArrowModel settingModelWithTitle:@"HELP" andIcon:@"functionButton.png" andDesClass:[FCoverViewController class]];
    Group *group = [[Group alloc] init];
    group.items = @[music,help];
    [self.dataArray addObject:group];
}
//第三组
-(void)setupGroup3{
    SettingModel *logout = [SettingArrowModel settingModelWithTitle:@"Logout" andIcon:@"functionButton.png" andDesClass:[FCoverViewController class]];
    Group *group = [[Group alloc] init];
    group.items = @[logout];
    
    [self.dataArray addObject:group];
}
@end
