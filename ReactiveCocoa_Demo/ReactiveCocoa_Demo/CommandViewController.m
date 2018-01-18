//
//  CommandViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/10.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "CommandViewController.h"

#import "ReactiveObjC.h"

@interface CommandViewController ()

@property (nonatomic, strong) RACCommand *command;

@end

@implementation CommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Command";
    
    
    
    [self command1];
//    [self command2];
//    [self command3];
//    [self signalOfSignals];
}

- (void)command1 {
    UIButton *reactiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    reactiveBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:reactiveBtn];
    [reactiveBtn setTitle:@"点我" forState:UIControlStateNormal];
    reactiveBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *input) {
        NSLog(@"点击了我:%@",input.currentTitle);
        //返回一个空的信号量
        return [RACSignal empty];
    }];
}

- (void)command2 {
    // 使用注意点：RACCommand中的block不能返回一个nil的信号
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"执行命令 %@", input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"信号发出的内容"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    //    _command = command;
    
    // executionSignals:信号源，包含事件处理的所有信号。
    // executionSignals: signalOfSignals,什么是信号中的信号，就是信号发出的数据也是信号类
    
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"command.executionSignals %@", x);
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"x %@", x);
        }];
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"command.executionSignals.switchToLatest: %@", x);
    }];
    
    // 监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"skip: %@", x);
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
    }];
    
    //开始执行
    [command execute:@(1)];
}

- (void)command3 {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"执行命令 %@", input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"信号发出的内容"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    [[command execute:@"execute"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)signalOfSignals
{
    // 创建一个信号中的信号
    RACSubject *signalOfSignals = [RACSubject subject];
    
    // 信号
    RACSubject *signal = [RACSubject subject];
    
    
    // 先订阅
    [signalOfSignals subscribeNext:^(id x) {
        
        // x -> 信号
        NSLog(@"%@",x);
        
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
    // 在发送
    
    [signalOfSignals sendNext:signal];
    
    [signal sendNext:@1];
    
    
}




@end
