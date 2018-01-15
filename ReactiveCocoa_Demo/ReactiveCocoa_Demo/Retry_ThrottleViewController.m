//
//  Retry_ThrottleViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/11.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "Retry_ThrottleViewController.h"

#import "ReactiveObjC.h"

@interface Retry_ThrottleViewController ()

@property (nonatomic, strong) RACSubject *signal;

@end

@implementation Retry_ThrottleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Retry_Throttle";
    
//    [self retry1];
//    [self retry2];
    [self throttle];
}

- (void)retry1 {
//    retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (i == 10) {
            [subscriber sendNext:@1];
        }else{
            NSLog(@"接收到错误 i = %zd", i);
            [subscriber sendError:nil];
        }
        i++;
        return nil;
    }] retry] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)retry2 {
//    replay 重放：当一个信号被多次订阅,反复播放内容(打印测试：调用replay和不调用打印结果一样)
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        return nil;
    }] replay];
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [subscriber sendNext:@1];
//        [subscriber sendNext:@2];
//        return nil;
//    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者: %@", x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者: %@",x);
    }];
}

- (void)throttle {
//    throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
    RACSubject *signal = [RACSubject subject];
    _signal = signal;
//    节流，在一定时间（1秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
    [[signal throttle:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_signal sendNext:@"touchesBegan sendNext"];
}



@end
