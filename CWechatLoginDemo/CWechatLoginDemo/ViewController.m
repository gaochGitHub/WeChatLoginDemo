//
//  ViewController.m
//  CWechatLoginDemo
//
//  Created by 高超 on 2016/11/18.
//  Copyright © 2016年 ChaoGao. All rights reserved.
//

#import "ViewController.h"
#import "QWeChatLoginSuccess.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 50);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"WeChatLogin" forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:@selector(weChatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)weChatButtonClicked:(id)sender {
    [QWeChatLoginSuccess loginOnViewController:self success:^{
        
    } failed:^(NSString *err) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
