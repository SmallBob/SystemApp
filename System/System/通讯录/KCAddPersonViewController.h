//
//  KCAddPersonViewController.h
//  System
//
//  Created by 庞博 on 15/10/10.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KCContactDelegate ;



@interface KCAddPersonViewController : UIViewController

@property (assign,nonatomic) int recordID;//通讯录记录id，如果ID不为0则代表修改否则认为是新增
@property (strong,nonatomic) NSString *firstNameText;
@property (strong,nonatomic) NSString *lastNameText;
@property (strong,nonatomic) NSString *workPhoneText;

@property (strong,nonatomic) id<KCContactDelegate> delegate;


@end
