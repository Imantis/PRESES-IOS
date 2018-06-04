//
//  WebViewAppDelegate.m
//  WebView
//
//  Created by Ajay Chainani on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewAppDelegate.h"
#import "WebViewController.h"

bool IsGrantedNotificationAccess;

@implementation WebViewAppDelegate

@synthesize window, navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    //NSLog(@"imant can");
    //===============================================
    
    /* TEST NOTIFICATION WORK */
    IsGrantedNotificationAccess = false;

     UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
     UNAuthorizationOptions *options = UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
     
     [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            IsGrantedNotificationAccess = granted;
     }];
    /* TEST NOTIFICATION */
    
    //===============================================
    
    /* TEST TIMER WORK */
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(testtimer) userInfo:nil repeats:YES];
    /* TEST TIMER */
    
    //===============================================

    //===============================================
    
    
    // Override point for customization after application launch.
    
	navigationController = [[UINavigationController alloc] init];
    navigationController.navigationBar.hidden = YES;
    navigationController.toolbar.barStyle = UIBarStyleBlack;
	WebViewController *webViewController = [[WebViewController alloc] init];
	webViewController.urlString = @"http://www3.presesserviss.lv";
	
	[navigationController pushViewController:webViewController animated:NO];
	[webViewController release];
	
    [self.window setRootViewController:navigationController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/* TEST TIMER */
-(void) testtimer{
    NSLog(@"imant timer");
    [self getCookies];
    //[self showNotification];
    //[self setCookiePreference];
    
}

- (void)setCookiePreference {
    
    //GET PREFERENCE
   NSString *wish_list_preference = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"wishList"];
    //IF PREFERENCE == null then create "{}" value
    if(wish_list_preference){
        NSLog(@"if true");
    }else{
        NSLog(@"if false");
        wish_list_preference = @"{}";
    }
    
    NSLog(@"%@", wish_list_preference);
    
    wish_list_preference = @"{ \"84356\": { \"id\": \"84356\", \"count\": \"3\", }, \"84376\": { \"id\": \"84376\", \"count\": \"3\", }, \"84370\": { \"id\": \"84370\", \"count\": \"3\", }, \"84368\": { \"id\": \"84368\", \"count\": \"3\", }, \"84352\": { \"id\": \"84352\", \"count\": \"3\", } } ​";
    
    //NSData *data = [wish_list_preference dataUsingEncoding:NSUTF8StringEncoding];
    //id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //NSLog(@"%@",[json objectForKey:@"84356"]);
    
    
    /* GET STRING FROM WEBPAGE */

    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[aSession dataTaskWithURL:[NSURL URLWithString:@"http://www3.presesserviss.lv/getdate_php.php?wish_id=84376_84372_84368_84370_84356_84352_&action_type=get_count"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            if (data) {
                NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", contentOfURL);
            }
        }
    }] resume];
    
    
    //SAVE NEW PREFERENCE
    [[NSUserDefaults standardUserDefaults] setObject:wish_list_preference forKey:@"wishList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/* TEST TIMER */
- (void)getCookies {
    //NSLog(@"imant cookies");
    NSString *urlCookie = @"http://www3.presesserviss.lv";
    NSHTTPURLResponse * response;
    NSError * error;
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlCookie]
                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                       timeoutInterval:120];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSArray *cookies =[[NSArray alloc]init];
    cookies = [NSHTTPCookie
                cookiesWithResponseHeaderFields:[response allHeaderFields]
                forURL:[NSURL URLWithString:urlCookie]]; // send to URL, return NSArray
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        NSLog(@"name: '%@'\n",   [cookie name]);
        NSLog(@"value: '%@'\n",  [cookie value]);
        NSLog(@"domain: '%@'\n", [cookie domain]);
        NSLog(@"path: '%@'\n",   [cookie path]);
    }
}

-(void)showNotification {
    if(IsGrantedNotificationAccess){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"Notif tittle";
        content.subtitle = @"Notif subtile";
        content.body = @"Notif body";
        content.sound = [UNNotificationSound defaultSound];
        
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:nil];
    }
}
/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSArray *cookies =[[NSArray alloc]init];
    cookies = [NSHTTPCookie
               cookiesWithResponseHeaderFields:[response allHeaderFields]
               forURL:[NSURL URLWithString:@""]]; // send to URL, return NSArray
}
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    
    NSLog(@"imant applicationWillResignActive");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"imant applicationDidEnterBackground");
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
    [window release];
    [super dealloc];
}


@end
