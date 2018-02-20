//
//  ConsoleView.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface ConsoleView : BaseView <UITextViewDelegate>
{
    @protected
    UILabel *titleLabel;
    UILabel* owner;
}
@property (nonatomic,strong) UITextView * commandTV;
@end
