//
//  InputMissionInDatabase.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/3/6.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "InputMissionInDatabase.h"

@interface InputMissionInDatabase(){
    NSString * path;
    NSDictionary * root;
    NSDictionary * missionProgress;
    NSString * title;
    NSString * name;
    NSString * mail;
    NSString * ip;
    NSString * port;
    NSString * username;
    NSString * password;
    NSString * flag;
}
@end

@implementation InputMissionInDatabase
-(id) init{
    if (self=[super init]) {
        path = [[NSBundle mainBundle] pathForResource:@"MissionList" ofType:@"plist"];
        root = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSLog(@"keys and value in missionList:%lu",(unsigned long)root.count);
        //---------------------------------数据库部分--------------------------------------------------
        //create sqlite database
        NSString * strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/greyNetDB.db"];
        NSLog(@"%@", strPath);
        _db = [FMDatabase databaseWithPath:strPath];
        if(_db != nil){
            NSLog(@"InputMissionInDatabase:数据库存在");
        }
        BOOL isOpen = [_db open];
        if(isOpen){
            NSLog(@"InputMissionInDatabase:数据库打开成功");
        }
        //create a sql str
        NSString* strCreateTableMission = @"create table if not exists mission(id integer primary key, missionIndex integer, missionProgress integer,mail text,title text,name text,ip text,port text,admin text,password text,flag text)";
        
        BOOL isCreatedMission = [_db executeUpdate:strCreateTableMission];
        NSLog(@"InputMissionInDatabase:是否成功创建tableMission：%d",isCreatedMission);
        BOOL isFind = NO;
        //insert userInfo
        if(_db != nil){
            if([_db open]){
                //查询
                NSString * strQuerry = @"select * from mission";
                FMResultSet * result = [_db executeQuery:strQuerry];
                while([result next]){
                    _uTitle = [result stringForColumn:@"title"];
                    
                    NSInteger uMissionIndex = [result intForColumn:@"missionIndex"];
                    
                    NSInteger uMissionProgress = [result intForColumn:@"missionProgress"];
                    
                    NSLog(@"_uTitle:%@, missionIndex:%ld, %ld",_uTitle,uMissionIndex,uMissionProgress);
                    if(![_uTitle isEqualToString:@""]){
                        NSLog(@"找到数据mail");
                        isFind = YES;
                    }
                }
//                //假设没有找到数据
//                isFind = NO;
                //如果没有找到，则插入一条新数据
                if(!isFind){
                    NSLog(@"没有找到数据mail,插入信息");
                    //随机字符串存储空间
                    char data[4];
                    //add table
                    for(int i = 0;i<root.count;i++){
                        NSString * mission = [@"mission" stringByAppendingFormat:@"%d",i];
                        NSLog(@"mission:%@",mission);
                        missionProgress = [root objectForKey:mission];
//                        NSLog(@"missionProgress:%@",missionProgress);
                        title = [missionProgress objectForKey:@"title"];
                        NSLog(@"title:%@",title);
                        name = [missionProgress objectForKey:@"name"];
                        NSLog(@"name:%@",name);
                        mail = [missionProgress objectForKey:@"mail"];
                        NSLog(@"mail:%@",mail);
                        ip = [missionProgress objectForKey:@"ip"];
                        NSLog(@"ip:%@",ip);
                        port = [missionProgress objectForKey:@"port"];
                        NSLog(@"port:%@",port);
                        username = [missionProgress objectForKey:@"username"];
                        NSLog(@"username:%@",username);
                        password = [missionProgress objectForKey:@"password"];
                        NSLog(@"password:%@",password);
                        //随机数生成
                        for (int x=0;x<4;data[x++] = (char)('a' + (arc4random_uniform(26))));
                        NSString * ranStr = [[NSString alloc] initWithBytes:data length:4 encoding:NSUTF8StringEncoding];
                        NSLog(@"ranStr:%@",ranStr);
                        flag = ranStr;
                        NSLog(@"flag:%@",flag);
                        //需要修改，增加任务index
                        NSString *
                        strInsert = [@"insert into mission values(" stringByAppendingFormat:@"%d,%d,%d,'%@','%@','%@','%@','%@','%@','%@','%@')",i+1,0,i,mail,title,name,ip,port,username,password,flag];
                        NSLog(@"strInsert：%@",strInsert);
                        BOOL isInsert = [_db executeUpdate:strInsert];
                        NSLog(@"InputMissionInDatabase:插入成功与否：%d",isInsert);
                    }
                }
            }
        }
        //close db
        BOOL isClose = [_db close];
        NSLog(@"成功关闭数据库：%d",isClose);
    }
    return self;
}
@end
