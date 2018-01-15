//
//  Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatestViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/11.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatestViewController.h"

#import "ReactiveObjC.h"

@interface Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatest";
    
//    [self filter];
//    [self ignore];
//    [self distinctUntilChanged];
//    [self take];
//    [self takeLast];
//    [self takeUntil];
//    [self skip1];
//    [self skip2];
    [self switchToLatest];
}

- (void)filter {
//    filter:过滤信号，使用它可以获取满足条件的信号.
    // 过滤:
    // 每次信号发出，会先执行过滤条件判断.
    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)ignore {
//    ignore:忽略完某些值的信号.
//    内部调用filter过滤，忽略掉ignore的值
    [[self.textField.rac_textSignal ignore:@"1"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)distinctUntilChanged {
//    distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉
//    过滤，当上一次和当前的值不一样，就会发出内容。
//    在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新

    
    RACSignal *signal0 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@(0)];
        [subscriber sendNext:@(0)];
        [subscriber sendCompleted];
        return nil;
    }];
    [[signal0 distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal0 subscribeNext: %@", x);
    }];
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@(0)];
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];
        return nil;
    }];
    [[signal1 distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal1 subscribeNext: %@", x);
    }];
}

- (void)take {
//    take:从开始一共取N次的信号
//    1、创建信号
    RACSubject *subject = [RACSubject subject];
//    2、处理信号，订阅信号
    [[subject take:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
    // 3.发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendCompleted];
}

- (void)takeLast {
//    takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号
//    1、创建信号
    RACSubject *subject = [RACSubject subject];
//    2、处理信号，订阅信号
    [[subject takeLast:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
    // 3.发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendCompleted];
}

- (void)takeUntil {
//    takeUntil:(RACSignal *):获取信号直到某个信号执行完成
//    监听文本框的改变直到当前对象被销毁
    [[self.textField.rac_textSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)skip1 {
//    skip:(NSUInteger):跳过几个信号,不接受。
//    1、创建信号
    RACSubject *subject = [RACSubject subject];
//    2、处理信号，订阅信号
    [[subject skip:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
// 3.发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendCompleted];
}

- (void)skip2 {
    [[self.textField.rac_textSignal skip:1] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)switchToLatest {
//    switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal1 = [RACSubject subject];
    RACSubject *signal2 = [RACSubject subject];
    
//    获取信号中信号最近发出信号，订阅最近发出的信号。
//    注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
    
    [signalOfSignals sendNext:signal1];
    [signal1 sendNext:@"signal1 1"];
    [signal1 sendNext:@"signal1 2"];
    [signal1 sendCompleted];
    
    [signalOfSignals sendNext:signal2];
    [signal2 sendNext:@"signal2 1"];
    [signal2 sendNext:@"signal2 2"];
    [signal2 sendCompleted];
    //============实际订阅到了所有信号=============
}


@end
