//
//  FCoverViewController.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/6.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "FCoverViewController.h"
#import "VCRoot.h"

@interface FCoverViewController ()

@end

@implementation FCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //get device's bounds
    CGRect rx = [ UIScreen mainScreen ].bounds;
    //set bg with image
    NSString* strName = [NSString stringWithFormat:@"first_bg.jpg"];
    
    UIImage* image = [UIImage imageNamed:strName];
    
    UIImageView* iView = [[UIImageView alloc] initWithImage:image];
    
    iView.frame = rx;
    
    iView.userInteractionEnabled =YES;
    //button goto rootView
    UIButton* functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    functionButton.frame = CGRectMake(rx.size.width/2-50, rx.size.height - 100, 100, 100);
    
    [functionButton setImage:[UIImage imageNamed:@"functionButton.png"] forState:UIControlStateNormal];
    //set gesture interactive
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
    
    tap.numberOfTapsRequired = 1;
    
    tap.numberOfTouchesRequired = 1;
    
    [functionButton addGestureRecognizer:tap];
    //add view to screen
    [iView addSubview:functionButton];
    
    [self.view addSubview:iView];
}

-(void) pressTap:(UITapGestureRecognizer*) tap{
//    VCRoot * vcrootView = [[VCRoot alloc]init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[VCRoot alloc] init]];
    [self presentViewController:nav animated:YES completion:^{
        NSLog(@"从viewController:self 切换到vcrootView");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
