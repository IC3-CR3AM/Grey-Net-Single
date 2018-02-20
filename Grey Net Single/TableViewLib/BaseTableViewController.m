//
//  BaseTableViewController.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/8.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SettingModel.h"       /**添加模型数据*/
#import "SettingArrowModel.h"  /**添加箭头模型数据*/
#import "Group.h"              /**添加组模型数据*/
#import "SettingCell.h"        /**添加cell*/
#import "UIView+DKSBadge.h"    /*小红点*/
#import "FCoverViewController.h"
#import "InboxView.h"
#import "ConsoleView.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //set nav title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"GREY NET";
    self.navigationItem.titleView = titleLabel;
    //设置bar透明
//    UIImage * imageTranslucent = [[UIImage alloc]init];
//    UINavigationBar * bar = self.navigationController.navigationBar;
//    [bar setBackgroundImage:imageTranslucent forBarMetrics:UIBarMetricsDefault];
//    bar.barStyle = UIBarStyleBlackOpaque;
    
    //设置工具栏
    //取消隐藏工具栏
    self.navigationController.toolbarHidden = NO;
    //设置工具栏透明
    self.navigationController.toolbar.translucent = NO;
    
    //小红点 red point
    _inboxRedPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inboxRedPointBtn setTitle:@"Inbox" forState:UIControlStateNormal];
    [_inboxRedPointBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_inboxRedPointBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
//    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    _inboxRedPointBtn.frame = CGRectMake(0, 0, 47, 25);
    [_inboxRedPointBtn showBadge];
    [_inboxRedPointBtn addTarget:self action:@selector(inboxView) forControlEvents:UIControlEventTouchUpInside];
    //工具栏按钮
    UIBarButtonItem * btnInbox = [[UIBarButtonItem alloc]initWithCustomView:_inboxRedPointBtn];
    UIBarButtonItem * btnConsole = [[UIBarButtonItem alloc] initWithTitle:@"Console" style:UIBarButtonItemStylePlain target:self action:@selector(consoleView)];
//    UIBarButtonItem * btnInbox = [[UIBarButtonItem alloc] initWithTitle:@"Inbox" style:UIBarButtonItemStylePlain target:self action:@selector(inboxView)];
    UIBarButtonItem * flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                               target:nil
                                               action:nil];
//    UIButton* btnImg = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnImg setImage:[UIImage imageNamed:@"functionButton.png"] forState:UIControlStateNormal];
//    btnImg.frame = CGRectMake(0, 0, 20, 20);
//
//    UIBarButtonItem * btnTool = [[UIBarButtonItem alloc]initWithCustomView:btnImg];
    
//    UIBarButtonItem * btnTool = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"functionButton.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
//    [btnTool setTarget:self];
    
    NSArray * arrayBtn = [NSArray arrayWithObjects:btnConsole,flexibleSpaceBarButton,btnInbox, nil];
    self.toolbarItems = arrayBtn;
}

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:NO];
}
-(void) inboxView{
    [_inboxRedPointBtn hidenBadge];
    InboxView * vc = [[InboxView alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setToolbarHidden:YES];
    NSLog(@"go to InboxView!");
    //设置bar透明
    //    UIImage * imageTranslucent = [[UIImage alloc]init];
    //        UINavigationBar * bar = self.navigationController.navigationBar;
    //    [bar setBackgroundImage:imageTranslucent forBarMetrics:UIBarMetricsDefault];
    //    bar.barStyle = UIBarStyleBlackOpaque;
    //--------------------------------------------------------------------
}

-(void) consoleView{
    ConsoleView * vc = [[ConsoleView alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setToolbarHidden:YES];
//    vc.hidesBottomBarWhenPushed = YES;
    NSLog(@"go to ConsoleView!");
    //设置bar透明
    //    UIImage * imageTranslucent = [[UIImage alloc]init];
    //        UINavigationBar * bar = self.navigationController.navigationBar;
    //    [bar setBackgroundImage:imageTranslucent forBarMetrics:UIBarMetricsDefault];
    //    bar.barStyle = UIBarStyleBlackOpaque;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - Table view data source

/**1.2.3 返回dataArray数组的总数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
/**1.2.4 从数组中取出每个section的组模型,再返回组模型中items的数量*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Group *group = self.dataArray[section];
    return group.items.count;
}
/**1.2.5 自定义cell*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *setCell = [SettingCell settingCellWithTableView:tableView];
    /**1.2.6 给cell传递数据模型*/
    Group *group = self.dataArray[indexPath.section];
    setCell.items = group.items[indexPath.row];
    return setCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**1.3.1 点击cell后,立即取消选中,即点击后,马上灰色部分消失*/
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /**1.3.2 取出数据模型*/
    Group *group = self.dataArray[indexPath.section];
    SettingModel *items = group.items[indexPath.row];
    
    /**1.3.3 执行更新,如果block中有值,调用*/
    if (items.myBlocks){
        items.myBlocks();
    }
    /**1.3.4 如果cell右边显示是箭头,跳转控制器*/
    if ([items isKindOfClass:[SettingArrowModel class]]) {
        /**将数据模型转换成箭头模型*/
        SettingArrowModel *arrowItems = (SettingArrowModel *)items;
        /**如果箭头模型中的class为空,直接返回*/
        if (arrowItems.desClass == nil) return;
        /**创建控制器,根据箭头中的class属性*/
        UIViewController *VC = [[arrowItems.desClass alloc] init];
        if(arrowItems.desClass == [FCoverViewController class]){
            [self presentViewController:VC animated:YES completion:^{
                NSLog(@"从mainview切换到首页");
            }];
        } else {
            [self.navigationController pushViewController:VC animated:YES];
//            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController setToolbarHidden:YES];
            NSLog(@"从mainview切换到 navigarion");
        }
    }
}

@end

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
