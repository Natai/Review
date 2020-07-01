//
//  MRCController.m
//
//  Created by natai on 2020/6/24.
//  
//  Copyright © 2020 bibr. All rights reserved.
//
    

#import "MRCController.h"

@interface MRCController ()

@property (weak, nonatomic) NSObject *manualObj;
@property (weak, nonatomic) NSMutableArray *manualArr;
@property (weak, nonatomic) NSObject *autoObj;
@property (weak, nonatomic) NSMutableArray *autoArr;

@end

@implementation MRCController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 使用了alloc分配了内存，manualObj指向了对象，该对象本身引用计数为1，不需要retain
    NSObject *manualObj = [[NSObject alloc] init];
    self.manualObj = manualObj;
    [manualObj release];
    
    // 使用了new分配了内存，manualObj指向了对象，该对象本身引用计数为1，不需要retain
    NSMutableArray *manualArr = [NSMutableArray new];
    self.manualArr = manualArr;
    [manualArr release];
    
    // 手动加入autoreleasepool管理
    NSObject *autoObj = [[NSObject alloc] init];
    self.autoObj = autoObj;
    [autoObj autorelease];
    
    /*
     NSMutableArray通过类方法array产生了对象(并没有使用alloc、new、copy、mutableCopy来产生对象)
     因此该对象不属于autoArr自身产生的，由autoreleasepool管理
    */
    NSMutableArray *autoArr = [NSMutableArray array];
    self.autoArr = autoArr;
    
    NSLog(@"=====viewDidLoad=====");
    NSLog(@"manualObj:%@", self.manualObj);
    NSLog(@"manualArr:%@", self.manualArr);
    NSLog(@"autoObj:%@", self.autoObj);
    NSLog(@"autoArr:%@", self.autoArr);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"=====viewWillAppear=====");
    NSLog(@"manualObj:%@", self.manualObj);
    NSLog(@"manualArr:%@", self.manualArr);
    NSLog(@"autoObj:%@", self.autoObj);
    NSLog(@"autoArr:%@", self.autoArr);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"=====viewDidAppear=====");
    NSLog(@"manualObj:%@", self.manualObj);
    NSLog(@"manualArr:%@", self.manualArr);
    NSLog(@"autoObj:%@", self.autoObj);
    NSLog(@"autoArr:%@", self.autoArr);
}

@end
