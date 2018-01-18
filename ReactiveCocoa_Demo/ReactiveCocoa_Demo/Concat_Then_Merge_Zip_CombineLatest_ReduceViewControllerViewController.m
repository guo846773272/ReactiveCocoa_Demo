//
//  Concat_Then_Merge_Zip_CombineLatest_ReduceViewControllerViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/11.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "Concat_Then_Merge_Zip_CombineLatest_ReduceViewControllerViewController.h"

#import "ReactiveObjC.h"

@interface Concat_Then_Merge_Zip_CombineLatest_ReduceViewControllerViewController ()

@end

@implementation Concat_Then_Merge_Zip_CombineLatest_ReduceViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Concat_Then_Merge_ZipWith_CombineLatest";
    
//    [self concat];
//    [self then];
//    [self merge];
//    [self zip];
//    [self combineLatest];
    [self reduce];
}

- (void)concat {
    //concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
    RACSignal *signal0 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@0];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    //     把signal0拼接到signal1后，signal0发送完成，signal1才会被激活。
    RACSignal *concatSignal = [signal0 concat:signal1];
    //     以后只需要面对拼接信号开发。
    //     订阅拼接的信号，不需要单独订阅signal0，signal1
    //     内部会自动订阅。
    //     注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"subscribeNext: %@", x);
    }];
    //     concat底层实现:
    //     1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
    //     2.didSubscribe中，会先订阅第一个源信号（signalA）
    //     3.会执行第一个源信号（signalA）的didSubscribe
    //     4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
    //     5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
    //     6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
    //     7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
}

- (void)then {
    //     then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    //     注意使用then，之前信号的值会被忽略掉.
    //     底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@0];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@1];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        //        只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)merge {
    //    merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
    //创建多个信号
    RACSignal *signal0 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@0];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    //    合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signal0 merge:signal1];
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
    //    底层实现：
    //    1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
    //    2.每发出一个信号，这个信号就会被订阅
    //    3.也就是合并信号一被订阅，就会订阅里面所有的信号。
    //    4.只要有一个信号被发出就会被监听。
}

- (void)zip {
    //    zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
    RACSignal *signal0 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@0];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    //    压缩信号A，信号B
    RACSignal *zipSignal = [signal0 zipWith:signal1];
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
        NSLog(@"%@", x[0]);
        NSLog(@"%@", x[1]);
    }];
    //    底层实现:
    //    1.定义压缩信号，内部就会自动订阅signalA，signalB
    //    2.每当signalA或者signalB发出信号，就会判断signalA，signalB有没有发出个信号，有就会把最近发出的信号都包装成元组发出。
}

- (void)combineLatest {
    //    combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
    RACSignal *signal0 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@0];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    //    把两个信号组合成一个信号,跟zip一样，没什么区别
    RACSignal *combineLatestSignal = [signal0 combineLatestWith:signal1];
    [combineLatestSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
        NSLog(@"%@", x[0]);
        NSLog(@"%@", x[1]);
    }];
    //    底层实现：
    //    1.当组合信号被订阅，内部会自动订阅signalA，signalB,必须两个信号都发出内容，才会被触发。
    //    2.并且把两个信号组合成元组发出。
}

- (void)reduce {
    //    reduce 聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
    RACSignal *signal0 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@0];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    //     聚合
    //     常见的用法，（先组合在聚合）。combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
    //     reduce中的block简介:
    //     reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    //     reduceblcok的返回值：聚合信号之后的内容。
    RACSignal *reduceSignal = [RACSignal combineLatest:@[signal0, signal1] reduce:^id _Nullable(NSNumber *num1 ,NSNumber *num2){
        return [NSString stringWithFormat:@"signal0: %@ signal1: %@", num1, num2];
    }];
    [reduceSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
    //     底层实现:
    //     1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。
}

@end
