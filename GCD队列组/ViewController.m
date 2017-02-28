//
//  ViewController.m
//  GCD队列组
//
//  Created by 王伟 on 2017/2/28.
//  Copyright © 2017年 王伟. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"

typedef void(^myBlock)(NSDictionary *dic);

@interface ViewController () {
    dispatch_group_t _group;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 队列组和信号量
    [self test1];
    
    // GCD中提供了函数, 可以指定操作的执行顺序
    //[self test2];
}

//
- (void)test2 {
    
    /*
     如果我们要指定网络操作的执行顺序的话, 直接使用GCD中的队列, 然后添加依赖即可
     */
    
    //1.任务一：
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        
        // 请求1
        NSString *str1 = @"http://sonydata.csmc-cloud.com/layout/kv/v2/kv.json";
        [self getMessageWithURLString:str1 messageBlock:^(NSDictionary *dic) {
            NSLog(@"完成1");
        }];
    }];
    
    //2.任务二：
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        
        // 请求2
        NSString *str2 = @"http://sonydata.csmc-cloud.com/layout/menu/v2/menu_body.json";
        [self getMessageWithURLString:str2 messageBlock:^(NSDictionary *dic) {
            NSLog(@"完成2");
        }];
    }];
    
    //3.任务三：
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        
        // 请求3
        NSString *str3 = @"http://sonydata.csmc-cloud.com/layout/news/v1/news_body.json";
        [self getMessageWithURLString:str3 messageBlock:^(NSDictionary *dic) {
            NSLog(@"完成3");
        }];
    }];
    
    //4.任务四：
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        
        // 请求4
        NSString *str4 = @"http://sonydata.csmc-cloud.com/layout/new_product/v1/new_product_head.json";
        [self getMessageWithURLString:str4 messageBlock:^(NSDictionary *dic) {
            NSLog(@"完成4");
        }];
    }];
    
    //5.任务五：
    NSBlockOperation *operation5 = [NSBlockOperation blockOperationWithBlock:^{
        
        // 请求5
        NSString *str5 = @"http://sonydata.csmc-cloud.com/layout/new_product/v1/new_product_body.json";
        [self getMessageWithURLString:str5 messageBlock:^(NSDictionary *dic) {
            NSLog(@"完成5");
        }];
    }];
    
    //4.设置依赖
    [operation1 addDependency:operation2];      //任务一依赖任务二
    [operation3 addDependency:operation1];      //任务三依赖任务一
    [operation4 addDependency:operation3];      //任务四依赖任务三
    [operation5 addDependency:operation4];      //任务五依赖任务四
    
    //5.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation1, operation2, operation3, operation4, operation5] waitUntilFinished:NO];
    
}

// 队列组和信号量
- (void)test1 {
    /*
     1. 在队列组中进行多个网络请求
     2. 在全部的网络请求完成之后再进行UI刷新
     3. 其队列请求是随机的
     */
    
    // URL
    NSString *str1 = @"http://sonydata.csmc-cloud.com/layout/kv/v2/kv.json";
    NSString *str2 = @"http://sonydata.csmc-cloud.com/layout/menu/v2/menu_body.json";
    NSString *str3 = @"http://sonydata.csmc-cloud.com/layout/news/v1/news_body.json";
    NSString *str4 = @"http://sonydata.csmc-cloud.com/layout/new_product/v1/new_product_head.json";
    NSString *str5 = @"http://sonydata.csmc-cloud.com/layout/new_product/v1/new_product_body.json";
    
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    _group = group;
    
    
    // 创建队列组的block操作
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"子线程上的第1个请求");
        // 网络请求1
        [self getMessageWithURLString:str1 messageBlock:^(NSDictionary *dic) {
            
            NSLog(@"完成1");
        }];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"子线程上的第2个请求");
        // 网络请求2
        [self getMessageWithURLString:str2 messageBlock:^(NSDictionary *dic) {
            
            NSLog(@"完成2");
        }];
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"子线程上的第3个请求");
        // 网络请求3
        [self getMessageWithURLString:str3 messageBlock:^(NSDictionary *dic) {
            
            NSLog(@"完成3");
        }];
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"子线程上的第4个请求");
        // 网络请求4
        [self getMessageWithURLString:str4 messageBlock:^(NSDictionary *dic) {
            
            NSLog(@"完成4");
        }];
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"子线程上的第5个请求");
        // 网络请求5
        [self getMessageWithURLString:str5 messageBlock:^(NSDictionary *dic) {
            
            NSLog(@"完成5");
        }];
        
    });
    
    // 这五个请求都完成之后，执行完成后的通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // 返回主线程刷新UI
        NSLog(@"完成请求后，刷新UI");
    });
    

}

- (void)getMessageWithURLString:(NSString *)string messageBlock:(myBlock)messageBlock {
    
    //创建信号量并设置计数默认为0
    // dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    /// 请求管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", @"text/html" , nil];
    
    [manager GET:string parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //计数+1操作
        // dispatch_semaphore_signal(sema);
        dispatch_group_leave(_group);
        messageBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //计数+1操作
        // dispatch_semaphore_signal(sema);
        dispatch_group_leave(_group);
        messageBlock(nil);
    }];

    //若计数为0则一直等待
    // dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_group_enter(_group);
    
    
}


@end
