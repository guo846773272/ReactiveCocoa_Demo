//
//  ViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/5.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "ViewController.h"

#import "LoginViewController.h"
#import "RGBSlidersViewController.h"
#import "CreateSignalViewController.h"
#import "SideEffectsViewController.h"
#import "ReplaySubjectViewController.h"
#import "SequenceViewController.h"
#import "CommandViewController.h"
#import "MacroViewController.h"
#import "UsageViewController.h"
#import "MapFlattern_MapViewController.h"
#import "Concat_Then_Merge_Zip_CombineLatest_ReduceViewControllerViewController.h"
#import "Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatestViewController.h"
#import "DoNext_DoCompletedViewController.h"
#import "DeliverOn_SubscribeOnViewController.h"
#import "Timeout_Interval_DelayViewController.h"
#import "Retry_ThrottleViewController.h"
#import "MVVMViewController.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

static NSString *cellID = @"cellID";

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGFloat topSafeMargin = SCREEN_SIZE.height == 812.0 ? 88 : 64;
        CGFloat bottomSafeMargin = SCREEN_SIZE.height == 812.0 ? 34 : 0;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topSafeMargin, SCREEN_SIZE.width, SCREEN_SIZE.height - topSafeMargin - bottomSafeMargin)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        _tableView = tableView;
    }
    return _tableView;
}

- (NSArray *)titles {
    if (_titles == nil) {
        _titles = @[
                    @"Login",
                    @"RGBSliders",
                    @"CreateSignal",
                    @"SideEffects",
                    @"ReplaySubject",
                    @"Sequence",
                    @"Command",
                    @"Macro",
                    @"Usage",
                    @"MapFlattern_Map",
                    @"Concat_Then_Merge_Zip_CombineLatest_Reduce",
                    @"Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatest",
                    @"DoNext_DoCompleted",
                    @"DeliverOn_SubscribeOn",
                    @"Timeout_Interval_Delay",
                    @"Retry_Throttle",
                    @"MVVM"
                    ];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.titles[indexPath.row];
    if ([title isEqualToString:@"Login"]) {
        [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"RGBSliders"]) {
        [self.navigationController pushViewController:[[RGBSlidersViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"CreateSignal"]) {
        [self.navigationController pushViewController:[[CreateSignalViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"SideEffects"]) {
        [self.navigationController pushViewController:[[SideEffectsViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"ReplaySubject"]) {
        [self.navigationController pushViewController:[[ReplaySubjectViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"Sequence"]) {
        [self.navigationController pushViewController:[[SequenceViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"Command"]) {
        [self.navigationController pushViewController:[[CommandViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"Macro"]) {
        [self.navigationController pushViewController:[[MacroViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"Usage"]) {
        [self.navigationController pushViewController:[[UsageViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"MapFlattern_Map"]) {
        [self.navigationController pushViewController:[[MapFlattern_MapViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"Concat_Then_Merge_Zip_CombineLatest_Reduce"]) {
        [self.navigationController pushViewController:[[Concat_Then_Merge_Zip_CombineLatest_ReduceViewControllerViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatest"]) {
        [self.navigationController pushViewController:[[Filter_Ignore_DistinctUntilChanged_Take_TakeLast_TakeUntil_Skip_SwitchToLatestViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"DoNext_DoCompleted"]) {
        [self.navigationController pushViewController:[[DoNext_DoCompletedViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"DeliverOn_SubscribeOn"]) {
        [self.navigationController pushViewController:[[DeliverOn_SubscribeOnViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"Timeout_Interval_Delay"]) {
        [self.navigationController pushViewController:[[Timeout_Interval_DelayViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"Retry_Throttle"]) {
        [self.navigationController pushViewController:[[Retry_ThrottleViewController alloc] init] animated:YES];
    } else if ([title isEqualToString:@"MVVM"]) {
        [self.navigationController pushViewController:[[MVVMViewController alloc] init] animated:YES];
    }
    
}



@end
