//
//  SSHView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/19.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "SSHView.h"
#import <FMDatabase.h>

@interface SSHView ()

@property FMDatabase * db;
@property NSString * ipdb;
@property NSString * portdb;
@property NSInteger mIndex;
@property NSInteger mProgress;

@end

@implementation SSHView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"SSH";
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
    from.text = @"Port:";
    from.frame = CGRectMake(20, 120, self.view.bounds.size.width/6+30, self.view.bounds.size.height/13);
    from.textColor = [UIColor whiteColor];
    from.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:from];
    
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
    
    _portTF = [[UITextField alloc]init];
    _portTF.font = [UIFont systemFontOfSize:20];
    _portTF.textColor = [UIColor blackColor];
    //    _idTF.textAlignment = NSLayoutFormatAlignAllCenterX;
    _portTF.backgroundColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:0.5];
    _portTF.borderStyle = UITextBorderStyleNone;
    _portTF.placeholder = @"Please enter port";
    _portTF.frame = CGRectMake(50+self.view.bounds.size.width/6, 135, self.view.bounds.size.width/6*4, 30);
    [self.view addSubview:_portTF];
    [_portTF setClearsOnBeginEditing:YES];
    [_portTF setMinimumFontSize:18];
    [_portTF setDelegate:self];
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
                 _portdb = [result stringForColumn:@"port"];
                 NSLog(@"SSHView ！！！ IP:%@, Port:%@",_ip,_port);
             }
        }
    }
    //close db
    BOOL isClose = [_db close];
    NSLog(@"成功关闭数据库：%d",isClose);
    //-------------------------------按钮和回显------------------------------------------
    UIButton * connect = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - self.view.bounds.size.width/6 /2, self.view.bounds.size.height - 40, self.view.bounds.size.width/6, 30)];
    [connect setTitle:@"Connect" forState:UIControlStateNormal];
    [connect setBackgroundColor:[UIColor grayColor]];
    [connect addTarget:self action:@selector(connectSSH) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connect];
}

-(void) connectSSH{
    UILabel * callbackView = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width - 40, self.view.bounds.size.height/2)];
    [callbackView setTextColor:[UIColor whiteColor]];
    [callbackView setFont:[UIFont systemFontOfSize:27]];
    //    [callbackView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:callbackView];
    if(![_ipdb isEqualToString:_ip]){
        callbackView.text = @"Uncorrect Input";
        NSLog(@"Uncorrect Input==================");
    }
    //跳转
    
}
//按回车将键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _portTF){
        [_portTF resignFirstResponder];
        _port = _portTF.text;
        NSLog(@"成功收回键盘");
    } else if(textField == _ipTF){
        [_ipTF resignFirstResponder];
        _ip = _ipTF.text;
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
    NSLog(@"offset%f",offset);
    NSLog(@"y:%f height:%f",_ipTF.frame.origin.y,_ipTF.frame.size.height);
    NSLog(@"frame.size.height:%f",self.view.frame.size.height);

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
    _port = _portTF.text;
    _ip = _ipTF.text;
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
