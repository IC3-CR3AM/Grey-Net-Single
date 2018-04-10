//
//  HelpPageView.m
//  
//
//  Created by Frank Chen on 2018/4/5.
//

#import "HelpPageView.h"

@interface HelpPageView ()

@end

@implementation HelpPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"HELP";
    self.navigationItem.titleView = titleLabel;
    
//    //定义并创建一个滚动视图
//    UIScrollView * sv = [[UIScrollView alloc]init];
//
//    //设置位置和大小
//    sv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//
//    //是否按照整页滚动
//    sv.pagingEnabled = NO;
//    //是否开启滚动效果
//    sv.scrollEnabled = YES;
//    //设置整体画布大小
//    sv.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
//    //弹动
//    sv.bounces = YES;
//    sv.alwaysBounceVertical = YES;
//    //是否显示横向滚动
//    sv.showsHorizontalScrollIndicator = NO;
//    //是否显示纵向滚动
//    sv.showsVerticalScrollIndicator = NO;
//
//    NSString * imgStr = [NSString stringWithFormat:@"launchImage.jpg"];
//    UIImage * image = [UIImage imageNamed:imgStr];
//    UIImageView * iView = [[UIImageView alloc] initWithImage:image];
//    iView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//
//    [sv addSubview:iView];
//    [self.view addSubview:sv];
    
    //textView
    self.textView = [[UITextView  alloc] initWithFrame:self.view.frame]; //初始化大小并自动释放
    
    self.textView.textColor = [UIColor whiteColor];//设置textview里面的字体颜色
    
    self.textView.font = [UIFont fontWithName:@"Arial" size:25.0];//设置字体名字和字体大小
    
    self.textView.delegate = self;//设置它的委托方法
    
    self.textView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    
    self.textView.text = @"Now is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\nNow is the time for all good developers to come to serve their country.\n";//设置它显示的内容
    
//    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
//
//    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    self.textView.editable = NO;//禁止编辑
    
    self.textView.scrollEnabled = YES;//是否可以拖动
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [self.view addSubview: self.textView];//加入到整个页面中
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
