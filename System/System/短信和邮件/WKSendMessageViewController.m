//
//  WKSendMessageViewController.m
//  System
//
//  Created by 庞博 on 15/10/10.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import "WKSendMessageViewController.h"
#import <MessageUI/MessageUI.h>
@interface WKSendMessageViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *receivers;

@property (weak, nonatomic) IBOutlet UITextField *body;

@property (weak, nonatomic) IBOutlet UITextField *subject;

@property (weak, nonatomic) IBOutlet UITextField *attachments;
@property (weak, nonatomic) IBOutlet UITextField *gogog;

@end



@implementation WKSendMessageViewController

@dynamic body;
@dynamic subject;
@dynamic attachments;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.gogog);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessage:(UIButton *)sender {
    
    //如果能发送文本
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController*messageController = [[MFMessageComposeViewController alloc]init];
        
        //收件人
        messageController.recipients = [self.receivers.text componentsSeparatedByString:@","];
        
        //信息正文
        messageController.body = self.body.text;
        
        
        //设置代理,注意这里不是delegate而是messageComposeDelegate
        messageController.messageComposeDelegate = self;
        
        //如果运行商支持主题
        if ([MFMessageComposeViewController canSendSubject]) {
            messageController.subject = self.subject.text;
        }
        
        
        //如果运行商支持附件
        if ([MFMessageComposeViewController canSendAttachments]) {
            
            /*第一种方法*/
            //messageController.attachments=...;
            
            /*第二种方法*/
            NSArray *attachments= [self.attachments.text componentsSeparatedByString:@","];
            if (attachments.count>0) {
                [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSString *path=[[NSBundle mainBundle]pathForResource:obj ofType:nil];
                    NSURL *url=[NSURL fileURLWithPath:path];
                    [messageController addAttachmentURL:url withAlternateFilename:obj];
                }];
            }
            
            /*第三种方法*/
            //            NSString *path=[[NSBundle mainBundle]pathForResource:@"photo.jpg" ofType:nil];
            //            NSURL *url=[NSURL fileURLWithPath:path];
            //            NSData *data=[NSData dataWithContentsOfURL:url];
            /**
             *  attatchData:文件数据
             *  uti:统一类型标识，标识具体文件类型，详情查看：帮助文档中System-Declared Uniform Type Identifiers
             *  fileName:展现给用户看的文件名称
             */
            //            [messageController addAttachmentData:data typeIdentifier:@"public.image"  filename:@"photo.jpg"];
            
            
        }
        
        [self presentViewController:messageController animated:YES completion:nil];
        
        
    }
    
    
}

#pragma mark - MFMessageComposeVIewController-代理方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"发送取消");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
            
            
        default:
            break;
    }
    
}
@end
