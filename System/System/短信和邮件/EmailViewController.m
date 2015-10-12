//
//  EmailViewController.m
//  System
//
//  Created by 庞博 on 15/10/10.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import "EmailViewController.h"
#import <MessageUI/MessageUI.h>
@interface EmailViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *toTecipients;
@property (weak, nonatomic) IBOutlet UITextField *ccRecipients;
@property (weak, nonatomic) IBOutlet UITextField *bccRecipients;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextField *bodyTF;
@property (weak, nonatomic) IBOutlet UITextField *attTF;
@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEmail:(UIButton *)sender {
    
    //判断当前是否可发邮件
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController*emailController = [[MFMailComposeViewController alloc]init];
        
        emailController.mailComposeDelegate = self;
        
        [emailController setToRecipients:[self.toTecipients.text componentsSeparatedByString:@","]];
        
        if (self.ccRecipients.text.length>0) {
            [emailController setCcRecipients:[self.ccRecipients.text componentsSeparatedByString:@","]];
            
        }
        
        if (self.bccRecipients.text.length>0) {
            [emailController setBccRecipients:[self.bccRecipients.text componentsSeparatedByString:@","]];
            
        }
        
        [emailController setSubject:self.subject.text];
        
        [emailController setMessageBody:self.bodyTF.text isHTML:YES];
        
        if (self.attTF.text.length>0) {
            NSArray*attachments = [self.attTF.text componentsSeparatedByString:@","];
            
            [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString*file = [[NSBundle mainBundle] pathForResource:obj ofType:nil];
                NSData*data = [NSData dataWithContentsOfFile:file];
                [emailController addAttachmentData:data mimeType:@"image/jpg" fileName:obj];//第二个参数是mimeType类型，jpg图片对应image/jpeg
                
            }];
        }
        
        
        [self presentViewController:emailController animated:YES completion:nil];
    }
    
    
    
    
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"success");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"saved");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"failed");
            break;
            
            
        default:
            break;
    }
    
    if (error) {
         NSLog(@"发送邮件过程中发生错误，错误信息：%@",error.localizedDescription);
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
