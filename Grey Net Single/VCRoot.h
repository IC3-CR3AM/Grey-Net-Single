//
//  VCRoot.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/1/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCRoot : UIViewController
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView* _tableView;
}
@end
