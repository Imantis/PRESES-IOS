//
//  WebViewAppDelegate.m
//  WebView
//
//  Created by Ajay Chainani on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewAppDelegate.h"
#import "WebViewController.h"

@interface Util:NSObject
- (NSData *)parseJson:(NSString *) jsonstring;
@end

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
    //[self getCookies];
    [self showNotification];
    [self setCookiePreference];
    
}

- (void)setCookiePreference {
    //GET COOKIE
    [self getCookies];
    
    //GET PREFERENCE
    wishListPreference = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"wishList"];
    //IF PREFERENCE == null then create "{}" value
    if(wishListPreference){
        NSLog(@"if true");
    }else{
        NSLog(@"if false");
        wishListPreference = @"{}";
    }
    
    //NSLog(@"%@", wishListPreference);
    
    //wishListPreference = @"{\"84351\":{\"id\":\"84351\",\"count\":\"1\"},\"84376\":{\"id\":\"84376\",\"count\":\"2\"},\"84368\":{\"id\":\"84368\",\"count\":\"3\"}}";
    NSData *data = [wishListPreference dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *wishListPreferenceJsonBuf = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
   // NSLog(@"%@",wishListPreferenceJson);

    NSMutableDictionary *wishListPreferenceJson = [[NSMutableDictionary alloc] init];
    [wishListPreferenceJson addEntriesFromDictionary:wishListPreferenceJsonBuf];
   
    NSLog(@"AFTER PREFERENCE %@",wishListPreferenceJson);
    
    //WORK WITH JSON
//    for(id wishJson in wishListPreferenceJson){
//        NSLog(@"%@",[[wishListPreferenceJson objectForKey:wishJson] objectForKey:@"count"]);
//    }
    //NSLog([wishListPreferenceJson]);
    for(NSString *wish in cookieListWish){
        NSLog(@"WISH IN COOKIE: '%@'\n",wish);
    }
    
    
//    NSString *addJsonString;
//    id addJsonJson;
//    NSData *datas;
    //ADD new wish
//    NSMutableArray * arrBufWishList = [[NSMutableArray alloc] init];
//    [arrBufWishList addObject:wishListPreferenceJson];
    
    
    //ADD WISH
    for(NSString *wish in cookieListWish){
        //NSLog(@"WISH2: '%@'\n",wish);
        if(!([wishListPreferenceJson objectForKey:wish])){
            NSLog(@"ADD WISH: '%@'\n",wish);

            //NSString *newString = @"{\"84999\":{\"id\":\"84999\",\"count\":\"111\"}}";
            NSString *combined = [NSString stringWithFormat:@"%@%@%@%@%s", @"{\"", wish, @"\":{\"id\":\"", wish, "\",\"count\":\"111\"}}"];
            
            
            NSData *data = [combined dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *wishListNEW = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",wishListNEW);

            [wishListPreferenceJson addEntriesFromDictionary:wishListNEW];
        }
    }
    
    
    NSLog(@"AFTER ADD %@",wishListPreferenceJson);

    //DELETE WISH
    for(NSString *wish in cookieListWish){
        //NSLog(@"WISH2: '%@'\n",wish);
        if(!([wishListPreferenceJson objectForKey:wish])){
            NSLog(@"ADD WISH: '%@'\n",wish);
            
            //NSString *newString = @"{\"84999\":{\"id\":\"84999\",\"count\":\"111\"}}";
            NSString *combined = [NSString stringWithFormat:@"%@%@%@%@%s", @"{\"", wish, @"\":{\"id\":\"", wish, "\",\"count\":\"111\"}}"];
            
            
            NSData *data = [combined dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *wishListNEW = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",wishListNEW);
            
            [wishListPreferenceJson addEntriesFromDictionary:wishListNEW];
        }
    }
    
    NSLog(@"AFTER DELETE %@",wishListPreferenceJson);
    
    //NEW WISH LIST
//    for(id wishJson in wishListPreferenceJson){
//        NSLog(@"WISH AFTER ADD %@",[[wishListPreferenceJson objectForKey:wishJson] objectForKey:@"id"]);
//    }
    
    
    /* GET STRING FROM WEBPAGE */

    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[aSession dataTaskWithURL:[NSURL URLWithString:@"http://www3.presesserviss.lv/getdate_php.php?wish_id=84376_84372_84368_84370_84356_84352_&action_type=get_count"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            if (data) {
                //ON POST EXECUTE EQUIVALENT
                NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", contentOfURL);
                
                
                
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:wishListPreferenceJson
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    //NSLog(@"JSON STRING %@", jsonString);
                    
                    //SAVE NEW PREFERENCE
                    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:@"wishList"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }] resume];
    
    
    //PATTERN
    /*
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"[aZ]" options:0 error:&error];
    if (error) {
        // Do something when an error occurs
        NSLog(@"Error in pattern");
    }
    NSString *candidate = @"abc";
    BOOL lookingAt = [expression numberOfMatchesInString:candidate options:NSMatchingAnchored range:NSMakeRange(0, candidate.length)] > 0;
    */
    
}


/* TEST TIMER */
- (void)getCookies {
    NSLog(@"imant cookies");
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
//        NSLog(@"name: '%@'\n",   [cookie name]);
//        NSLog(@"value: '%@'\n",  [cookie value]);
//        NSLog(@"domain: '%@'\n", [cookie domain]);
//        NSLog(@"path: '%@'\n",   [cookie path]);
        if([[cookie name] isEqualToString:@"wishlist"]){
            NSString *list = [cookie value];
            cookieListWish = [list componentsSeparatedByString:@"-"];
//            NSLog(@"%d", cookieListWish.count);
//            for(NSString *wish in cookieListWish){
//                NSLog(@"WISHES: '%@'\n",wish);
//            }
            
            //DELETE "" NULL
            NSString *str;
            for(int i=0;i<[cookieListWish count];i++)
            {
                str = [cookieListWish objectAtIndex:i];
                if([str isEqualToString:@""])
                {
                    [cookieListWish removeObjectAtIndex:i];
                }
            }
            
//            for(NSString *wish in cookieListWish){
//                NSLog(@"WISH: '%@'\n",wish);
//            }
        }
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
