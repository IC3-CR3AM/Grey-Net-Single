//
//  DownloadView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/21.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "DownloadView.h"
#import "WKProgressBarLayer.h"
#import <FMDatabase.h>
//#import "SettingTableViewController.h"


@interface DownloadView (){
    NSUserDefaults * downloadFileDefault;
}

@property (nonatomic, strong) WKProgressBarLayer *progressLayer;
@property (nonatomic) NSString * mUserID;
@property (nonatomic) NSInteger mUMissionIndex;
@property (nonatomic) NSInteger mUMissionProgress;

@end

@implementation DownloadView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [SettingTableViewController alloc];
    //单利
    downloadFileDefault = [NSUserDefaults standardUserDefaults];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Download";
    self.navigationItem.titleView = titleLabel;
    
    //UILabel
    UILabel* fileName = [[UILabel alloc]init];
    fileName.numberOfLines = 0;
    fileName.text = @"File:";
    fileName.frame = CGRectMake(20, 75, self.view.bounds.size.width/4, self.view.bounds.size.height/13);
    fileName.textColor = [UIColor whiteColor];
    fileName.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:fileName];
    
    //UITextfield
    _ipTF = [[UITextField alloc]init];
    _ipTF.font = [UIFont systemFontOfSize:20];
    _ipTF.textColor = [UIColor blackColor];
    //    _ipTF = NSLayoutFormatAlignAllCenterX;
    _ipTF.backgroundColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:0.5];
    _ipTF.borderStyle = UITextBorderStyleNone;
    _ipTF.placeholder = @"Please enter file name";
    _ipTF.frame = CGRectMake(50+self.view.bounds.size.width/6, 90, self.view.bounds.size.width/6*4, 30);
    [self.view addSubview:_ipTF];
    [_ipTF setClearsOnBeginEditing:YES];
    [_ipTF setMinimumFontSize:18];
    [_ipTF setDelegate:self];
    
    //--------------------------数据查询部分---------------------------------------------------------------
    //create sqlite database
    NSString * strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/greyNetDB.db"];
    NSLog(@"%@", strPath);
    FMDatabase * _db = [FMDatabase databaseWithPath:strPath];
    if(_db != nil){
        NSLog(@"数据库存在");
    }
    BOOL isOpen = [_db open];
    if(isOpen){
        NSLog(@"数据库打开成功");
    }
    //NSUserdefault 存储当前用户对象
    NSUserDefaults *currentUser = [NSUserDefaults standardUserDefaults];
    NSString * resultID = [currentUser stringForKey:@"currentUser"];
    NSLog(@"current user:%@......................",resultID);
    //查询
    NSString * strQuerry = [@"select * from user where uid = '" stringByAppendingFormat:@"%@'",resultID ];
    FMResultSet * result = [_db executeQuery:strQuerry];
    while([result next]){
        NSString * uid = [result stringForColumn:@"uid"];
        NSInteger uMissionIndex = [result intForColumn:@"missionIndex"];
        NSInteger uMissionProgress = [result intForColumn:@"missionProgress"];
        
        NSLog(@"user id:%@, missionIndex:%ld, missionProgress:%ld",uid,uMissionIndex,uMissionProgress);
        _mUserID = uid;
        _mUMissionIndex = uMissionIndex;
        _mUMissionProgress = uMissionProgress;
        NSLog(@"_mUserID:%@, _mUMissionIndex:%ld, _mUMissionProgress:%ld",_mUserID,_mUMissionIndex,_mUMissionProgress);
    }
    //查询任务信息
    NSString * strQuerryMission = @"select * from mission";
    FMResultSet * resultMission = [_db executeQuery:strQuerryMission];
    NSLog(@"查询任务信息。。。。。。。。。。。");
    while([resultMission next]){
        NSString * missionID = [resultMission stringForColumn:@"id"];
        NSInteger uMissionIndex = [resultMission intForColumn:@"missionIndex"];
        NSInteger uMissionProgress = [resultMission intForColumn:@"missionProgress"];
        NSString * admin = [resultMission stringForColumn:@"admin"];
        NSString * pw = [resultMission stringForColumn:@"password"];
        NSString * tempFlag = [resultMission stringForColumn:@"flag"];
        NSLog(@"missionID:%@, missionIndex:%ld, missionProgress:%ld, admin:%@, password:%@ , flag:%@",missionID,uMissionIndex,uMissionProgress,admin,pw, tempFlag);
        if(uMissionProgress == _mUMissionProgress && uMissionIndex == _mUMissionIndex){
            if(uMissionIndex == 0){
                _downloadFile = @"portScanner";
            } else if(uMissionIndex == 1){
                _downloadFile = @"fileDestroy";
            }
        }
    }
    
    //progress 进度条以及位置
    WKProgressBarLayer *progressLayer = [[WKProgressBarLayer alloc] init];
    progressLayer.frame = CGRectMake(100, 200, 200, 10);
//    progressLayer.backgroundColor = [UIColor whiteColor].CGColor;
    progressLayer.fillColor = [UIColor whiteColor].CGColor;
    progressLayer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.view.layer addSublayer:progressLayer];
    
    self.progressLayer = progressLayer;

}
//按回车将键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _ipTF){
        [_ipTF resignFirstResponder];
    }
    //需要修改
    if([_ipTF.text isEqualToString:_downloadFile]){
        NSLog(@"file正确");
        //放入单利
        [downloadFileDefault setObject:_downloadFile forKey:@"downloadFileName"];
        //开始下载
        [self.progressLayer beginAnimationWithDuration:10];
    } else {
        NSLog(@"file错误");
        
    }
    NSLog(@"回收键盘");
    return YES;
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //    NSLog(@"kbHeight%f",kbHeight);
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (_ipTF.frame.origin.y+_ipTF.frame.size.height+20) - (self.view.frame.size.height - kbHeight);
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}
///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
//按空白地方回收键盘
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
