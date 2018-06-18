    //
//  WebViewController.m
//  WebView
//
//  Created by Ajay Chainani on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewAppDelegate.h"
#import <WebKit/WebKit.h>

@implementation WebViewController

@synthesize urlString;

#pragma mark -
#pragma mark Application Lifecycle

- (void)loadView
{	
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	contentView.autoresizesSubviews = YES;
	self.view = contentView;	
	[contentView release];
	
//    //set the web frame size
//    CGRect webFrame = [[UIScreen mainScreen] bounds];
//    webFrame.origin.y = 0;
//
//    //add the web view
//    theWebView = [[UIWebView alloc] initWithFrame:webFrame];
//    theWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//    theWebView.scalesPageToFit = NO;
//    theWebView.delegate = self;
//    //[theWebView setDataDetectorTypes: UIDataDetectorTypeNone];
//
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    [theWebView loadRequest:req];
//
//    [self.view addSubview: theWebView];
    
    
    //set the web frame size
    CGRect webFrame = [[UIScreen mainScreen] bounds];
    webFrame.origin.y = 0;

    
    // Javascript that disables pinch-to-zoom by inserting the HTML viewport meta tag into <head>
    NSString *source = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    // Create the user content controller and add the script to it
    WKUserContentController *userContentController = [WKUserContentController new];
    [userContentController addUserScript:script];

    
    //add the web view
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    theConfiguration.userContentController = userContentController;
    theWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    theWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    theWebView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [theWebView loadRequest:req];

    [self.view addSubview: theWebView];
    
    
//    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
//    webView.navigationDelegate = self;
//    NSURL *nsurl=[NSURL URLWithString:@"http://www3.presesserviss.lv"];
//    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    [webView loadRequest:nsrequest];
//    [self.view addSubview:webView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"IMANT viewDidLoad");
    
    whirl = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	whirl.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
    whirl.center = self.view.center;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: whirl];
    
	[self.navigationController setToolbarHidden:NO animated:YES];
	
    [self updateToolbar];

}

//- (void)webView:(WKWebView *)webView
//didFinishNavigation:(WKNavigation *)navigation{
//    NSLog(@"IMANT didFinishNavigation");
//    
//    [self updateToolbar];
//    [whirl stopAnimating];
//    
//    WebViewAppDelegate* mainVC = [[WebViewAppDelegate alloc] init];
//    
//   // [mainVC setCookiePreferenceTimer];
//   // [NSThread sleepForTimeInterval: 1];
//    [mainVC setCookiePreferenceTimer];
//}
//
//- (void)webView:(WKWebView *)webView
//didStartProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"IMANT didStartProvisionalNavigation");
//    
//    [self updateToolbar];
//    [whirl startAnimating];
//}


//Webview Start/Finish Request
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"didStartProvisionalNavigation: %@", navigation);
    
    NSLog(@"IMANT didStartProvisionalNavigation");
    
    [self updateToolbar];
    [whirl startAnimating];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation: %@navigation, error: %@", navigation, error);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFinishLoadingNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"didFinishLoadingNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavigation: %@, error %@", navigation, error);
}

- (void)_webViewWebProcessDidCrash:(WKWebView *)webView {
    NSLog(@"WebContent process crashed; reloading");
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [theWebView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView didFinishNavigation: (WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"didFinish: %@; stillLoading:%@", [theWebView URL], (theWebView.loading?@"NO":@"YES"));
    NSLog(@"IMANT didFinishNavigation");
    
    [self updateToolbar];
    [whirl stopAnimating];
    
    WebViewAppDelegate* mainVC = [[WebViewAppDelegate alloc] init];
    
       // [mainVC setCookiePreferenceTimer];
       // [NSThread sleepForTimeInterval: 1];
    [mainVC setCookiePreferenceTimer];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationResponse");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(void)updateToolbar {
    
    NSLog(@"IMANT updateToolbar");
    
	UIBarButtonItem *backButton =	[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:theWebView action:@selector(goBack)];
	UIBarButtonItem *forwardButton =	[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forwardIcon.png"] style:UIBarButtonItemStylePlain target:theWebView action:@selector(goForward)];
    
    [backButton setEnabled:theWebView.canGoBack];
    [forwardButton setEnabled:theWebView.canGoForward];
    
    UIBarButtonItem *refreshButton = nil;
    if (theWebView.loading) {
        refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:theWebView action:@selector(stopLoading)];
    } else {
        refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:theWebView action:@selector(reload)];
    }
    
	UIBarButtonItem *openButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    UIBarButtonItem *spacing       = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //NSArray *contents = [[NSArray alloc] initWithObjects:backButton, spacing, forwardButton, spacing, spacing, spacing, nil];
    
    //NSArray *contents = [[NSArray alloc] initWithObjects:backButton, spacing, forwardButton, spacing, spacing, spacing, openButton, nil];
    NSArray *contents = [[NSArray alloc] initWithObjects:backButton, spacing, forwardButton, spacing, refreshButton, spacing, openButton, nil];
    [backButton release];
    [forwardButton release];
    [refreshButton release];
    [openButton release];
    [spacing release];
    
    [self setToolbarItems:contents animated:NO];
    
    [contents release];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
    [self.navigationController setToolbarHidden:YES animated:YES];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft);
}

//#pragma mark UIWebView delegate methods
//
//- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
//
//    return YES;
//}
//
//- (void) webViewDidStartLoad: (UIWebView * ) webView {
//    [whirl startAnimating];
//    [self updateToolbar];
//
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"%@",webView.request.URL.absoluteString);
//    [self updateToolbar];
//    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    [whirl stopAnimating];
//
// //   [WebViewAppDelegate setCookiePreferenceTimer];
//
////    WebViewAppDelegate* mainVC = [[WebViewAppDelegate alloc] init];
////
////    [mainVC setCookiePreferenceTimer];
//}
//
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [self updateToolbar];
//    [whirl stopAnimating];
//
//    //handle error
//}

#pragma mark -
#pragma mark ActionSheet methods

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0 && theWebView.request.URL != nil) {
//        [[UIApplication sharedApplication] openURL:theWebView.request.URL];
//    }
    if (buttonIndex == 0 && [theWebView URL] != nil) {
        [[UIApplication sharedApplication] openURL:[theWebView URL]];
    }

    NSLog(@"IMANT BUTTON OPEN URL");
}

- (void)shareAction {

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
										cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
										otherButtonTitles:@"Open in Safari", nil];
	
	[actionSheet showInView: self.view];
	[actionSheet release];
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//    
//    //deallocate web view
//    if (theWebView.loading)
//        [theWebView stopLoading];
//    
//    theWebView.delegate = nil;
//    [theWebView release];
//    theWebView = nil;
//}
//
//- (void)dealloc
//{
//    
//    [whirl release];
//
//    //make sure that it has stopped loading before deallocating
//    if (theWebView.loading)
//        [theWebView stopLoading];
//    
//    //deallocate web view
//    theWebView.delegate = nil;
//    [theWebView release];
//    theWebView = nil;
//    
//    [urlString release];
//    
//    [super dealloc];
//}

- (oneway void)release
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:NO];
    } else {
        [super release];
    }
}

@end
