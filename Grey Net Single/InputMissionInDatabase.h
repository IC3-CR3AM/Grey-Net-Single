//
//  InputMissionInDatabase.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/3/6.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface InputMissionInDatabase : NSObject
@property FMDatabase * db;
@property (copy,nonatomic) NSString * uTitle;

@end
