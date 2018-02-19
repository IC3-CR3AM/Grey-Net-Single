//
//  PingView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "PingView.h"
#import <FMDatabase.h>

@interface PingView ()
@property FMDatabase * db;
@property NSInteger mIndex;
@property NSInteger mProgress;
@property NSString * ipdb;
@property UITextView * textReply;

@end

@implementation PingView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Ping";
    self.navigationItem.titleView = titleLabel;
    //UILabel
    UILabel* mailTitle = [[UILabel alloc]init];
    mailTitle.numberOfLines = 0;
    mailTitle.text = @"IP:";
    mailTitle.frame = CGRectMake(20, 75, self.view.bounds.size.width/6, self.view.bounds.size.height/13);
    mailTitle.textColor = [UIColor whiteColor];
    mailTitle.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:mailTitle];
    UILabel* from = [[UILabel alloc]init];
    from.numberOfLines = 0;
    from.text = @"Reply:";
    from.frame = CGRectMake(20, 120, self.view.bounds.size.width/6+30, self.view.bounds.size.height/13);
    from.textColor = [UIColor whiteColor];
    from.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:from];
    
    //textFielf===========================================
    //UITextfield
    _ipTF = [[UITextField alloc]init];
    _ipTF.font = [UIFont systemFontOfSize:20];
    _ipTF.textColor = [UIColor blackColor];
    //    _ipTF = NSLayoutFormatAlignAllCenterX;
    _ipTF.backgroundColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:0.5];
    _ipTF.borderStyle = UITextBorderStyleNone;
    _ipTF.placeholder = @"Please enter IP address";
    _ipTF.frame = CGRectMake(50+self.view.bounds.size.width/6, 90, self.view.bounds.size.width/6*4, 30);
    [self.view addSubview:_ipTF];
    [_ipTF setClearsOnBeginEditing:YES];
    [_ipTF setMinimumFontSize:18];
    [_ipTF setDelegate:self];
    
    //textView
    _textReply = [[UITextView alloc]init];
    _textReply.frame = CGRectMake(40, 180, self.view.bounds.size.width -80, self.view.bounds.size.height/15*11);
    _textReply.text = @"It's a View test blablabalbalbalablabalbalbalbalbalababalbalbalabalbalb";
    _textReply.textColor = [UIColor whiteColor];
    _textReply.backgroundColor = [UIColor clearColor];
    _textReply.font = [UIFont systemFontOfSize:27];
    [self.view addSubview:_textReply];
    //-------------------------------数据库部分---------------------------------------------------------
    //NSUserdefault 当前用户对象
    NSUserDefaults *currentUser = [NSUserDefaults standardUserDefaults];
    //create sqlite database
    NSString * strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/greyNetDB.db"];
    NSLog(@"%@", strPath);
    _db = [FMDatabase databaseWithPath:strPath];
    if(_db != nil){
        NSLog(@"数据库存在");
    }
    BOOL isOpen = [_db open];
    if(isOpen){
        NSLog(@"数据库打开成功");
    }
    //insert userInfo
    if(_db != nil){
        if([_db open]){
            //查询
            NSString * strQuerry = [@"select * from user where uid = '" stringByAppendingFormat:@"%@'",[currentUser stringForKey:@"currentUser"]];
            FMResultSet * result = [_db executeQuery:strQuerry];
            while([result next]){
                NSString * uid = [result stringForColumn:@"uid"];
                NSInteger uMissionIndex = [result intForColumn:@"missionIndex"];
                NSInteger uMissionProgress = [result intForColumn:@"missonProgress"];
                NSLog(@"SSHView ！！！ user id:%@, missionIndex:%ld, missionProgress：%ld",uid,uMissionIndex,uMissionProgress);
                _mIndex = uMissionIndex;
                _mProgress = uMissionProgress;
            }
            strQuerry = [@"select * from mission where missionIndex = " stringByAppendingFormat:@"%ld and missionProgress = %ld",_mIndex,_mProgress ];
            result = [_db executeQuery:strQuerry];
            while([result next]){
                _ipdb = [result stringForColumn:@"ip"];
                NSLog(@"SSHView ！！！ IP:%@",_ipdb);
            }
        }
    }
    //close db
    BOOL isClose = [_db close];
    NSLog(@"成功关闭数据库：%d",isClose);
}
//按回车将键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _ipTF){
        [_ipTF resignFirstResponder];
    }
    if([_ipTF.text isEqualToString:_ipdb]){
        _textReply.text = @"64 bytes from 111.13.100.92: icmp_seq=0 ttl=54 time=28.323 ms\n64 bytes from 111.13.100.92: icmp_seq=1 ttl=54 time=29.028 ms\n64 bytes from 111.13.100.92: icmp_seq=2 ttl=54 time=27.733 ms\n64 bytes from 111.13.100.92: icmp_seq=3 ttl=54 time=28.094 ms\n--- www.a.shifen.com ping statistics ---\n4 packets transmitted, 4 packets received, 0.0% packet loss\nround-trip min/avg/max/stddev = 27.531/29.116/33.621/1.668 ms";
    }
    return YES;
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"kbHeight%f",kbHeight);
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
