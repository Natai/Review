//
//  PoolController.m
//
//  Created by natai on 2020/6/28.
//  
//  Copyright © 2020 bibr. All rights reserved.
//
    

#import "PoolController.h"

@interface PoolController ()

@end

@implementation PoolController

- (IBAction)withPool:(id)sender {
    // allocations中显示五个小三角
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            for (int j = 0; j < 50; j++) {
                NSString *path = [NSBundle.mainBundle pathForResource:@"test" ofType:@"jpg"];
                UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
            }
        }
    }
}

- (IBAction)withoutPool:(id)sender {
    // allocations中显示一个大三角
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 50; j++) {
            NSString *path = [NSBundle.mainBundle pathForResource:@"test" ofType:@"jpg"];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        }
    }
}

@end
