//
//  flagPageView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/4/3.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "FlagPageView.h"
#import <FMDatabase.h>

@interface FlagPageView (){
    UITextField * flagTF;
    CGFloat textY;
    CGFloat textHeight;
    NSString * flagStr;
    FMDatabase * db;
    
    NSUserDefaults * currentUser;
    
    UILabel * flagResult;
}
@property NSInteger mIndex;
@property NSInteger mProgress;
@property NSString * flagdb;

@end

@implementation FlagPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add listenr to keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Flag";
    self.navigationItem.titleView = titleLabel;
    
    //show result
    flagResult = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width - 40, self.view.bounds.size.height/2)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    flagResult.font = [UIFont boldSystemFontOfSize:20];
    flagResult.textColor = [UIColor whiteColor];
    flagResult.textAlignment = NSTextAlignmentCenter;
    flagResult.text = @"";
    
    //get device's bounds
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    //UITextfield
    flagTF = [[UITextField alloc]init];
    flagTF.font = [UIFont systemFontOfSize:20];
    flagTF.textColor = [UIColor blackColor];
    //    _idTF.textAlignment = NSLayoutFormatAlignAllCenterX;
    flagTF.backgroundColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:0.5];
    flagTF.borderStyle = UITextBorderStyleNone;
    flagTF.placeholder = @"Enter the mission's flag";
    flagTF.frame = CGRectMake((rx.size.width - rx.size.width/24*13)/2, rx.size.height/11*2, rx.size.width/24*13, 30);
    
    //addSubview
    [self.view addSubview:flagTF];
    [flagTF setClearsOnBeginEditing:YES];
    [flagTF setMinimumFontSize:18];
    [flagTF setDelegate:self];
    NSLog(@"flagTF.y:%f",flagTF.frame.origin.y);
    NSLog(@"flagTF.height:%f",flagTF.frame.size.height);
    textY = flagTF.frame.origin.y;
    textHeight = flagTF.frame.size.height;
    
    //check button
    UIButton* functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    functionButton.frame = CGRectMake(rx.size.width/2-50, rx.size.height - 125, 100, 100);
    [functionButton setImage:[UIImage imageNamed:@"confirmButton.png"] forState:UIControlStateNormal];
    
    //set gesture interactive
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [functionButton addGestureRecognizer:tap];
    
    //add view to screen
    [self.view addSubview:functionButton];
}

//按按钮确认是否通关
-(void) pressTap:(UITapGestureRecognizer*) tap{
    //---------------------------------数据库部分--------------------------------------------------
    //NSUserdefault 获取当前用户对象
    currentUser = [NSUserDefaults standardUserDefaults];
    
    //create sqlite database
    NSString * strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/greyNetDB.db"];
    NSLog(@"%@", strPath);
    db = [FMDatabase databaseWithPath:strPath];
    if(db != nil){
        NSLog(@"数据库存在");
    }
    BOOL isOpen = [db open];
    if(isOpen){
        NSLog(@"数据库打开成功");
    }
    //insert userInfo
    if(db != nil){
        if([db open]){
            //查询
            NSString * strQuerry = [@"select * from user where uid = " stringByAppendingFormat:@"'%@'",[currentUser stringForKey:@"currentUser"]];
            NSLog(@"strQuerry:%@",strQuerry);
            FMResultSet * result = [db executeQuery:strQuerry];
            while([result next]){
                NSString * uid = [result stringForColumn:@"uid"];
                NSInteger uMissionIndex = [result intForColumn:@"missionIndex"];
                NSInteger uMissionProgress = [result intForColumn:@"missionProgress"];
                NSLog(@"flagView ！！！ user id:%@, missionIndex:%ld, missionProgress：%ld",uid,uMissionIndex,uMissionProgress);
                _mIndex = uMissionIndex;
                _mProgress = uMissionProgress;
                NSLog(@"flagView ！！！ _mIndex:%ld, _mProgress:%ld",_mIndex,_mProgress);
            }
            //            strQuerry = [@"select * from mission where missionIndex = " stringByAppendingFormat:@"%ld and missionProgress = %ld",_mIndex,_mProgress ];
            strQuerry = @"select * from mission";
            result = [db executeQuery:strQuerry];
            while([result next]){
                if([result intForColumn:@"missionIndex"] == _mIndex && [result intForColumn:@"missionProgress"] == _mProgress){
                    _flagdb = [result stringForColumn:@"flag"];
                    NSLog(@"flagView ！！！ flagDB:%@",_flagdb);
                } else{
                    NSLog(@"flagView ！！！ can not find flag with these missionIndex:%d, _mIndex:%ld, missionProgress:%d, _mProgress:%ld",[result intForColumn:@"missionIndex"],_mIndex,[result intForColumn:@"missionProgress"],(long)_mProgress);
                }
            }
        }
    }
    //judge it's right or not
    if([flagStr isEqualToString:_flagdb]){
        NSLog(@"成功找到flag！！！");
        flagResult.text = @"Congratulation!";
        _mProgress++;
        NSString * updateStr = @"update user set missionProgress = ";
        updateStr = [updateStr stringByAppendingFormat:@"%ld where uid = '%@'",(long)_mProgress,[currentUser stringForKey:@"currentUser"]];
        NSLog(@"updateStr:%@",updateStr);
        BOOL result = [db executeUpdate:updateStr];
        NSLog(@"update result:%d",result);
        
        //查询
        NSString * strQuerry = [@"select * from user where uid = " stringByAppendingFormat:@"'%@'",[currentUser stringForKey:@"currentUser"]];
        NSLog(@"strQuerry:%@",strQuerry);
        FMResultSet * result2 = [db executeQuery:strQuerry];
        NSLog(@"result2:%@",result2);
        while([result2 next]){
            NSString * uid = [result2 stringForColumn:@"uid"];
            NSInteger uMissionIndex = [result2 intForColumn:@"missionIndex"];
            NSInteger uMissionProgress = [result2 intForColumn:@"missionProgress"];
            NSLog(@"flagView ！！！ user id:%@, missionIndex:%ld, missionProgress：%ld",uid,uMissionIndex,uMissionProgress);
            _mIndex = uMissionIndex;
            _mProgress = uMissionProgress;
            NSLog(@"flagView ！！！ _mIndex:%ld, _mProgress:%ld",_mIndex,_mProgress);
        }
        
    } else {
        NSLog(@"没找到flag！！！");
        flagResult.text = @"Sorry, try again!";
    }
    [self.view addSubview:flagResult];
    //close db
    BOOL isClose = [db close];
    NSLog(@"成功关闭数据库：%d",isClose);
}

//按回车将键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [flagTF resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    flagStr = flagTF.text;
    return YES;
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //    NSLog(@"kbHeight%f",kbHeight);
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (textY+textHeight+20) - (self.view.frame.size.height - kbHeight);
    //    NSLog(@"offset%f",offset);
    //    NSLog(@"y:%f height:%f",self.textY,self.textHeight);
    //    NSLog(@"frame.size.height:%f",self.view.frame.size.height);
    
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
    flagStr = flagTF.text;
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
