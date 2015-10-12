//
//  MessageViewController.m
//  System
//
//  Created by 庞博 on 15/10/10.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import "MessageViewController.h"


@interface MessageViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *receive;

@property (weak, nonatomic) IBOutlet UITextField *bodyTF;

@property (weak, nonatomic) IBOutlet UITextField *sujectTF;

@property (weak, nonatomic) IBOutlet UITextField *attTF;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)viewControl:(UIControl *)sender {
    
    [self.receive resignFirstResponder];
    [self.bodyTF resignFirstResponder];
    [self.sujectTF resignFirstResponder];
    [self.attTF resignFirstResponder];
    
}

- (IBAction)sendMessage:(UIButton *)sender {
    
    //MFMessageComposeViewController*messageController = [[MFMessageComposeViewController alloc]init];
    
    //如果能发送文本
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController*messageController = [[MFMessageComposeViewController alloc]init];
        
        //收件人
        messageController.recipients = [self.receive.text componentsSeparatedByString:@","];
        
        //信息正文
        messageController.body = self.bodyTF.text;
        
        
        //设置代理,注意这里不是delegate而是messageComposeDelegate
        messageController.messageComposeDelegate = self;
        
        //如果运行商支持主题
        if ([MFMessageComposeViewController canSendSubject]) {
            messageController.subject = self.sujectTF.text;
        }
        
        
        //如果运行商支持附件
        if ([MFMessageComposeViewController canSendAttachments]) {
            
            /*第一种方法*/
            //messageController.attachments=...;
            
            /*第二种方法*/
            NSArray *attachments= [self.attTF.text componentsSeparatedByString:@","];
            if (attachments.count>0 && attachments !=nil) {
                [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSString *path=[[NSBundle mainBundle]pathForResource:obj ofType:nil];
                    if (path != nil) {
                        NSURL *url=[NSURL fileURLWithPath:path];
                        [messageController addAttachmentURL:url withAlternateFilename:obj];
                    }
                    
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

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"success");
            break;
            case MessageComposeResultCancelled:
            NSLog(@"canclled");
            break;
            case MessageComposeResultFailed:
            NSLog(@"fails");
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
