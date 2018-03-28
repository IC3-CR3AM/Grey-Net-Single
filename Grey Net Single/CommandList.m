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
    NSArray * missionList;
    NSUserDefaults * currentFolder;
}
@end

@implementation CommandList
-(id) init{
    if (self=[super init]) {
        path = [[NSBundle mainBundle] pathForResource:@"MissionFileList" ofType:@"plist"];
        root = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}
// 传入第几个任务
-(void) CommandLs:(int) num{
    NSLog(@"show list");
    NSUserDefaults * getCurrentFolder = [NSUserDefaults standardUserDefaults];
    NSString * currentFolder = [getCurrentFolder stringForKey:@"currentFolder"];
    NSLog(@"currentFolder:%@",currentFolder);
//    NSMutableArray * folders = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        
    }
    NSString * mission = [@"mission" stringByAppendingFormat:@"%d",num ];
    missionPath = [root objectForKey:mission];
    for (NSString *key in missionPath) {
        NSLog(@"key:%@",key);
        //[dic objectForKey:key];
        NSLog(@"missionPath[key]:%@",missionPath[key]);
    }
//    NSLog(@"%@", missionList);
    if([currentFolder isEqualToString:@"/"]){
        NSLog(@"currentFolder is equla to /");
    }
}
//传入路径
-(void) CommandCd:(NSString *) path{
    
}

//显示
-(NSString *)Show{
    
    return @"0";
}
@end
