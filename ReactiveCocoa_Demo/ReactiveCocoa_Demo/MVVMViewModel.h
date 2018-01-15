//
//  MVVMViewModel.h
//  ReactiveCocoa_Demo
//
//  Created by GMY on 2018/1/12.
//  Copyright © 2018年 gmy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveObjC.h"

@interface MVVMViewModel : NSObject

@property (nonatomic, strong) RACCommand *requestCommand;

@property (nonatomic, strong) NSMutableArray *movies;

@end
