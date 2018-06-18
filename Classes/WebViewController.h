//
//  WebViewController.h
//  WebView
//
//  Created by Ajay Chainani on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {

	WKWebView	*theWebView;
    //UIWebView    *theWebView;
	NSString	*urlString;
    UIActivityIndicatorView  *whirl;

}

-(void) updateToolbar;

//- (void)webView:(WKWebView *)webView
//didFinishNavigation:(WKNavigation *)navigation;
//
//- (void)webView:(WKWebView *)webView
//didStartProvisionalNavigation:(WKNavigation *)navigation;

@property (nonatomic, retain) NSString *urlString;

@end
