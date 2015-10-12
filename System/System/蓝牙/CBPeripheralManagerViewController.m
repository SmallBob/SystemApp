//
//  CBPeripheralManagerViewController.m
//  System
//
//  Created by 庞博 on 15/10/12.
//  Copyright © 2015年 wk. All rights reserved.
//

#import "CBPeripheralManagerViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define kPeripheralName @"外围设备" //外围设备名称
#define kServiceUUID @"C4FB2349-72FE-4CA2-94D6-1F3CB16331EE" //服务的UUID
#define kCharacteristicUUID @"6A3E4B28-522D-4B3B-82A9-D5E2004534FC" //特征的UUID



@interface CBPeripheralManagerViewController ()<CBPeripheralManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *log;


@property(nonatomic,strong)CBPeripheralManager*peripheralManager;//外围设备管理器
@property(nonatomic,strong)NSMutableArray*centralM;//订阅此外围设备特征的中心设备
@property(nonatomic,strong)CBMutableCharacteristic * characteristicM;//特征


@end

@implementation CBPeripheralManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)start:(UIBarButtonItem *)sender {
    
    _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    
    
    
    
}
- (IBAction)refresh:(UIBarButtonItem *)sender {
    
    
}
#pragma mark - CBPeripheralManager代理方法
//外围设备状态发生变化后调用
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"BLE已打开.");
            [self writeToLog:@"BLE已打开."];
            //添加服务
            [self setupService];
            break;
            
        default:
            NSLog(@"此设备不支持BLE或未打开蓝牙功能，无法作为外围设备.");
            [self writeToLog:@"此设备不支持BLE或未打开蓝牙功能，无法作为外围设备."];
            break;
    }
}

#pragma mark - 私有方法
/**
 *  记录日志
 *
 *  @param info 日志信息
 */
-(void)writeToLog:(NSString *)info{
    self.log.text=[NSString stringWithFormat:@"%@\r\n%@",self.log.text,info];
}

//创建特征、服务并添加服务到外围设备
-(void)setupService{
    /*1.创建特征*/
    //创建特征的UUID对象
    CBUUID*characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
    //特征值
    //    NSString *valueStr=kPeripheralName;
    //    NSData *value=[valueStr dataUsingEncoding:NSUTF8StringEncoding];
    //创建特征
    /** 参数
     * uuid:特征标识
     * properties:特征的属性，例如：可通知、可写、可读等
     * value:特征值
     * permissions:特征的权限
     */
    
    CBMutableCharacteristic*characteristicM = [[CBMutableCharacteristic alloc]initWithType:characteristicUUID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    self.characteristicM = characteristicM;
    
    //    CBMutableCharacteristic *characteristicM=[[CBMutableCharacteristic alloc]initWithType:characteristicUUID properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    //    characteristicM.value=value;

    /*创建服务并且设置特征*/
    //创建服务UUID对象
    CBUUID*serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    //创建服务
    CBMutableService*sericeM = [[CBMutableService alloc]initWithType:serviceUUID primary:YES];
    //设置服务的特征
    [sericeM setCharacteristics:@[characteristicM]];
    
    /*将服务添加到外围设备*/
    [self.peripheralManager addService:sericeM];
    
    

}

//更新特征值
-(void)updateCharacteristicValue{
    //特征值
    NSString *valueStr=[NSString stringWithFormat:@"%@ -- %@",kPeripheralName,[NSDate date]];
    
    
    
    NSData *value=[valueStr dataUsingEncoding:NSUTF8StringEncoding];
    //更新特征值
    [self.peripheralManager updateValue:value forCharacteristic:self.characteristicM onSubscribedCentrals:nil];
    [self writeToLog:[NSString stringWithFormat:@"更新特征值：%@",valueStr]];
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
