//
//  ViewController.m
//  System
//
//  Created by 庞博 on 15/10/10.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//电话
- (IBAction)callClick:(UIButton *)sender {
    
    NSString*phoneNumber = @"13691315778";
    
    //NSString*url = [NSString stringWithFormat:@"tel:%@",phoneNumber];//直接拨打电话
    
    NSString *url = [NSString stringWithFormat:@"telprompt:%@",phoneNumber];//是否拨打
    [self openUrl:url];
    
    
}

//短信
- (IBAction)sendMessageClick:(UIButton *)sender {
    
    NSString*phoneNumber = @"13691315778";
    NSString*url = [NSString stringWithFormat:@"sms:%@",phoneNumber];
    [self openUrl:url];
    
}

//邮件
- (IBAction)sendEmailClick:(UIButton *)sender {
    NSString*emali = @"778109672@qq.com";
    NSString*url = [NSString stringWithFormat:@"mailto:%@",emali];
    [self openUrl:url];
    
    
    
}


//网页
- (IBAction)browserClick:(UIButton *)sender {
    
    NSString*url = @"http://www.baidu.com";
    [self openUrl:url];
    
}

#pragma mark - 私有方法
-(void)openUrl:(NSString*)urlStr
{
    NSURL*url = [NSURL URLWithString:urlStr];
    UIApplication*application = [UIApplication sharedApplication];
    if (![application canOpenURL:url]) {
        NSLog(@"无法打开\"%@\",请确保此应用正确安装.",url);
        return;
    }

    [application openURL:url];



}


@end
