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
    NSArray * missionList;
    NSUserDefaults * currentFolder;
}
@end

@implementation CommandList
-(id) init{
    if (self=[super init]) {
        path = [[NSBundle mainBundle] pathForResource:@"MissionFileList" ofType:@"plist"];
        root = [[NSDictionary alloc] initWithContentsOfFile:path];
//        missionList = [NSMutableArray arrayWithCapacity:root.count];
//        for(int i = 0; i < root.count; i++){
//
//        }
    }
    return self;
}
// 传入第几个任务
-(void) CommandLs:(int) num{
    NSLog(@"show list");
    NSString * mission = [@"mission" stringByAppendingFormat:@"%d",num ];
    missionList = [root objectForKey:mission];
    NSLog(@"%@", missionList);
}
@end
