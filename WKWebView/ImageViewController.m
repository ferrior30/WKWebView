//
//  ImageViewController.m
//  WKWebView
//
//  Created by ChenWei on 16/6/1.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ImageViewController.h"
#import <WebKit/WebKit.h>

@interface ImageViewController ()<WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler>

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=375;};window.alert('找到' + count + '张图');";
    
//    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    [config.userContentController addUserScript:script];
    [config.userContentController addScriptMessageHandler:self name:@"gogo"];
    
    WKWebView *wb = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    wb.UIDelegate = self;
    wb.navigationDelegate = self;
    
    [self.view addSubview:wb];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test1.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [wb loadFileURL:url allowingReadAccessToURL:url] ;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    completionHandler();
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"message = %@", message);
}


@end
