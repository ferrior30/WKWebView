//
//  ViewController.m
//  OC_JS
//
//  Created by ChenWei on 16/6/1.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController.h"
#import "CWWebView.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (weak, nonatomic) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set navigation
    self.navigationItem.title = @"OC_JS";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"前进" style:UIBarButtonItemStylePlain target:self action:@selector(goForward:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    
    // add webView
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:webView];
    self.webView = webView;
    
    // add scriptMessageHandler to webView
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"AppModel"];
    
    // navigationDelegate
    webView.navigationDelegate = self;
    // UIDelegate
    webView.UIDelegate = self;
    
    
    // load html
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.html" ofType:nil];
    NSURL *URL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
    
    // add button to test scriptMessageHandler
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(20, 80, 100, 100);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - navigation button action
- (void)goForward:(UIBarButtonItem *)item {
    NSLog(@"%s", __func__);

    if ([self.webView canGoForward]) {
        [self.webView goForward];
        
        // 判断跳转后canGoForward
        if (self.webView.backForwardList.forwardList.count == 1) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
         self.navigationItem.backBarButtonItem.enabled = YES;
    }else {
       
    }
}

- (void)goBack:(UIBarButtonItem *)item {
    NSLog(@"%s", __func__);
    
    if ([self.webView canGoBack]) {
        
        [self.webView goBack];
    
        // 判断跳转后canGoBack
        if (self.webView.backForwardList.backList.count == 1) {
            self.navigationItem.leftBarButtonItem.enabled = NO;
        }
        self.navigationItem.backBarButtonItem.enabled = YES;
    }
}

/**
 *  texst scriptMessageHandler
 */
- (void)btnClick {
    
    [self.webView evaluateJavaScript:self.webView.configuration.userContentController.userScripts.firstObject.source completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"执行JS后的回调结果：%@", error);
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

#pragma mark - WKUIDelegate
/** 
 这个代理的作用
 1. 处理与弹窗相关的三种界面情况
 2. 创建新的webView（未实现）
 */
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return nil;
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    // OC 弹窗口界面创建
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"js调用OC弹窗视图" message:@"务必谨慎" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"confirm点击后回调");
    }];
    
    [alertVC addAction:confirm];

    [self presentViewController:alertVC animated:YES completion:^{
         NSLog(@"弹窗口显示完成");
    }];
    
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    // OC 弹窗口界面创建
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"js调用OC弹窗视图" message:@"务必谨慎" preferredStyle:UIAlertControllerStyleAlert];
   
    // confirm item
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"confirm点击后回调");
        completionHandler(NO);
    }];
    
    [alertVC addAction:confirm];
    
    // cancel item
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel点击后回调");
        completionHandler(YES);
    }];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:^{
        NSLog(@"弹窗口显示完成");
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler {
    // OC 弹窗口界面创建
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"js调用OC TextField" message:@"务必谨慎" preferredStyle:UIAlertControllerStyleAlert];
   
    // add textField
   __block UITextField *_textfield = nil;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blueColor];
        textField.placeholder = @"请输入:...";
        
        _textfield = textField;
    }];
    
    
    // add confirm item
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"confirm点击后回调");
        
        completionHandler(_textfield.text);
    }];
    
    [alertVC addAction:confirm];
    
    // add cancel item
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel点击后回调");
         completionHandler(_textfield.text = @"cancel");
    }];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:^{
        NSLog(@"弹窗口显示完成");
    }];
    
}


#pragma mark - WKScriptMessageHandler
/**
 *  invokerd when JS send scriptMessage
 *
 *  @param userContentController webView的config里add方法设置的遵守JSMessageHandler协议的对象。
 *  @param message               webView里js传递出来的信息。
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    NSLog(@"didReceiveScriptMessage = %@", message);
    
}


@end
