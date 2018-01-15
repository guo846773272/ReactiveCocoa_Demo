//
//  RGBSlidersViewController.m
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/5.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import "RGBSlidersViewController.h"

#import "ReactiveObjC.h"

@interface RGBSlidersViewController ()

@property (weak, nonatomic) IBOutlet UITextField *bindTextField;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *redTF;
@property (weak, nonatomic) IBOutlet UITextField *greenTF;
@property (weak, nonatomic) IBOutlet UITextField *blueTF;
@property (weak, nonatomic) IBOutlet UIView *showView;

@end

@implementation RGBSlidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"RGBSliders";
    
    
}

- (void)bind {
    
    
}

- (void)bindRGB {
    
    self.redTF.text = self.greenTF.text = self.blueTF.text = @"0.5";
    
    RACSignal *redSignal = [self blindSlider:self.redSlider textField:self.redTF];
    RACSignal *greenSignal = [self blindSlider:self.greenSlider textField:self.greenTF];
    RACSignal *blueSignal = [self blindSlider:self.blueSlider textField:self.blueTF];
    
    //1、订阅方法
    //    [[[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
    //        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
    //    }] subscribeNext:^(id  _Nullable x) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.showView.backgroundColor = x;
    //        });
    //    }];
    //2、绑定方法
    RACSignal *changeValueSignal = [[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
    }];
    RAC(self.showView, backgroundColor) = changeValueSignal;
}

- (RACSignal *)blindSlider:(UISlider *)slider textField:(UITextField *)textField {
    
    RACSignal *textSignal = [[textField rac_textSignal] take:1];
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    [signalText subscribe:signalSlider];
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f", [value floatValue]];
    }] subscribe:signalText];
    return  [[signalText merge:signalSlider] merge:textSignal];
}


@end
