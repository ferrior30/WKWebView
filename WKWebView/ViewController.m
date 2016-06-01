//
//  ViewController.m
//  WKWebView
//
//  Created by ChenWei on 16/5/31.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (weak, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIViewController *vc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.suppressesIncrementalRendering = YES;
    WKWebView *wb = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    wb.navigationDelegate = self;
//    wb.UIDelegate = self;
    self.webView = wb;
    [self.view addSubview:wb];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    [wb loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(goToSina:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"gotoSina" forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(0, 100, 50, 50);
    [self.view addSubview:button];
    
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];

}

- (void)back{
   
    
    if (self.webView.backForwardList.backList.count <= 0) {
        NSURL *url = self.webView.backForwardList.backItem.URL;
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }else {
        NSURL *url = self.webView.backForwardList.backItem.URL;
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)goToSina:(UIButton *)btn {
    NSURL *url = [NSURL URLWithString:@"http://www.sina.com.cn/"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark - WKNavigationDelegate
/** ‘导航动作’的策略：允许导航不？ */
/**  对请求体的操作 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    
    if ([navigationAction.request.URL.absoluteString isEqualToString:@"https://www.baidu.com/"]) {
        NSLog(@"%s , URL = %@", __func__, navigationAction.request.URL.absoluteString);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

/** 接收到服务器返回的响应体的操作 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
     NSLog(@"%s = %@", __func__, navigationResponse.response.URL);
    
    if ([navigationResponse.response.URL.host.lowercaseString isEqualToString:@"www.baidu.com"] || [navigationResponse.response.URL.host.lowercaseString isEqualToString:@"www.sina.com.cn"] ||
        [navigationResponse.response.URL.host.lowercaseString isEqualToString:@"sina.cn"]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }else {
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
     NSLog(@"%s", __func__);
}

/** -----------提交导航--------- */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
   NSLog(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __func__);
    
}

/** -----------开始导航--------- */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);

}

/** -----------导航失败--------- */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __func__);
 
}


/** -----------结束导航---------- */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

/** -----------处理中断---------- */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
     NSLog(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
   
    NSLog(@"%s, %@,   %@", __func__, navigation, webView.URL);
}

@end
