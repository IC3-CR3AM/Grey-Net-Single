//
//  InboxView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "InboxView.h"
#import <FMDatabase.h>

@implementation InboxView

- (void)viewDidLoad {
    [super viewDidLoad];
    //--------------------------各种标签部分---------------------------------------------------------------
    //set nav title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Inbox";
    self.navigationItem.titleView = titleLabel;
    
    //UILabel
    UILabel* mailTitle = [[UILabel alloc]init];
    mailTitle.numberOfLines = 0;
    mailTitle.text = @"Title:";
    mailTitle.frame = CGRectMake(20, 75, self.view.bounds.size.width/6, self.view.bounds.size.height/13);
    mailTitle.textColor = [UIColor whiteColor];
    mailTitle.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:mailTitle];
    UILabel* from = [[UILabel alloc]init];
    from.numberOfLines = 0;
    from.text = @"From:";
    from.frame = CGRectMake(20, 120, self.view.bounds.size.width/6+30, self.view.bounds.size.height/13);
    from.textColor = [UIColor whiteColor];
    from.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:from];
    
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
        NSString * mail = [resultMission stringForColumn:@"mail"];
        NSString * title = [resultMission stringForColumn:@"title"];
        NSString * name = [resultMission stringForColumn:@"name"];
        NSLog(@"missionID:%@, missionIndex:%ld, missionProgress:%ld, mail:%@, title:%@, From:%@",missionID,uMissionIndex,uMissionProgress,mail,title,name);
        if(uMissionProgress == _mUMissionProgress && uMissionIndex == _mUMissionIndex){
            _mail = mail;
            _tit = title;
            _name = name;
        }
    }
    //--------------------------显示部分---------------------------------------------------------------
    //textView
    UITextView * textTitle = [[UITextView alloc]init];
    textTitle.frame = CGRectMake(50+self.view.bounds.size.width/6, 80, self.view.bounds.size.width/6*4, self.view.bounds.size.height/15);
    textTitle.text = _tit;
    textTitle.textColor = [UIColor whiteColor];
    textTitle.backgroundColor = [UIColor clearColor];
    textTitle.font = [UIFont systemFontOfSize:30];
    [textTitle setEditable:NO];
    [self.view addSubview:textTitle];
    
    UITextView * textName = [[UITextView alloc]init];
    textName.frame = CGRectMake(50+self.view.bounds.size.width/6, 125, self.view.bounds.size.width/6*4, self.view.bounds.size.height/15);
    textName.text = _name;
    textName.textColor = [UIColor whiteColor];
    textName.backgroundColor = [UIColor clearColor];
    textName.font = [UIFont systemFontOfSize:30];
    [textName setEditable:NO];
    [self.view addSubview:textName];
    //
    UITextView * textMail = [[UITextView alloc]init];
    textMail.frame = CGRectMake(20, 180, self.view.bounds.size.width -50, self.view.bounds.size.height/15*11);
    textMail.text = _mail;
    textMail.textColor = [UIColor whiteColor];
    textMail.backgroundColor = [UIColor clearColor];
    textMail.font = [UIFont systemFontOfSize:27];
    [textMail setEditable:NO];
    [self.view addSubview:textMail];
}

@end
