//
//  SequenceViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/8.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "SequenceViewController.h"

#import "ReactiveObjC.h"

@interface SequenceViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sequence";
    
//    [self arrAndDictBaseUse];
    [self dictConverModel];
}

- (void)arrAndDictBaseUse {
    NSArray *arr = @[@1, @2, @3];
    // 1.把数组转换成RAC中集合类RACSequence
    // 2.把RACSequence转换成信号
    // 3.订阅信号，订阅的信号是集合，就会遍历集合，把集合的数据全部发送出来
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    NSDictionary *dict = @{@"key": @1, @"key1": @2};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
//        NSLog(@"%@", x);

//        NSString *key = x[0];
//        NSString *value = x[1];

//         RACTupleUnpack宏：专门用来解析元组
//         RACTupleUnpack 等会右边：需要解析的元组 宏的参数，填解析的什么样数据
//         元组里面有几个值，宏的参数就必须填几个
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@ %@", key, value);
    }];
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






@end
