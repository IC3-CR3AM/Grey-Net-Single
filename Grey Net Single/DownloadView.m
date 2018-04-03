//
//  DownloadView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/21.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "DownloadView.h"
#import "WKProgressBarLayer.h"

@interface DownloadView ()

@property (nonatomic, strong) WKProgressBarLayer *progressLayer;


@end

@implementation DownloadView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Download";
    self.navigationItem.titleView = titleLabel;
    
    //progress 进度条
    WKProgressBarLayer *progressLayer = [[WKProgressBarLayer alloc] init];
    progressLayer.frame = CGRectMake(100, 200, 200, 10);
//    progressLayer.backgroundColor = [UIColor whiteColor].CGColor;
    progressLayer.fillColor = [UIColor whiteColor].CGColor;
    progressLayer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.view.layer addSublayer:progressLayer];
    
    self.progressLayer = progressLayer;
    //开始下载
    [self.progressLayer beginAnimationWithDuration:10];
    //uilable
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
