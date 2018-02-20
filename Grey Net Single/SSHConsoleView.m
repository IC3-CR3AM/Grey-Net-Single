//
//  SSHConsoleView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/20.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "SSHConsoleView.h"

@interface SSHConsoleView ()

@end

@implementation SSHConsoleView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleLabel.text = @"SSH Console";
    owner.text = @"SSH$";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
