//
//  Timeout_Interval_DelayViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/11.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "Timeout_Interval_DelayViewController.h"

#import "ReactiveObjC.h"

@interface Timeout_Interval_DelayViewController ()

@end

@implementation Timeout_Interval_DelayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Timeout_Interval_Delay";
    
//    [self timeOut];
//    [self interval];
    [self delay];
}

- (void)timeOut {
//    timeout：超时，可以让一个信号在一定的时间后，自动报错。
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return nil;
    }] timeout:2 onScheduler:[RACScheduler currentScheduler]];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)interval {
//    interval 定时：每隔一段时间发出信号
    [[RACSignal interval:2 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)delay {
//    delay 延迟发送next
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] delay:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}


@end
