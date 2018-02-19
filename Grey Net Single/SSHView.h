//
//  SSHView.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/19.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface SSHView : BaseView <UITextFieldDelegate>
@property UITextField * ipTF;
@property UITextField * portTF;
@property NSString * ip;
@property NSString * port;

@end
