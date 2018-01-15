//
//  MVVMViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/12.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "MVVMViewController.h"

#import "MVVMViewModel.h"
#import "MVVMModel.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface MVVMViewController ()

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) NSMutableArray *movies;

@property (nonatomic, strong) MVVMViewModel *viewModel;

@end

@implementation MVVMViewController

//- (NSMutableArray *)movies {
//    if (_movies == nil) {
//        _movies = [NSMutableArray array];
//    }
//    return _movies;
//}

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGFloat topSafeMargin = SCREEN_SIZE.height == 812.0 ? 88 : 64;
        CGFloat bottomSafeMargin = SCREEN_SIZE.height == 812.0 ? 34 : 0;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topSafeMargin, SCREEN_SIZE.width, SCREEN_SIZE.height - topSafeMargin - bottomSafeMargin)];
//        tableView.dataSource = self;
//        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        _tableView = tableView;
    }
    return _tableView;
}

- (MVVMViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[MVVMViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MVVM";
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.viewModel;
    
    [[self.viewModel.requestCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"execute： %@", x);
        self.viewModel.movies = x;
        [self.tableView reloadData];
    }];
}

- (void)dealloc {
    NSLog(@"dealloc-------dealloc");
}




@end
