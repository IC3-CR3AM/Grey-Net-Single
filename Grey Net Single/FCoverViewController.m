//
//  FCoverViewController.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/6.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "FCoverViewController.h"
#import "SettingTableViewController.h"
#import <FMDatabase.h>

@interface FCoverViewController ()

@end

@implementation FCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //add listenr to keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    //get device's bounds
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    //set bg with image
    NSString* strName = [NSString stringWithFormat:@"first_bg.jpg"];
    UIImage* image = [UIImage imageNamed:strName];
    UIImageView* iView = [[UIImageView alloc] initWithImage:image];
    iView.frame = rx;
    iView.userInteractionEnabled =YES;
    
    //UILabel
    UILabel* label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"GREY\nNET";
    label.frame = CGRectMake(0, 0, rx.size.width, rx.size.height/2);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:90];
    [iView addSubview:label];
    
    UILabel* missionLabel = [[UILabel alloc]init];
    missionLabel.text = @"Misson";
    missionLabel.textColor = [UIColor whiteColor];
    missionLabel.font = [UIFont systemFontOfSize:30];
    missionLabel.frame = CGRectMake(rx.size.width/8, rx.size.height/11*7, rx.size.width/3, 50);
    [iView addSubview:missionLabel];
    
    UILabel* idLabel =[[UILabel alloc]init];
    idLabel.text = @"ID";
    idLabel.textColor = [UIColor whiteColor];
    idLabel.font = [UIFont systemFontOfSize:30];
    idLabel.frame = CGRectMake(rx.size.width/8, rx.size.height/11*8, rx.size.width/3, 50);
    [iView addSubview:idLabel];
    
    //UIPickerView
    UIPickerView * pickerView = [[UIPickerView alloc]init];
    pickerView.frame = CGRectMake(rx.size.width/8*3+20, rx.size.height/11*7 - 20, rx.size.width/24*13, 90);
    pickerView.tintColor = [UIColor whiteColor];
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.showsSelectionIndicator=YES;

    pickerView.delegate = self;
    pickerView.dataSource = self;

    //UITextfield
    self.idTF = [[UITextField alloc]init];
    self.idTF.font = [UIFont systemFontOfSize:20];
    self.idTF.textColor = [UIColor blackColor];
//    _idTF.textAlignment = NSLayoutFormatAlignAllCenterX;
    self.idTF.backgroundColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:0.5];
    self.idTF.borderStyle = UITextBorderStyleNone;
    self.idTF.placeholder = @"please enter your ID";
    self.idTF.frame = CGRectMake(rx.size.width/8*3+20, rx.size.height/11*8+10, rx.size.width/24*13, 30);
    
    //addSubview
    [iView addSubview:self.idTF];
    [self.idTF setClearsOnBeginEditing:YES];
    [self.idTF setMinimumFontSize:18];
    [self.idTF setDelegate:self];
    NSLog(@"_idTF.y:%f",self.idTF.frame.origin.y);
    NSLog(@"_idTF.height:%f",self.idTF.frame.size.height);
    self.textY = self.idTF.frame.origin.y;
    self.textHeight = self.idTF.frame.size.height;
    
    //button goto rootView
    UIButton* functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    functionButton.frame = CGRectMake(rx.size.width/2-50, rx.size.height - 125, 100, 100);
    [functionButton setImage:[UIImage imageNamed:@"functionButton.png"] forState:UIControlStateNormal];
    
    //set gesture interactive
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [functionButton addGestureRecognizer:tap];
    
    //add view to screen
    [iView addSubview:functionButton];
    [self.view addSubview:iView];
    [self.view addSubview:pickerView];
}

//按按钮进入主场景 并保存用户数据
-(void) pressTap:(UITapGestureRecognizer*) tap{
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[SettingTableViewController alloc] init]];
    if(self.userID != nil){
        [self presentViewController:nav animated:YES completion:^{
            NSLog(@"从viewController:self 切换到SettingTableViewController");
        }];
    }
    //---------------------------------数据库部分--------------------------------------------------
    //NSUserdefault 存储当前用户对象
    NSUserDefaults *currentUser = [NSUserDefaults standardUserDefaults];
    [currentUser setObject:self.userID forKey:@"currentUser"];
    
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
    //create a sql str
    NSString* strCreateTable = @"create table if not exists user(uid varchar(20) primary key, missionIndex integer, missionProgress integer)";
    NSString* strCreateTableMission = @"create table if not exists mission(id integer primary key, missionIndex integer, missionProgress integer,mail text,title text,name text,ip text,port text)";
    
    BOOL isCreate = [_db executeUpdate:strCreateTable];
    BOOL isCreatedMission = [_db executeUpdate:strCreateTableMission];
    NSLog(@"是否成功创建table：%d",isCreate);
    NSLog(@"是否成功创建tableMission：%d",isCreatedMission);
    BOOL isFind = NO;
    //insert userInfo
    if(_db != nil){
        if([_db open]){
            //查询
            NSString * strQuerry = @"select * from user";
            FMResultSet * result = [_db executeQuery:strQuerry];
            while([result next]){
                NSString * uid = [result stringForColumn:@"uid"];
                
                NSInteger uMissionIndex = [result intForColumn:@"missionIndex"];
                
                NSInteger uMissionProgress = [result intForColumn:@"missionProgress"];
                
                NSLog(@"user id:%@, missionIndex:%ld, %ld",uid,uMissionIndex,uMissionProgress);
                if([self.userID isEqualToString:uid]){
                    isFind = YES;
                }
            }
            //如果没有找到，则插入一条新数据
            if(!isFind){
                NSString * strInsert = [@"insert into user values(" stringByAppendingFormat:@"'%@',%ld,0)",self.userID,self.missionIndex];
                NSLog(@"strInsert：%@",strInsert);
                NSLog(@"self.userID：%@",self.userID);
                BOOL isInsert = [_db executeUpdate:strInsert];
                NSLog(@"插入成功与否：%d",isInsert);
            }
        }
    }
    //close db
    BOOL isClose = [_db close];
    NSLog(@"成功关闭数据库：%d",isClose);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按回车将键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.idTF resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    self.userID = self.idTF.text;
    return YES;
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    NSLog(@"kbHeight%f",kbHeight);
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.textY+self.textHeight+20) - (self.view.frame.size.height - kbHeight);
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
    [self.view endEditing:YES];
}

//pickerview的协议函数
//1组
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//多少行
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

//设置pickerView cell高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}
//view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //  设置横线的颜色，实现显示或者隐藏
    ((UILabel *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    ((UILabel *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    NSString* str = [NSString stringWithFormat:@"%ld列%ld行",(long)component,(long)row];
    switch (row) {
        case 0:
            str = @"First Chapter";
            break;
        case 1:
            str = @"Second Chapter";
            break;
        default:
            break;
    }
    //white color
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:30];
    label.text = str;
    label.textColor = [UIColor whiteColor];
    return label;
}
//pickerview选中事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.missionIndex = row;
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
