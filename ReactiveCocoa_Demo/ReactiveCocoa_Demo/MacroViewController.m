//
//  MacroViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/10.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "MacroViewController.h"

#import "ReactiveObjC.h"

@interface MacroViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) RACSignal *signal;
@end

@implementation MacroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Macro";
    
//    [self macroRAC];
//    [self macroRACObserve];
    [self macroWeakifyStrongify];
//    [self macroRACTupleUnpack];
}
/*




RACChannelTo(TARGET, ...)
RACChannelTo 用于双向绑定
RACChannelTo(self, stringProperty)=RACChannelTo(self.label, text) ;
*/
- (void)macroRAC {
    
//    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        _label.text = x;
//    }];
    
    // RAC:把一个对象的某个属性绑定一个信号,只要发出信号,就会把信号的内容给对象的属性赋值
    // 给label的text属性绑定了文本框改变的信号
//    RAC(TARGET, ...)
//    表现形式:RAC(self, stringProperty) = TextField.rac_textSignal
//    第一个是需要设置属性值的对象，第二个是属性名
//    RAC宏允许直接把信号的输出应用到对象的属性上
//    每次信号产生一个next事件，传递过来的值都会应用到该属性上
    RAC(self.label, text) = _textField.rac_textSignal;
}

- (void)macroRACObserve {
    // KVO
    // RACObserveL:快速的监听某个对象的某个属性改变
    // 返回的是一个信号,对象的某个属性改变的信号
//    RACObserve(TARGET, KEYPATH)
//    表现形式:RACObserve(self, stringProperty)
//    KVO的简化版本 相当于对TARGET中KEYPATH的值设置监听，返回一个RACSignal
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [RACObserve(self, point) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];//获取一个触摸对象
    self.point = [touch locationInView:self.view];//当前点
}

- (void)macroWeakifyStrongify {
    @weakify(self)
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSLog(@"%@", self.view);
        return nil;
    }];
    _signal = signal;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)macroRACTupleUnpack {
    // 4.元祖
    // 快速包装一个元组
    // 把包装的类型放在宏的参数里面,就会自动包装
    RACTuple *tuple = RACTuplePack(@1, @3);
    
    //NSLog(@"%@",tuple);
    
    // 快速的解析一个元组对象
    // 等会的右边表示解析哪个元组
    // 宏的参数:表示解析成什么
    RACTupleUnpack_(NSNumber *num1, NSNumber *num2) = tuple;
    NSLog(@"%@ %@", num1, num2);
}




@end
