//
//  Group.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Group : NSObject
/**4.1设置cell头部标题,如果有*/
@property (copy, nonatomic) NSString *header;

/**4.2设置cell尾部标题,如果有*/
@property (copy, nonatomic) NSString *fooder;

/**4.3存储cell的数据模型的数组*/
@property (strong, nonatomic) NSArray *items;
@end
