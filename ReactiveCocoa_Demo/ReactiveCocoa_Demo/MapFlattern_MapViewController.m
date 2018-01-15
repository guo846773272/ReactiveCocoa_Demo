//
//  MapFlattern_MapViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/11.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "MapFlattern_MapViewController.h"

#import "ReactiveObjC.h"
#import "RACReturnSignal.h"

@interface MapFlattern_MapViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MapFlattern_MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MapFlattern_Map";
    
//    [self flattenMap];
    [self map];
//    [self signalOfSignals];
}

// 字典转模型
- (void)dictConverModel {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    // 解析plist文件
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
    //    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
    
    // RAC高级写法:
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    //    [[dictArr.rac_sequence map:^id(id value) {
    //        NSLog(@"%@", value);
    //        return value;
    //    }] array];
    NSLog(@"%@", [[dictArr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return value;
    }] array]);
    
}

- (void)sequenceArray {
    NSArray *arr = @[@(1), @(2), @(3), @(4), @(5), @"6"];
    RACSequence *seq = [arr rac_sequence];
    NSLog(@"%@", [[seq map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue] * 3);
    }] array]);
}

- (void)sequenceFilter {
    NSArray *arr = @[@(1), @(2), @(3), @(4), @(5), @"6"];
    RACSequence *seq = [arr rac_sequence];
    NSLog(@"%@", [[seq filter:^BOOL(id  _Nullable value) {
        return [value integerValue] % 2 == 1;
    }] array]);
}

- (void)sequenceFlattenMap {
    RACSequence *s0 = [@[@(1), @(2), @(3)] rac_sequence];
    RACSequence *s1 = [@[@(1), @(3), @(9)] rac_sequence];
    
    NSLog(@"%@", [[[@[s0, s1] rac_sequence] flattenMap:^__kindof RACSequence * _Nullable(id  _Nullable value) {
        return value;
    }] array]);
}

- (void)flattenMap {
    // 监听文本框的内容改变，把结构重新映射成一个新值.
    
    // flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型。
    
    // flattenMap使用步骤:
    // 1.传入一个block，block类型是返回值RACStream，参数value
    // 2.参数value就是源信号的内容，拿到源信号的内容做处理
    // 3.包装成RACReturnSignal信号，返回出去。
    
    // flattenMap底层实现:
    // 0.flattenMap内部调用bind方法实现的,flattenMap中block的返回值，会作为bind中bindBlock的返回值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 2.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 3.调用bindBlock，内部就会调用flattenMap的block，flattenMap的block作用：就是把处理好的数据包装成信号。
    // 4.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 5.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    [[self.textField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        // block什么时候 : 源信号发出的时候，就会调用这个block。
        // block作用 : 改变源信号的内容。
        // 返回值：绑定信号的内容.
        return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@", value]];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}

- (void)map {
    // 监听文本框的内容改变，把结构重新映射成一个新值.
    
    // Map作用:把源信号的值映射成一个新的值
    
    // Map使用步骤:
    // 1.传入一个block,类型是返回对象，参数是value
    // 2.value就是源信号的内容，直接拿到源信号的内容做处理
    // 3.把处理好的内容，直接返回就好了，不用包装成信号，返回的值，就是映射的值。
    
    // Map底层实现:
    // 0.Map底层其实是调用flatternMap,Map中block中的返回的值会作为flatternMap中block中的值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 3.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 4.调用bindBlock，内部就会调用flattenMap的block
    // 5.flattenMap的block内部会调用Map中的block，把Map中的block返回的内容包装成返回的信号。
    // 5.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 6.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    [[self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        // 当源信号发出，就会调用这个block，修改源信号的内容
        // 返回值：就是处理完源信号的内容。
        return [NSString stringWithFormat:@"输出: %@", value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
}
/*
 FlatternMap和Map的区别
 
 1.FlatternMap中的Block返回信号。
 2.Map中的Block返回对象。
 3.开发中，如果信号发出的值不是信号，映射一般使用Map
 4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
 总结：signalOfsignals用FlatternMap。
 */

- (void)signalOfSignals {
    // 创建信号中的信号
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [[signalOfSignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        // 当signalOfsignals的signals发出信号才会调用
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        NSLog(@"subscribeNext: %@", x);
    }];
    // 信号的信号发送信号
    [signalOfSignals sendNext:signal];
    // 信号发送内容
    [signal sendNext:@(1)];
}

@end
