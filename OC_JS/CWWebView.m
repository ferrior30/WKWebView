//
//  CWWebView.m
//  WKWebView
//
//  Created by ChenWei on 16/6/1.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWWebView.h"

@implementation CWWebView

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@", message);
}

@end
