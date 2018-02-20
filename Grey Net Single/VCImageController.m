//
//  VCImageController.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/1/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "VCImageController.h"

@interface VCImageController ()

@end

@implementation VCImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //nav backBtn
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //set background
    CGRect rx = [UIScreen mainScreen].bounds;
    _imageView = [[UIImageView alloc] init];
    _imageView.frame =rx;
//    _imageView.image = _image;
    _imageView.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO];
}
//-(void) backBtn{
//    [self.navigationController setToolbarHidden:NO];
//    self.navigationController.toolbar.translucent = NO;
//    NSLog(@"back to main view!");
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
