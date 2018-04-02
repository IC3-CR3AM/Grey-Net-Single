//
//  CommandList.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/25.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandList : NSObject
-(NSMutableArray *) CommandLs:(int) num;
-(void) CommandCd:(NSString *) path;
@end
