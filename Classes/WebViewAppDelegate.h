//
//  WebViewAppDelegate.h
//  WebView
//
//  Created by Ajay Chainani on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface WebViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
    NSString *wishListPreference;
    NSArray *cookieListWish;
    NSString *webUrl;
}

-(void) setCookiePreferenceTimer;
-(void) getCookies;

-(void)showNotification:(NSString*) body;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;


@end

