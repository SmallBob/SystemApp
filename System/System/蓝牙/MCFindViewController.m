//
//  MCFindViewController.m
//  System
//
//  Created by 庞博 on 15/10/12.
//  Copyright © 2015年 wk. All rights reserved.
//

#import "MCFindViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCFindViewController ()<MCSessionDelegate,MCBrowserViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)MCSession*session;
//@property(nonatomic,strong)MCAdvertiserAssistant*advertiserAssistant;
@property(nonatomic,strong)MCBrowserViewController*browserController;
@property(nonatomic,strong)UIImagePickerController*imagePickerController;


@property (weak, nonatomic) IBOutlet UIImageView *photo;


@end

@implementation MCFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建节点
    MCPeerID*peeID = [[MCPeerID alloc]initWithDisplayName:@"KenshinCui"];
    //创建绘画
    self.session = [[MCSession alloc]initWithPeer:peeID];
    self.session.delegate = self;
    
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)find:(UIBarButtonItem *)sender {
    
    self.browserController = [[MCBrowserViewController alloc]initWithServiceType:@"cmj-stream" session:self.session];
    
    self.browserController.delegate = self;
    
    [self presentViewController:self.browserController animated:YES completion:nil];
    
}
- (IBAction)choosePhoto:(UIBarButtonItem *)sender {
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];

}

#pragma mark - MCBrowserViewController代理方法

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    NSLog(@"已选择");
    [self.browserController dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    NSLog(@"取消浏览");
    [self.browserController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - MCSession代理方法
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"连接成功.");
            [self.browserController dismissViewControllerAnimated:YES completion:nil];
            break;
        case MCSessionStateConnecting:
            NSLog(@"正在连接...");
            break;
        default:
            NSLog(@"连接失败.");
            break;
    }


}

#pragma mark - 接受数据
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"开始接收数据");
    UIImage*image = [UIImage imageWithData:data];
    [self.photo setImage:image];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

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


#pragma mark - UIImagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photo setImage:image];
    //发送数据给所有已连接设备
    NSError *error=nil;
    [self.session sendData:UIImagePNGRepresentation(image) toPeers:[self.session connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    NSLog(@"开始发送数据...");
    if (error) {
        NSLog(@"发送数据过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
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
