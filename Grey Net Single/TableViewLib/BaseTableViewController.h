//
//  BaseTableViewController.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BaseTableViewController : UITableViewController
/**1.1存放模型数据,这个属性必须方法.h文件中,这样继承它的子类才可以调用*/
@property (strong, nonatomic) NSMutableArray *dataArray;
@property UIButton * inboxRedPointBtn;
@end
