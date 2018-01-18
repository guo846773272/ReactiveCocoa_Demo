//
//  DeliverOn_SubscribeOnViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/11.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "DeliverOn_SubscribeOnViewController.h"

#import "ReactiveObjC.h"

@interface DeliverOn_SubscribeOnViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation DeliverOn_SubscribeOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DeliverOn_SubscribeOn";
    
//    deliverOn: 内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用。deliverOn:[RACScheduler mainThreadScheduler]]
//    subscribeOn: 内容传递和副作用都会切换到制定线程中。
}

- (void)deliverOn {
    //在subscribeNext:error：中的数据没有在主线程(Thread 1)中执行，更新UI只能在主线程中执行，所以更新UI需要转到主线程中执行。
    //要怎么更新UI呢？
    //通常的做法是使用操作队列但是ReactiveCocoa有更简单的解决办法，在flattenMap：之后添加一个deliverOn：操作就可以转到主线程上了。
    //注：如果你看一下RACScheduler类，就能发现还有很多选项，比如不同的线程优先级，或者在管道中添加延迟。
    @weakify(self)
    [[[[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@{@"key": @"value"}];
            [subscriber sendCompleted];
        });
        return nil;
    }] then:^RACSignal * _Nonnull{
        @strongify(self)
        return self.textField.rac_textSignal;
    }] filter:^BOOL(id  _Nullable value) {
        return YES;
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACSignal empty];
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
}

//异步加载图片
- (RACSignal *)signalForLoadingImage:(NSString *)imageUrl {
    RACScheduler *scheduler = [RACScheduler
                               schedulerWithPriority:RACSchedulerPriorityBackground];
    
    return [[RACSignal createSignal:^RACDisposable *(id subscriber) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        return nil;
    }] subscribeOn:scheduler];
}

-(UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    cell是重用的，可能有脏数据，所以上面的代码首先重置图片。然后创建signal来获取图片数据。你之前也遇到过deliverOn：这一步，它会把next事件发送到主线程，这样subscribeNext：block就能安全执行了。
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
//    takeUntil:当给定的signal完成前一直取值
//    cell.rac_prepareForReuseSignal：Cell复用时的清理。
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext: [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"imageUrlString"]]]];
            [subscriber sendCompleted];
        });
        
        return nil;
    }] takeUntil:cell.rac_prepareForReuseSignal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        cell.imageView.image = x;
    }];

    return cell;
}





@end
