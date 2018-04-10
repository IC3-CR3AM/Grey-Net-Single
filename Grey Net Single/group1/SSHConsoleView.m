//
//  SSHConsoleView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/20.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "SSHConsoleView.h"
#import "IQKeyboardManager.h"
#import "PingView.h"
#import "SSHView.h"
#import <FMDatabase.h>
#import "CommandList.h"


@interface SSHConsoleView (){
    CommandList * cmd;
}
@property (nonatomic,assign) CGRect kbRect;
@property (nonatomic) NSString * mUserID;
@property (nonatomic) NSInteger mUMissionIndex;
@property (nonatomic) NSInteger mUMissionProgress;
@property (nonatomic) NSString * admin;
@property (nonatomic) NSString * pw;
@property (nonatomic) BOOL isAdminCorrect;
@property (nonatomic) BOOL isPasswordCorrect;

@end

@implementation SSHConsoleView

- (void)viewDidLoad {
    [super viewDidLoad];
    cmd = [[CommandList alloc]init];
    // Do any additional setup after loading the view.
    titleLabel.text = @"SSH Console";
    owner.text = @"SSH$";
    commandTV.text = @"admin:";
    //init
    _isAdminCorrect = false;
    _isPasswordCorrect = false;
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
        NSLog(@"missionID:%@, missionIndex:%ld, missionProgress:%ld, admin:%@, password:%@",missionID,uMissionIndex,uMissionProgress,admin,pw);
        if(uMissionProgress == _mUMissionProgress && uMissionIndex == _mUMissionIndex){
            _admin = admin;
            _pw = pw;
        }
    }
}

//键盘出现
- (void)keyboardDidShow:(NSNotification *)notification{
    //获取键盘高度
    NSDictionary *dict = notification.userInfo;
    _kbRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self autoAdjustTo:commandTV];
}
//键盘消失
- (void)keyboardDidHidden:(NSNotification *)notification{
    commandTV.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
}

//是因为使用第三方库IQKeyboardManager，避免导航栏隐藏的BUG
- (void)loadView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scrollView;
}

//当然也可以通过KVO的方式监听textView的内容变化，不过代理方法已经用了，就....
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text
{
    //如果为回车则将键盘收起
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        NSLog(@"text get: %@", textView.text);
        //获取最后一行的开头
//        NSRange ran = [textView.text rangeOfString:currentUserName];
//        NSMutableArray * ran1 = [self getRangeStr:textView.text findText:currentUserName];
//        NSString * ran1Location = [ran1 lastObject];
//        NSString * temp = [textView.text substringFromIndex:([ran1Location intValue]+ran.length)];
        //--------------------------------console通过命令切换到各个页面------------------------------------
            if([textView.text hasPrefix:@"Admin:"] || [textView.text hasPrefix:@"admin:"]) {
                NSLog(@"包含admin字符");
                NSString * userName = [textView.text substringFromIndex:6];
                NSLog(@"user:%@",userName);
                if([userName isEqualToString:_admin]){
                    commandTV.text = @"password:";
                    _isAdminCorrect = true;
                }else{
                    commandTV.text = @"admin:";
                }
                //            commandTV.text = @"ssh error";
            } else if ([textView.text hasPrefix:@"Password"] || [textView.text hasPrefix:@"password"]){
                NSLog(@"包含Password字符");
                NSString * pw = [textView.text substringFromIndex:9];
                NSLog(@"pw:%@",pw);
                if([pw isEqualToString:_pw]){
                    _isPasswordCorrect = true;
                    commandTV.text = @"";
                }else{
                    commandTV.text = @"password:";
                }
            }else if(_isAdminCorrect && _isPasswordCorrect && ([textView.text hasPrefix:@"ls"] || [textView.text hasPrefix:@"Ls"] || [textView.text hasPrefix:@"Dir"] || [textView.text hasPrefix:@"dir"])){
                NSLog(@"包含commandLs字符");
                //add function
                NSMutableArray * catalog;
                //调用ls命令
                catalog = [cmd CommandLs:(int)_mUMissionProgress];

                NSLog(@"catalog:%@",catalog);
                NSString * fileString = [[NSString alloc]init];
                for(NSString * cata in catalog){
                    NSLog(@"cata:%@",cata);
                    fileString = [fileString stringByAppendingString:cata];
                    //加空格分开
                    fileString = [fileString stringByAppendingString:@" "];
                }
                NSLog(@"fileString:%@",fileString);
                commandTV.text = fileString;
            } else if(_isAdminCorrect && _isPasswordCorrect && ([textView.text hasPrefix:@"cd"] || [textView.text hasPrefix:@"Cd"])){
                NSLog(@"包含commandCd字符");
                NSString * tempStr;
                tempStr = textView.text;
                if([tempStr length]<=3){
                    NSLog(@"error,cd命令长度不足");
                    return YES;
                }
                tempStr = [tempStr substringFromIndex:3];
                //调用cd
                [cmd CommandCd:tempStr];
                commandTV.text = @"";
            } else {
                commandTV.text = @"can't understand this command";
            }
        if(_isAdminCorrect && _isPasswordCorrect){
            owner.text = [_admin stringByAppendingString:@"$"];
        }
        return NO;
    }
    [self autoAdjustTo:textView];
    return YES;
}

- (void)autoAdjustTo:(UITextView *)textView{
    //1.计算键盘的位置 Y 坐标
    
    CGFloat kbY = CGRectGetMinY(_kbRect);
    //2.计算textView的 MAXY 和 MINY
    CGRect textRect = [textView convertRect:textView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat MAXY = CGRectGetMaxY(textRect);
    CGFloat MINY = CGRectGetMinY(textRect);
    //3.计算textView 内容的高度
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(commandTV.frame), MAXFLOAT)];
    //4.获取光标的位置
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.end].origin;
    CGPoint point = [textView convertPoint:cursorPosition toView:[UIApplication sharedApplication].keyWindow];
    
    //    NSLog(@"+++++++++++++++++光标坐标：%f   键盘坐标:%f++++++++++++++",point.y+15,kbY);
    
    //5.判断
    //当textView 的frame比较大，上移后还会被键盘遮挡的话
    if (MAXY > kbY) {
        //当输入光标在键盘下方,15是字体的大小
        if (point.y+15>kbY) {
            //计算textView上内边距需要移动的高度
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat move = point.y + 15 - kbY - textView.textContainerInset.top;
                //                NSLog(@"=======================%f==============================",move);
                //                NSLog(@"---------------%f-----------------",textView.textContainerInset.top);
                //这里move-10是为了光标与键盘边界有点距离，更美观
                textView.textContainerInset = UIEdgeInsetsMake(-move-10-5, 5, 5, 5);
            }];
        }
    }
}

//注销通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
