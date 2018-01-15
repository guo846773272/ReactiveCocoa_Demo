//
//  DoNext_DoCompletedViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/11.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "DoNext_DoCompletedViewController.h"

#import "ReactiveObjC.h"

@interface DoNext_DoCompletedViewController ()

@end

@implementation DoNext_DoCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DoNext_DoCompleted";
    
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id  _Nullable x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext: %@", x);
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext: %@", x);
    }];
    
}



@end
