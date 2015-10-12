//
//  MCBrowerViewController.m
//  System
//
//  Created by 庞博 on 15/10/12.
//  Copyright © 2015年 wk. All rights reserved.
//

#import "MCBrowerViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCBrowerViewController ()<MCSessionDelegate,MCAdvertiserAssistantDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property(nonatomic,strong) MCSession*session;

@property(nonatomic,strong) MCAdvertiserAssistant * advertiserAssistant;
@property(nonatomic,strong) UIImagePickerController*imagePickerController;

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation MCBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建节点，displayName是用于提供给周边设备查看和区分此服务的
    MCPeerID* peerID = [[MCPeerID alloc]initWithDisplayName:@"KenshinCui_Advertiser"];
    self.session = [[MCSession alloc]initWithPeer:peerID];
    
    self.session.delegate = self;
    
     //创建广播
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc]initWithServiceType:@"cmj-stream" discoveryInfo:nil session:_session];
    
    self.advertiserAssistant.delegate = self;
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startSpeak:(UIBarButtonItem *)sender {
    //开始广播
    [self.advertiserAssistant start];
    
    
}
- (IBAction)choosePhoto:(UIBarButtonItem *)sender {
    
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}


#pragma mark - MCSession代理方法
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"didChangeState");
    
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"连接成功");
            break;
        case MCSessionStateConnecting:
            NSLog(@"正在链接....");
            break;
        
            
        default:
            NSLog(@"链接失败");
            break;
    }


}

//接收数据
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"开始接收数据...");
    UIImage *image=[UIImage imageWithData:data];
    [self.photo setImage:image];
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"didFinishReceive %@-%@-%@-%@-%@",session,resourceName,peerID,localURL,error);

}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{

}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{

}

-(void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler
{

}



#pragma mark - MCAdvertiserAssistant代理方法


#pragma mark - UIImagePickerController代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage*image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.photo setImage:image];
    
    //发送数据给所有已链接设备
    NSError*error = nil;
    
    [self.session sendData:UIImagePNGRepresentation(image) toPeers:[self.session connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    NSLog(@"开始发送数据");
    if (error) {
         NSLog(@"发送数据过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
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
