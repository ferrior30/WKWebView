//
//  SinaViewController.m
//  WKWebView
//
//  Created by ChenWei on 16/6/1.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "SinaViewController.h"
#import <WebKit/WebKit.h>

@interface SinaViewController ()
@property (weak, nonatomic) WKWebView *webView;
@end

@implementation SinaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *wb = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:wb];
    
    NSURL *URL = [NSURL URLWithString:@"http://www.sina.com.cn"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [wb loadRequest:request];
}

@end
