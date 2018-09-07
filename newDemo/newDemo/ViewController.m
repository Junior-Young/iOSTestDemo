//
//  ViewController.m
//  newDemo
//
//  Created by 杨俊杰 on 2018/7/26.
//  Copyright © 2018年 杨俊杰. All rights reserved.
//

#import "ViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "newDemo-Swift.h"
@interface ViewController ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@property (nonatomic, strong) UIView *newView;

@property (nonatomic, strong) dispatch_queue_t serialQueue;//串行队列

@property (nonatomic, strong) dispatch_queue_t concurrentQueue;//并发队列

//异步下载两张图，然后拼接成一张
@property (nonatomic, strong) UIImage *imageOne;
@property (nonatomic, strong) UIImage *imageTwo;
@property (nonatomic, strong) UILabel *textLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主页";
    //[self.view addSubview:self.newView];
    //[self.view addSubnode:self.tableNode];
    //[self gcdOnceTest];
    //[self gcdGroupTest];
    //[self operation1];
    [self setupRightNavigationItem];
    [self setupViews];
}

#pragma mark -pingfang
- (void)setupViews {
    UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 300, 30)];
    textLable.text = @"这是字体验证:systemFont";
    textLable.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:textLable];
    
    UILabel *textLable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 300, 30)];
    textLable1.text = @"这是字体验证:PingFangSC-Regular";
    textLable1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
    [self.view addSubview:textLable1];
}

#pragma mark -swift
- (void)setupRightNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Swift" style:(UIBarButtonItemStyleDone) target:self action:@selector(gotoSwiftVC)];
}

- (void)gotoSwiftVC {
    testSwiftViewController *swiftVC = [[testSwiftViewController alloc] init];
    [self.navigationController pushViewController:swiftVC animated:YES];
}


#pragma mark - GCD
- (void)gcdTest {
    //最常用的
    dispatch_queue_t queue = dispatch_queue_create("aa", DISPATCH_QUEUE_CONCURRENT) ;
    //耗时操作
    
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI
            
        });
    });
    
    
}

#pragma mark -----队列
- (void)gcdOnceTest {
    self.serialQueue = dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL);//串行队列
    self.concurrentQueue = dispatch_queue_create("bbb", DISPATCH_QUEUE_CONCURRENT);//并发队列
    for (int i = 0; i < 100; i++) {
        [self concurrentPrintNumber:i];
    }
}

//异步串行队列
- (void)serialPrintNumber:(int)number {
    dispatch_async(self.serialQueue, ^{
        NSLog(@"%d,  %@", number, [NSThread currentThread]);
    });
}

//异步并发队列
- (void)concurrentPrintNumber:(int)number {
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"%d,  %@", number, [NSThread currentThread]);
    });
}

#pragma mark -----group
//多个任务处理完之后执行结束处理
- (void)gcdGroupTest {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 1000; i++) {
            if (i == 999) {
                NSLog(@"1111111");
            }
        }
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"22222222");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"33333333");
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done");
    });
    //无论向什么样的Dispatch Queue中追加处理，使用Dispatch Group都可以监视这些处理执行的结果。一旦检测到所有处理执行结束，就可以将结束的处理追加到Dispatch Queue中，这就是使用Dispatch Group的原因。
}

- (void)operation1
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 450, 0, 0)];
    textLabel.text = @"正在下载图片";
    [textLabel sizeToFit];
    [self.view addSubview:textLabel];
    self.textLabel = textLabel;
    [self group];
    NSLog(@"在下载图片的时候，主线程貌似还可以干点什么");
}

- (void)group
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("12333", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"正在下载第一张图片");
        sleep(3);
        self.imageOne = [UIImage imageNamed:@"timg.jpg"];
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"正在下载第二张图片");
        sleep(2);
        self.imageTwo = [UIImage imageNamed:@"timg.jpg"];
    });
    
    dispatch_group_notify(group, queue, ^{
        [self.imageOne drawInRect:CGRectMake(0, 0, 150, 400)];
        [self.imageOne drawInRect:CGRectMake(150, 0, 150, 400)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [self.view addSubview:imageView];
            self.textLabel.text = @"图片合并完毕";
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        UIGraphicsBeginImageContext(CGSizeMake(300, 400));
        
        [self.imageOne drawInRect:CGRectMake(0, 0, 150, 400)];
        [self.imageTwo drawInRect:CGRectMake(150, 0, 150, 400)];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
            [self.view addSubview:imageView];
            self.textLabel.text = @"图片合并完毕";
        });
    });
}

#pragma mark -----barrier


//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    self.tableNode.frame = self.view.bounds;
//}

- (UIView *)newView {
    if (_newView == nil) {
        _newView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        _newView.backgroundColor = [UIColor redColor];
    }
    return _newView;
}


- (ASTableNode *)tableNode {
    if (_tableNode == nil) {
        _tableNode = [[ASTableNode alloc] initWithStyle:(UITableViewStylePlain)];
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        _tableNode.backgroundColor = [UIColor whiteColor];
    }
    return _tableNode;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 10;
}


-(ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ^{
        ASCellNode *cellNode = [[ASCellNode alloc] init];
        return cellNode;
    };
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
