//
//  SideEffectsViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/6.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "SideEffectsViewController.h"

#import "ReactiveObjC.h"

@interface SideEffectsViewController ()

@end

@implementation SideEffectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SideEffects";
    
//    [self repeatInvoke];
    
//    [self singleInvoke];
    
    [self singleInvoke2];
}

- (void)repeatInvoke {
    __block int a = 10;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        a += 5;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)singleInvoke {
    __block int a = 10;
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        a += 5;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] replayLast];//replayLast  让代码块只执行一次
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)singleInvoke2 {
    // 发送请求，用一个信号内包装，不管有多少个订阅者，只想要发送一次请求
    __block int a = 10;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // didSubscribeblock中的代码都统称为副作用。
        a += 5;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        
        return nil;
    }];
    // 1.创建连接类
    RACMulticastConnection *connection = [signal publish];
    // 2.订阅信号
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    // 3.连接：才会把源信号变成热信号
    [connection connect];
}








@end
