//
//  CreateSignalViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/6.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "CreateSignalViewController.h"

#import "ReactiveObjC.h"
#import "AFNetworking.h"

@interface CreateSignalViewController ()

@end

@implementation CreateSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CreateSignal";
    
//    [self single];
//    [self multi];
    [self liftSelector];
    
}

- (void)single {
    
    [[self signalFromJson:@"https://api.douban.com/v2/book/1220562"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"completed");
    }];
}

- (void)multi {
    
    RACSignal *s0 = [self signalFromJson:@"https://api.douban.com/v2/book/1220562"];
    RACSignal *s1 = [self signalFromJson:@"https://api.douban.com/v2/movie/subject/1764796"];
    RACSignal *s2 = [self signalFromJson:@"https://api.douban.com/v2/music/3002323"];
    
    //
//    [[[s0 merge:s1] merge:s2] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"%@", error);
//    } completed:^{
//        NSLog(@"completed");
//    }];
    
    //串行（只返回最后一个signal数据）
//    [[[s0 then:^RACSignal * _Nonnull{
//        return s1;
//    }] then:^RACSignal * _Nonnull{
//        return s2;
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"%@", error);
//    } completed:^{
//        NSLog(@"completed");
//    }];
    //串行（返回所有signal数据）
//    [[[s0 concat:s1] concat:s2] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"%@", error);
//    } completed:^{
//        NSLog(@"completed");
//    }];
    
    //并行（全部执行完才订阅到信号）
    [[RACSignal combineLatest:@[s0, s1, s2]] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"completed");
    }];
    
//    [self rac_liftSelector:@selector(updateUIWithBook:movie:music:) withSignalsFromArray:@[s0, s1, s2]];
    
}

- (RACSignal *)signalFromJson:(NSString *)urlString {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", @"text/plain", nil];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;//不验证证书的域名
        manager.securityPolicy = securityPolicy;
        [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

- (void)liftSelector {
    // 创建热门商品的信号
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 处理信号
        NSLog(@"请求热门商品");
        
        // 发送数据
        [subscriber sendNext:@"热门商品"];
        
        return nil;
    }];
    
    // 创建热门商品的信号
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 处理信号
        NSLog(@"请求最新商品");
        
        // 发送数据
        [subscriber sendNext:@"最新商品"];
        
        return nil;
    }];
    
    // RAC:就可以判断两个信号有没有都发出内容
    // SignalsFromArray:监听哪些信号的发出
    // 当signals数组中的所有信号都发送sendNext就会触发方法调用者(self)的selector
    // 注意:selector方法的参数不能乱写,有几个信号就对应几个参数
    // 不需要主动订阅signalA,signalB,方法内部会自动订阅
    [self rac_liftSelector:@selector(updateUIWithHot:new:) withSignalsFromArray:@[signalA,signalB]];
}

// 更新UI
- (void)updateUIWithHot:(NSString *)hot new:(NSString *)new
{
    NSLog(@"更新UI");
    
}

- (void)updateUIWithBook:(NSString *)book movie:(NSString *)movie music:(NSString *)music
{
    NSLog(@"更新UI");
    
}




@end
