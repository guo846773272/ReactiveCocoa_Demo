//
//  LoginViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/5.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "LoginViewController.h"

#import "ReactiveObjC.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Login";
    
//    [self login1];
    [self login2];
    
    
}

- (void)login1 {
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.usernameTF.rac_textSignal, self.passwordTF.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        NSLog(@"%@", value);
        return @([value[0] length] > 0 && [value[1] length] > 0);
    }];
    
    
    self.loginBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //return [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@{@"username": self.usernameTF.text, @"password": self.passwordTF.text}];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    [self.loginBtn.rac_command.executionSignals subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"登录获取的信息： %@", x);
        }];
    }];
}

- (void)login2 {
    
    [[RACSignal combineLatest:@[self.usernameTF.rac_textSignal, self.passwordTF.rac_textSignal] reduce:^id _Nullable(NSString *username, NSString *password){
        return @(username.length > 0 && password.length > 0);
    }] subscribeNext:^(id  _Nullable x) {
        self.loginBtn.enabled = [x boolValue];
    }];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@{@"username": self.usernameTF.text, @"password": self.passwordTF.text}];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    
    [[[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        //点击登陆后的操作
        self.loginBtn.enabled = NO;
    }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        //登录信号发出发送这个信号、获取信息
        return signal;
    }] subscribeNext:^(id  _Nullable x) {
        //收到订阅消息回调
        NSLog(@"subscribeNext: %@", x);
        self.loginBtn.enabled = YES;
    }];
}

- (IBAction)loginClick:(id)sender {
    
}




@end
