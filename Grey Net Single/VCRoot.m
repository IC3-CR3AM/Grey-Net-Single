//
//  VCRoot.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/1/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "VCRoot.h"
#import "VCImageController.h"
#import "SettingCell.h"

@interface VCRoot ()

@end

@implementation VCRoot

- (void)viewDidLoad {
    [super viewDidLoad];
    //nav
    self.title = @"GREY NET";

    //set bar image translucent
//    UIImage * imageTranslucent = [[UIImage alloc]init];
//    UINavigationBar * bar = self.navigationController.navigationBar;
//    [bar setBackgroundImage:imageTranslucent forBarMetrics:UIBarMetricsDefault];
//    bar.barStyle = UIBarStyleBlackOpaque;
    
    //rect
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    //set button
    UIButton* functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    functionButton.frame = CGRectMake(rx.size.width/2 - 50, 100, 100, 100);
    [functionButton setImage:[UIImage imageNamed:@"functionButton.png"] forState:UIControlStateNormal];
    
    //set imageview
    NSString* strName = [NSString stringWithFormat:@"backGround.png"];

    UIImage* image = [UIImage imageNamed:strName];
        
    UIImageView* iView = [[UIImageView alloc] initWithImage:image];
        
    iView.frame = rx;

    iView.userInteractionEnabled =YES;
    //create gesture
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
        
    tap.numberOfTapsRequired = 1;
        
    tap.numberOfTouchesRequired = 1;
        
    [functionButton addGestureRecognizer:tap];
    
//    SettingCell * setCell = [[SettingCell alloc]init];
    
//    [iView addSubview:functionButton];

    //create tableview
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = iView;
    
//    [SettingCell settingCellWithTableView:_tableView];

//    [self.view addSubview:iView];
    [_tableView addSubview:functionButton];
    [self.view addSubview:_tableView];

}

-(void) pressTap:(UITapGestureRecognizer*) tap{
    VCImageController* imageShow = [[VCImageController alloc]init];
    
    [self.navigationController pushViewController:imageShow animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//set number of unit in one group
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
//how many groups do you have?
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//create cell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellStr = @"SettingCell";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
    }
    NSString * str = [NSString stringWithFormat:@"第%ld组,第%ld行",indexPath.section,indexPath.row];
    //set cell's attribute
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];

//    cell.selectionStyle = UITableViewCellSelectionStyleNone;//canel cell's select effect

    return cell;
}

//set height
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height / 8;
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
//cell effect
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//
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
