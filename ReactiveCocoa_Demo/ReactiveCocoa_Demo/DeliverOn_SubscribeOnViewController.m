//
//  DeliverOn_SubscribeOnViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/11.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "DeliverOn_SubscribeOnViewController.h"

@interface DeliverOn_SubscribeOnViewController ()

@end

@implementation DeliverOn_SubscribeOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DeliverOn_SubscribeOn";
    
//    deliverOn: 内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用。
//    subscribeOn: 内容传递和副作用都会切换到制定线程中。
}




@end
