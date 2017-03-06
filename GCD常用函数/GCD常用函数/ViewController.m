//
//  ViewController.m
//  GCD常用函数
//
//  Created by 王伟 on 2017/3/6.
//  Copyright © 2017年 王伟. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 栅栏函数
    // [self test1];
    
    //
    // [self test3];
    
    // 延时函数
    // [self test4];
    
}

// 并发队列+异步任务
- (void)test2 {

    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("series", DISPATCH_QUEUE_CONCURRENT);
    
    // 开一个线程，在此线程中同步执行任务
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 在当前线程执行任务
        dispatch_sync(queue, ^{
            NSLog(@"当前线程1：%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"当前线程2：%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"当前线程3：%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"当前线程4：%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"当前线程5：%@",[NSThread currentThread]);
        });
        
    });

}

// 串行队列+同步任务
- (void)test3 {
    
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("series", DISPATCH_QUEUE_SERIAL);
    
    // 开一个线程，在此线程中同步执行任务
    //dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        // 在当前线程执行任务
        dispatch_sync(queue, ^{
            NSLog(@"当前线程1：%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"当前线程2：%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"当前线程3：%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"当前线程4：%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"当前线程5：%@",[NSThread currentThread]);
        });
        
   // });
    
}

// 栅栏函数
- (void)test1 {
    // 创建一个并发队列（不能使用全局并发队列）
    dispatch_queue_t queue = dispatch_queue_create("com.wangwei", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"当前线程1：%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier1线程：%@",[NSThread currentThread]);
    });
    
    
    dispatch_async(queue, ^{
        NSLog(@"当前线程2：%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier2线程：%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"当前线程3：%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"当前线程4：%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"当前线程5：%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"当前线程6：%@",[NSThread currentThread]);
    });dispatch_async(queue, ^{
        NSLog(@"当前线程7：%@",[NSThread currentThread]);
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
