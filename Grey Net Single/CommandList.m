//
//  CommandList.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/25.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "CommandList.h"
@interface CommandList(){
    NSString * path;
    NSDictionary * root;
    NSDictionary * missionPath;
//    NSArray * missionList;
    
    NSUserDefaults * getCurrentFolder;
    NSString * currentFolder;
    NSMutableArray<NSString *> * array;
}
@end

@implementation CommandList
//初始化
-(id) init{
    if (self=[super init]) {
        path = [[NSBundle mainBundle] pathForResource:@"MissionFileList" ofType:@"plist"];
        root = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}

// 传入第几个任务
-(NSMutableArray *) CommandLs:(int) num{
    
    NSLog(@"show list-------ls");
    
    // 获取当前目录
    getCurrentFolder = [NSUserDefaults standardUserDefaults];
    currentFolder = [getCurrentFolder stringForKey:@"currentFolder"];
    NSLog(@"currentFolder:%@",currentFolder);
    
    //切分当前目录，存入数组,不保存切分字符
    array = [currentFolder componentsSeparatedByString:@"/"];//字符串按照分隔成数组
    NSLog(@"array:%@",array); //结果是
    
    //删除空字符串
    for (NSString * str in array)
    {
        if ([str isEqualToString: @""]){
            [array removeObject:str];
            break;//一定要有break，否则会出错的。
        }
    }
    NSLog(@"array:%@",array); //结果是
    
    //增加最后一个空字符
    [array addObject:@""];
    NSLog(@"array:%@",array); //结果是
    
    //找到对应任务章节的文件系统
    NSString * mission = [@"mission" stringByAppendingFormat:@"%d",num ];
    missionPath = [root objectForKey:mission];
    
    //临时数组变量,用于返回
    NSMutableArray * reArray = [[NSMutableArray alloc]init];

    for (NSString * arrayItem in array) {
        //如果数组非空，说明需要找到在当前目录下的对应文件，否则报错
        if(![arrayItem isEqualToString:@""]){
            missionPath = [self catalogQuery:arrayItem catalog:missionPath];
        }else{
            //数组为空，代表就在当前目录，显示当前目录
            for (NSString *key in missionPath) {
                NSLog(@"数组为空--key：%@",key);
                [reArray addObject:key];
            }
        }
    }
    return reArray;
}

//cd command
//传入路径
-(void) CommandCd:(NSString *) path{
    NSString * tempStr = [[NSString alloc]init];
    
    //切分当前目录，存入数组,不保存切分字符
    NSMutableArray<NSString *> * pathArray = [path componentsSeparatedByString:@"/"];//字符串按照分隔成数组;
    NSLog(@"pathArray:%@",pathArray); //结果是

    //删除空字符串
    for (NSString * str in pathArray)
    {
        if ([str isEqualToString: @""]){
            [pathArray removeObject:str];
            break;//一定要有break，否则会出错的。
        }
    }
    NSLog(@"pathArray:%@",pathArray); //结果是
    
    if([pathArray[0] isEqualToString:@".."]){
        if([pathArray count]==1){
            NSLog(@"array:%@",array);
            if([array count]==1){
                [array removeLastObject];
                [array addObject:@""];
            }else{
                [array removeLastObject];
                [array removeLastObject];
                [array addObject:@""];
            }
            for (NSString *key in array) {
                tempStr = [tempStr stringByAppendingString:@"/"];
                tempStr = [tempStr stringByAppendingString:key];
            }
            NSLog(@"path:%@",path);
            NSLog(@"tempStr:%@",tempStr);
            NSLog(@"array:%@",array);

            [getCurrentFolder setObject:tempStr forKey:@"currentFolder"];
        }
    } else if([pathArray[0] isEqualToString:@"."]){
        int flagError = 0;
        NSDictionary * tempDic;
        if([pathArray count]==1){
            //do noting
        } else if([pathArray count]>1){
            for(int i=1;i<[pathArray count];i++){
                tempDic = [self catalogQuery:pathArray[i] catalog:missionPath];
                if([tempDic isEqual:missionPath]){
                    NSLog(@"error, wrong catolog name");
                    NSLog(@"array:%@",array);
                    flagError = 1;
                    break;
                } else {
                    missionPath = tempDic;
                }
            }
        }
        if(flagError == 0){
            tempStr = path;
            tempStr = [tempStr substringFromIndex:1];
            NSLog(@"path:%@",path);
            NSLog(@"tempStr:%@",tempStr);
            [getCurrentFolder setObject:tempStr forKey:@"currentFolder"];

        } else {
            flagError = 0;
        }
    }else{
        NSLog(@"[getCurrentFolder %@",path);
        [getCurrentFolder setObject:path forKey:@"currentFolder"];
    }
}

//查询目录函数
-(NSDictionary *) catalogQuery:(NSString *) pathItem catalog:(NSDictionary *)cata{
    for (NSString *key in cata) {
        NSLog(@"key:%@",key);
        NSLog(@"missionPath[key]:%@",missionPath[key]);
        if([pathItem isEqualToString:key]){
            return missionPath[key];
        }else{
            NSLog(@"error，没有找到对应的目录！！！！！！！！！！！！！！！！！！！！！！！！！！！！");
        }
    }
    return missionPath;
}
@end
