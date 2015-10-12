//
//  KCAddPersonViewController.m
//  System
//
//  Created by 庞博 on 15/10/10.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import "KCAddPersonViewController.h"

#import "KCContactViewController.h"

@interface KCAddPersonViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;

@property (weak, nonatomic) IBOutlet UITextField *workPhone;
@end

@implementation KCAddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

-(void)setupUI
{
    if (self.recordID) {//如果ID不为0则认为是修改，此时需要初始化界面
        self.firstName.text=self.firstNameText;
        self.lastName.text=self.lastNameText;
        self.workPhone.text=self.workPhoneText;
    }
}
- (IBAction)cancelClick:(UIBarButtonItem *)sender {
    [self.delegate cancelEdit];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (IBAction)doneClick:(UIBarButtonItem *)sender {
    //调用代理方法
    [self.delegate editPersonWithFirstName:self.firstName.text lastName:self.lastName.text workNumber:self.workPhone.text];
    
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
