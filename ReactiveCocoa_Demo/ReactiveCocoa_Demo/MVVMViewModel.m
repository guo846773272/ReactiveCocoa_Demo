//
//  MVVMViewModel.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/12.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "MVVMViewModel.h"

#import <AFNetworking/AFNetworking.h>
#import "MJExtension.h"

#import "MVVMModel.h"

@interface MVVMViewModel ()<UITableViewDataSource>

@end

@implementation MVVMViewModel

- (NSMutableArray *)movies {
    if (_movies == nil) {
        _movies = [NSMutableArray array];
    }
    return _movies;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

//- (void)initialBind {
//    self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//            parameters[@"q"] = @"变形金刚";
//            [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/movie/search" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"responseObject: %@", responseObject);
//                NSArray *subjects = responseObject[@"subjects"];
//                NSArray *movies = [MVVMModel mj_objectArrayWithKeyValuesArray:subjects];
//                [subscriber sendNext:movies];
//                [subscriber sendCompleted];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"error: %@", error);
//                [subscriber sendError:error];
//            }];
//            return nil;
//        }];
//    }];
//}

- (void)initialBind {
    
    self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"q"] = @"变形金刚";
            [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/movie/search" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject: %@", responseObject);
                NSArray *subjects = responseObject[@"subjects"];
                NSArray *movies = [MVVMModel mj_objectArrayWithKeyValuesArray:subjects];
                [subscriber sendNext:movies];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error: %@", error);
                [subscriber sendError:error];
            }];
            return nil;
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    MVVMModel *model = self.movies[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

@end
