//
//  GameKitViewController.m
//  System
//
//  Created by 庞博 on 15/10/10.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import "GameKitViewController.h"
#import <GameKit/GameKit.h>

@interface GameKitViewController ()<GKPeerPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;//照片显示地
@property(nonatomic,strong)GKSession*session; //7.0已经不用
@end

@implementation GameKitViewController


//此程序一个客户端运行在模拟器上作为客户端A，另一个运行在iPhone真机上作为客户端B（注意A、B必须运行同一个程序，GameKit蓝牙开发是不支持两个不同的应用传输数据的）。


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GKPeerPickerController *pearPickerController=[[GKPeerPickerController alloc]init];
    
    pearPickerController.delegate=self;
    
    [pearPickerController show];
    // Do any additional setup after loading the view.
}

#pragma mark - UI事件
- (IBAction)selectClick:(UIBarButtonItem *)sender {
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)sendClick:(UIBarButtonItem *)sender {
    NSData *data=UIImagePNGRepresentation(self.imageView.image);
    NSError *error=nil;
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
    if (error) {
        NSLog(@"发送图片过程中发生错误，错误信息:%@",error.localizedDescription);
    }
}

#pragma mark - GKPeerPickerController代理方法
/**
 *  连接到某个设备
 *
 *  @param picker  蓝牙点对点连接控制器
 *  @param peerID  连接设备蓝牙传输ID
 *  @param session 连接会话
 */
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    self.session=session;
    NSLog(@"已连接客户端设备:%@.",peerID);
    //设置数据接收处理句柄，相当于代理，一旦数据接收完成调用它的-receiveData:fromPeer:inSession:context:方法处理数据
    [self.session setDataReceiveHandler:self withContext:nil];
    
    [picker dismiss];//一旦连接成功关闭窗口
}

#pragma mark - 蓝牙数据接收方法
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
    UIImage *image=[UIImage imageWithData:data];
    self.imageView.image=image;
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    NSLog(@"数据发送成功！");
}
#pragma mark - UIImagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.imageView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
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
