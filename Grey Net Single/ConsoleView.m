//
//  ConsoleView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "ConsoleView.h"

@implementation ConsoleView

- (void)viewDidLoad {
    [super viewDidLoad];
    //set nav title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Console";
    self.navigationItem.titleView = titleLabel;
}

@end
