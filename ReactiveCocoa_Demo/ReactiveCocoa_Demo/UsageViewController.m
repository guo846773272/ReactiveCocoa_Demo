//
//  UsageViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/10.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "UsageViewController.h"

#import "ReactiveObjC.h"

#import "RedView.h"

@interface UsageViewController ()

@property (strong, nonatomic) RedView *redView;

@property (nonatomic, assign) int age;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation UsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Usage";
    
    
//    [self delegate];
//    [self KVO];
//    [self event];
    [self notification];
}

- (void)setupRedView {
    RedView *redView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RedView class]) owner:nil options:nil][0];
    redView.center = self.view.center;
    redView.bounds = CGRectMake(0, 0, 200, 100);
    [self.view addSubview:redView];
    self.redView = redView;
}

- (void)delegate {
    [self setupRedView];
    // 1.RAC替换代理
    // RAC:判断下一个方法有没有调用,如果调用了就会自动发送一个信号给你
    
    // 只要self调用viewDidLoad就会转换成一个信号
    // 监听_redView有没有调用btnClick:,如果调用了就会转换成信号
    [[self.redView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"控制器知道,点击了红色的view");
    }];
}

- (void)KVO {
    
    // 2.KVO
    // 监听哪个对象的属性改变
    // 方法调用者:就是被监听的对象
    // KeyPath:监听的属性
    
    // 把监听到内容转换成信号
    [[self rac_valuesForKeyPath:@"age" observer:nil] subscribeNext:^(id  _Nullable x) {
        // block:只要属性改变就会调用,并且把改变的值传递给你
        NSLog(@"%@",x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.age ++;
}

- (void)event {
    // 3.监听事件
    // 只要产生UIControlEventTouchUpInside就会转换成信号
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了按钮");
    }];
}

- (void)notification {
//    RAC中的通知不需要remove observer,因为在rac_add方法中他已经写了remove
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidChangeFrameNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"键盘");
    }];
}

- (void)textChange {
    // 5.监听文本框文字改变
    // 获取文本框文字改变的信号
    [_textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

@end
