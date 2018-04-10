//
//  ConsoleView.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/2/18.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "ConsoleView.h"
#import "IQKeyboardManager.h"
#import "PingView.h"
#import "SSHView.h"
#import "HelpPageView.h"
#import "CommandList.h"
#define SCREEN_W [UIScreen mainScreen].bounds.size.width    //屏幕宽度
#define SCREEN_H [UIScreen mainScreen].bounds.size.height   //屏幕高度

@interface ConsoleView(){
    NSString *currentUserName;
}

@property (nonatomic,assign) CGRect kbRect;

@end

@implementation ConsoleView

- (void)viewDidLoad {
    [super viewDidLoad];
//    //solve the bug after ios7.0
//    self.view.backgroundColor = [UIColor whiteColor];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
    //set nav title
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Console";
    self.navigationItem.titleView = titleLabel;
    
    //uilabe
    owner = [[UILabel alloc]init];
    owner.numberOfLines = 1;
    owner.text = @"Please enter your command";
    owner.frame = CGRectMake(20, 0, self.view.bounds.size.width, self.view.bounds.size.height/13);
    owner.textColor = [UIColor whiteColor];
    owner.font = [UIFont boldSystemFontOfSize:27];
    [self.view addSubview:owner];
    //当前用户
    NSUserDefaults *currentUser = [NSUserDefaults standardUserDefaults];
    currentUserName = [currentUser stringForKey:@"currentUser"];
    currentUserName = [currentUserName stringByAppendingString:@"#"];
    NSLog(@"当前用户：%@",currentUserName);
    //textview
    commandTV = [[UITextView alloc]init];
    commandTV.frame = CGRectMake(20, self.view.bounds.size.height/15, self.view.bounds.size.width-40, self.view.bounds.size.height- self.view.bounds.size.height/5);
//    commandTV.frame = CGRectMake(20, 10, self.view.bounds.size.width-40, self.view.bounds.size.height);
    commandTV.textColor = [UIColor whiteColor];
    commandTV.backgroundColor = [UIColor clearColor];
    commandTV.font = [UIFont systemFontOfSize:27];
    commandTV.text = currentUserName;
    [commandTV setDelegate:self];
//    [_commandTV setEditable:NO];
    [self.view addSubview:commandTV];
    
//    [IQKeyboardManager s]
}
//按回车将键盘回收
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    [_commandTV resignFirstResponder];
//    return YES;
//}
//为了在textView的内容发生变化都能更新偏移量
//当然也可以通过KVO的方式监听textView的内容变化，不过代理方法已经用了，就....
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text
{
    //如果为回车则将键盘收起
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        NSLog(@"text get: %@", textView.text);
        //获取最后一行的开头
        NSRange ran = [textView.text rangeOfString:currentUserName];
        NSMutableArray * ran1 = [self getRangeStr:textView.text findText:currentUserName];
        NSString * ran1Location = [ran1 lastObject];
        NSString * temp = [textView.text substringFromIndex:([ran1Location intValue]+ran.length)];
        //--------------------------------console通过命令切换到各个页面------------------------------------
        if([temp hasPrefix:@"Ping"] || [temp hasPrefix:@"ping"]) {
            NSLog(@"包含Ping字符");
            PingView * vc = [[PingView alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            //进入后回车
            NSString * temp2 = [@"\n" stringByAppendingString:currentUserName];
            commandTV.text = [commandTV.text stringByAppendingString:temp2];
        } else if ([temp hasPrefix:@"ssh"] || [temp hasPrefix:@"SSH"] || [temp hasPrefix:@"Ssh"]){
            NSLog(@"包含ssh字符");
            SSHView * vc = [[SSHView alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            //进入后回车
            NSString * temp2 = [@"\n" stringByAppendingString:currentUserName];
            commandTV.text = [commandTV.text stringByAppendingString:temp2];
        } else if ([temp hasPrefix:@"help"] || [temp hasPrefix:@"Help"]){
            NSLog(@"包含help字符");
            HelpPageView * vc = [[HelpPageView alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            //进入后回车
            NSString * temp2 = [@"\n" stringByAppendingString:currentUserName];
            commandTV.text = [commandTV.text stringByAppendingString:temp2];
        }
//        else if ([temp hasPrefix:@"clear"] || [temp hasPrefix:@"Clear"] || [temp hasPrefix:@"CLEAR"]){
//            NSLog(@"包含clear字符");
//            commandTV.text = currentUserName;
////            NSString * temp2 = [@"\n" stringByAppendingString:currentUserName];
////            commandTV.text = [commandTV.text stringByAppendingString:temp2];
//        }
        else if([temp isEqualToString:@""]){
            
        }
        else {
            NSString * temp2 = [@"\n" stringByAppendingString:currentUserName];
            temp2 = [temp2 stringByAppendingString:@" Can't understand command: "];
            temp2 = [temp2 stringByAppendingFormat:@"%@ \n%@",temp,currentUserName];
            commandTV.text = [commandTV.text stringByAppendingString:temp2];
        }
        return NO;
    }
//    [self autoAdjustTo:textView];
    return YES;
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    //范围
    NSRange ran = [textView.text rangeOfString:currentUserName];
    NSMutableArray * ran1 = [self getRangeStr:textView.text findText:currentUserName];
    
//    NSLog(@"范围：%@",ran1);
//    NSLog(@"最后一个：%@,长度：%lu",[ran1 lastObject],(unsigned long)ran.length);
    NSString * ran1Location = [ran1 lastObject];
//    NSLog(@"ran1Location：%@",ran1Location);

    if(ran1 != NULL  && [ran1Location intValue]!=0){
        if(textView.selectedRange.location + textView.selectedRange.length <= [ran1Location intValue]+ran.length){
            textView.selectedRange = NSMakeRange([ran1Location intValue]+ran.length, 0);
        }
    }
//    [self autoAdjustTo:textView];

}

#pragma mark - 获取这个字符串中的所有xxx的所在的index
- (NSMutableArray *)getRangeStr:(NSString *)originText findText:(NSString *)tryToFindText
{
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:50];
    NSString * text = originText;
    NSString * findText = tryToFindText;
    if (findText == nil && [findText isEqualToString:@""])
    {
        return nil;
    }
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    if (rang.location != NSNotFound && rang.length != 0)
    {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++)
        {
            NSLog(@"%d", i);
            if (0 == i)
            {//去掉这个xxx
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }
            else
            {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            //在一个range范围内查找另一个字符串的range
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                break;
            }
            else//添加符合条件的location进数组
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
        }
        return arrayRanges;
    }
    return nil;
}

//键盘出现
- (void)keyboardDidShow:(NSNotification *)notification{
    //获取键盘高度
    NSDictionary *dict = notification.userInfo;
    _kbRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    [self autoAdjustTo:commandTV];
}
//键盘消失
- (void)keyboardDidHidden:(NSNotification *)notification{
    commandTV.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
}

//是因为使用第三方库IQKeyboardManager，避免导航栏隐藏的BUG
- (void)loadView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scrollView;
}
- (void)autoAdjustTo:(UITextView *)textView{
    //1.计算键盘的位置 Y 坐标

    CGFloat kbY = CGRectGetMinY(_kbRect);
    //2.计算textView的 MAXY 和 MINY
    CGRect textRect = [textView convertRect:textView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat MAXY = CGRectGetMaxY(textRect);
    CGFloat MINY = CGRectGetMinY(textRect);
    NSLog(@"maxy:%f,miny:%f",MAXY,MINY);
    //3.计算textView 内容的高度
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(commandTV.frame), MAXFLOAT)];
    NSLog(@"size.width:%f,size.height:%f",size.width,size.height);
    //4.获取光标的位置
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.end].origin;
    CGPoint point = [textView convertPoint:cursorPosition toView:[UIApplication sharedApplication].keyWindow];

    NSLog(@"+++++++++++++++++光标坐标：%f   键盘坐标:%f++++++++++++++",point.y+15,kbY);

    //5.判断
    //当textView 的frame比较大，上移后还会被键盘遮挡的话
//    if (MAXY > kbY) {
        //当输入光标在键盘下方,15是字体的大小
        if (point.y+30>kbY) {
            //计算textView上内边距需要移动的高度
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat move = point.y + 30 - kbY - textView.textContainerInset.top;
                NSLog(@"=======================%f==============================",move);
                NSLog(@"---------------%f-----------------",textView.textContainerInset.top);
                //这里move-10是为了光标与键盘边界有点距离，更美观
                textView.textContainerInset = UIEdgeInsetsMake(-move-10-5, 5, 5, 5);
            }];
        }
//    }
}

//注销通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//按空白地方回收键盘
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
@end
