//
//  FCoverViewController.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/6.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FMDatabase.h>

@interface FCoverViewController : UIViewController
<
UITextFieldDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource
>
//define property
@property (retain,nonatomic) UITextField* idTF;
@property (nonatomic) CGFloat textY;
@property (nonatomic) CGFloat textHeight;
@property (copy,nonatomic) NSString * userID;
@property (nonatomic) NSInteger missionIndex;
@property FMDatabase * db;

@end
