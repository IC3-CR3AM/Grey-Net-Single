//
//  InboxView.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface InboxView : BaseView
@property (nonatomic) NSString * mail;
@property (nonatomic) NSString * tit;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * mUserID;
@property (nonatomic) NSInteger mUMissionIndex;
@property (nonatomic) NSInteger mUMissionProgress;

@end
