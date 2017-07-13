//
//  BaseWebViewController.m
//  yangsheng
//
//  Created by jam on 17/7/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "BaseWebViewController.h"
#import "ZZUrlTool.h"

@interface BaseWebViewController ()<UIWebViewDelegate>
{
    UIWebView* webv;
}
@end

@implementation BaseWebViewController

-(instancetype)initWithUrl:(NSURL *)url
{
    self=[super init];
    _url=url;
    return self;
}

-(instancetype)initWithHtml:(NSString *)html
{
    self=[super init];
    _html=html;
    return self;
}

-(void)loadWithCustomUrl:(NSURL *)url complete:(void (^)())completeblock
{
    [ZZHttpTool get:url.absoluteString params:nil usingCache:YES success:^(NSDictionary * res) {
        NSDictionary* data=[res valueForKey:@"data"];
        
        NSString* title=[data valueForKey:@"post_title"];
        NSString* content=[data valueForKey:@"post_content"];
        
        self.url=url;
        self.html=content;
        
        [self.webView loadHTMLString:content baseURL:url];
        
        self.title=title;
        if (completeblock) {
            completeblock();
        }
    } failure:^(NSError * err) {
        
    }];
}

-(UIWebView*)webView
{
    if (!webv) {
        webv=[[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:webv];
    }
    return webv;
}

-(void)setHtml:(NSString *)html
{
    _html=html;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webv=[[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webv];
    
    webv.delegate=self;
    webv.scalesPageToFit=YES;
    
    if(self.html.length>0)
    {
        [webv loadHTMLString:self.html baseURL:self.url];
    }
    else if (self.url) {
        NSString* abs=[self.url absoluteString];
        if (![abs containsString:@"?"]) {
            abs=[NSString stringWithFormat:@"%@?id=%d",abs,(int)self.idd];
        }
        if (![abs containsString:[ZZUrlTool main]]) {
            abs=[ZZUrlTool fullUrlWithTail:abs];
        }
        self.url=[NSURL URLWithString:abs];
        NSURLRequest* req=[NSURLRequest requestWithURL:self.url];
        [webv loadRequest:req];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    webv.frame=self.view.bounds;
}

-(void)dealloc
{
    webv.delegate=nil;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(navigationType==UIWebViewNavigationTypeLinkClicked)
    {
        BaseWebViewController* w=[[BaseWebViewController alloc]initWithUrl:[request URL]];
        [self.navigationController pushViewController:w animated:YES];
        return NO;
        
    }
    return YES;
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//
//    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//}

@end