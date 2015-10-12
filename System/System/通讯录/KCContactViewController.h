//
//  KCContactViewController.h
//  System
//
//  Created by 庞博 on 15/10/10.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KCContactDelegate

//新增或修改联系人
-(void)editPersonWithFirstName:(NSString*)firstName lastName:(NSString *)lastName workNumber:(NSString *)workNumber;

//取消修改或新增
-(void)cancelEdit;
@end

@interface KCContactViewController : UIViewController


@end
