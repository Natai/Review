//
//  ARCController.m
//
//  Created by natai on 2020/6/24.
//  
//  Copyright © 2020 bibr. All rights reserved.
//
    

#import "ARCController.h"

@interface ARCController ()

@property (weak, nonatomic) NSMutableArray *normalArr;
@property (weak, nonatomic) NSMutableArray *factoryArr;

@end

@implementation ARCController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 下面两个对象都是在viewDidLoad结束后马上释放
    
    // 这里是不进入autorelease的，new创建的对象自己持有，编译器帮忙直接release掉
    NSMutableArray *normalArr = [NSMutableArray new];
    self.normalArr = normalArr;
    
    // arc下，工厂方法创建的对象会被TLS优化掉，也不会进入autorelease
    NSMutableArray *factoryArr = [NSMutableArray array];
    self.factoryArr = factoryArr;
    
    NSLog(@"=====viewDidLoad=====");
    NSLog(@"normalArr:%@", self.normalArr);
    NSLog(@"factoryArr:%@", self.factoryArr);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"=====viewWillAppear=====");
    NSLog(@"normalArr:%@", self.normalArr);
    NSLog(@"factoryArr:%@", self.factoryArr);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"=====viewDidAppear=====");
    NSLog(@"normalArr:%@", self.normalArr);
    NSLog(@"factoryArr:%@", self.factoryArr);
}

@end
