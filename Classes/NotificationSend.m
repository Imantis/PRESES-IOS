//
//  NotiFicationSend.m
//  Team App
//
//  Created by Imants on 08/06/2018.
//

#import "NotiFicationSend.h"
#import "WebViewAppDelegate.h"


@implementation NotiFicationSend

-(void)startCheck{
    NSLog(@"Background fetch started...");
    
    //---do background fetch here---
    // You have up to 30 seconds to perform the fetch
    
    //GET PREFERENCE
    NSString *wishListPreference = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"wishList"];
    //IF PREFERENCE == null then create "{}" value
    if(wishListPreference){
        NSLog(@"Have prefernce");
    }else{
        NSLog(@"Haven't preference");
        wishListPreference = @"{}";
    }
    
    NSData *data = [wishListPreference dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *wishListPreferenceJsonBuf = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableDictionary *wishListPreferenceJson = [[NSMutableDictionary alloc] init];
    
    [wishListPreferenceJson addEntriesFromDictionary:wishListPreferenceJsonBuf];
    
    NSLog(@"AFTER PREFERENCE %@",wishListPreferenceJson);
    
    
    //THERE CHECK ON "NULL(COUNT OF ZURNAL), IF IT IS NULL
    NSString *query_wish = @"";
    for(NSString* key in wishListPreferenceJson) {
        query_wish = [NSString stringWithFormat:@"%@%@%@", query_wish, [[wishListPreferenceJson objectForKey:key] objectForKey:@"id"], @"_"];
    }
    
    NSString *task_url = [NSString stringWithFormat:@"%@%@%@%@", @"http://www3.presesserviss.lv", @"/getdate.php?wish_id=", query_wish, @"&action_type=get_new_count"];
    
    //NSString *task_url = [NSString stringWithFormat:@"%@%@%@%@", @"http://presesapp.sem.lv", @"/getdate.php?wish_id=", query_wish, @"&action_type=get_new_count"];
    
    NSLog(@"URL CONNECTION %@", task_url);
    /* GET STRING FROM WEBPAGE */
    
    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[aSession dataTaskWithURL:[NSURL URLWithString:task_url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            if (data) {
                //ON POST EXECUTE EQUIVALENT
                NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                
                //BEFORE/AFTER delimeter
                NSArray *arrayWithTwoStrings = [contentOfURL componentsSeparatedByString:@"[string_delimeter]"];
                
                //First date
                NSString *wishNewDate = [arrayWithTwoStrings objectAtIndex:0];

                //Second date USED LATER
                NSString *wishInformationString = [arrayWithTwoStrings objectAtIndex:1];
                
                //SEND FIRST DATE TO JSON
                wishNewDate = [wishNewDate
                               stringByReplacingOccurrencesOfString:@"[delimeter][" withString:@""];
                wishNewDate = [wishNewDate
                               stringByReplacingOccurrencesOfString:@"]delimeter][" withString:@"-"];
                wishNewDate = [wishNewDate
                               stringByReplacingOccurrencesOfString:@"][delimeter]" withString:@""];
                //NSLog(@"FIRST DATE %@", wishNewDate);

                NSArray *wishInformationListString = [wishNewDate componentsSeparatedByString:@"-"];

                NSMutableDictionary *wishNewInformation = [[NSMutableDictionary alloc] init];

                //CREATE JSON WITH INFORMATION
                for(NSString *wishInf in wishInformationListString){
                    // NSLog(@"WISH INF %@", wishInf);

                    NSData *data = [wishInf dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *wishListPreferenceJsonBuf = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                    NSString *combined = [NSString stringWithFormat:@"%@%@%@%@%s%@%s", @"{\"", [wishListPreferenceJsonBuf objectForKey:@"id"], @"\":{\"id\":\"", [wishListPreferenceJsonBuf objectForKey:@"id"], "\",\"count\":\"",[wishListPreferenceJsonBuf objectForKey:@"count"] ,"\"}}"];


                    data = [combined dataUsingEncoding:NSUTF8StringEncoding];
                    wishListPreferenceJsonBuf = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                    [wishNewInformation addEntriesFromDictionary:wishListPreferenceJsonBuf];
                }

                NSLog(@"WISH NEW INFORMATION - %@", wishNewInformation);
                
                //CHECK WHICH WISH NEED NOTIFICATION
                NSMutableArray *changeWish = [[NSMutableArray alloc] init];
                for(NSString* key in wishListPreferenceJson) {
                    NSString *oldCount =[[wishListPreferenceJson objectForKey:key] objectForKey:@"count"];
                    NSString *newCount =[[wishNewInformation objectForKey:key] objectForKey:@"count"];

                    if(!([oldCount isEqualToString:newCount])){
                        [changeWish addObject:key];

                    }

                }
                
                //UPDATE AND DELETE
                for(NSString *key in changeWish){
                    [wishListPreferenceJson removeObjectForKey:key];
                    
                    NSString *combined = [NSString stringWithFormat:@"%@%@%@%@%s%@%s", @"{\"", [[wishNewInformation objectForKey:key] objectForKey:@"id"], @"\":{\"id\":\"", [[wishNewInformation objectForKey:key] objectForKey:@"id"], "\",\"count\":\"",[[wishNewInformation objectForKey:key] objectForKey:@"count"] ,"\"}}"];
                    
                    NSData *data = [combined dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *wishListNEW = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    //NSLog(@"%@",wishListNEW);
                    
                    [wishListPreferenceJson addEntriesFromDictionary:wishListNEW];
                }
                
                NSLog(@"THIS NEED UPDATE %@", changeWish);
                
                NSLog(@"AFTER UPDATE %@", wishListPreferenceJson);

                //NSLog(@"%@",contentOfURL);
                //THERE CREATE SECOND DATE JSON CREATE
                //SEND SECOND DATE TO JSON
                wishInformationString = [wishInformationString
                               stringByReplacingOccurrencesOfString:@"[delimeter][" withString:@""];
                wishInformationString = [wishInformationString
                               stringByReplacingOccurrencesOfString:@"]delimeter][" withString:@"[some_delimeter]"];
                wishInformationString = [wishInformationString
                               stringByReplacingOccurrencesOfString:@"][delimeter]" withString:@""];
                //NSLog(@"wishInformationString %@", wishInformationString);

                NSArray *wishInformationListStringNotifications = [wishInformationString componentsSeparatedByString:@"[some_delimeter]"];

                NSMutableDictionary *wishNewInformationNotification = [[NSMutableDictionary alloc] init];

                //CREATE JSON WITH INFORMATION FOR NOTIFICATION
                for(NSString *wishInf in wishInformationListStringNotifications){
                     NSLog(@"WISH INF %@", wishInf);

                    NSData *data = [wishInf dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *wishListPreferenceJsonBuf = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                   // NSString *combined = [NSString stringWithFormat:@"%@%@%@%@%s%@%s", @"{\"", [wishListPreferenceJsonBuf objectForKey:@"id"], @"\":{\"id\":\"", [wishListPreferenceJsonBuf objectForKey:@"id"], "\",\"tittle\":\"",[wishListPreferenceJsonBuf objectForKey:@"tittle"] ,"\"}}"];
                    
                    NSString *combined = [NSString stringWithFormat:@"%@%@%@%@%s%@%s%@%s", @"{\"", [wishListPreferenceJsonBuf objectForKey:@"id"], @"\":{\"id\":\"", [wishListPreferenceJsonBuf objectForKey:@"id"], "\",\"send_newsletter\":\"", [wishListPreferenceJsonBuf objectForKey:@"send_newsletter"], "\",\"tittle\":\"", [wishListPreferenceJsonBuf objectForKey:@"tittle"] ,"\"}}"];


                    data = [combined dataUsingEncoding:NSUTF8StringEncoding];
                    wishListPreferenceJsonBuf = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                    [wishNewInformationNotification addEntriesFromDictionary:wishListPreferenceJsonBuf];
                }
                
                NSLog(@"INFORMATION FOR NOTIFICATION %@", wishNewInformationNotification);
                //SHOW NOTIFICATION
                NSString *body = @"";
                NSString *notification_tittle = @"";
                for(NSString *key in changeWish){
                    
                    if([[[wishNewInformationNotification objectForKey:key] objectForKey:@"send_newsletter"] isEqualToString:@"1"]){
                        NSLog(@"SHOW NOTIFICATION ID - %@", key);
                        
                        if([[[wishNewInformationNotification objectForKey:key] objectForKey:@"tittle"] containsString:@"[:ru]"]){
                            NSArray *arrayWithTwoStrings = [[[wishNewInformationNotification objectForKey:key] objectForKey:@"tittle"] componentsSeparatedByString:@"[:ru]"];
                            if([[self getCookiesLanguage] isEqualToString:@"lv"]){
                                notification_tittle = [arrayWithTwoStrings objectAtIndex:0];
                                notification_tittle = [notification_tittle stringByReplacingOccurrencesOfString:@"[:lv]" withString:@""];
                            }else{
                                notification_tittle = [arrayWithTwoStrings objectAtIndex:1];
                                }
                        }else{
                                notification_tittle = [[wishNewInformationNotification objectForKey:key] objectForKey:@"tittle"];
                            }

                        
                        body = [NSString stringWithFormat:@"%@%@%@", body, @"\n", notification_tittle];
                    }
                    
                }
                NSLog(@"BODY %@", body);
                
                
                if(!([body isEqualToString:@""])){
                    WebViewAppDelegate* mainVC = [[WebViewAppDelegate alloc] init];
                    [mainVC showNotification: body];
                }
                //NSLog(@"UNICODE TEST %@", [[wishNewInformationNotification objectForKey:@"83603"] objectForKey:@"tittle"]);
                
                
                
                NSLog(@"BEFORE PREFERENCE SAVE %@",wishListPreferenceJson);
                
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
    NSLog(@"LANGUAGE -  %@", [self getCookiesLanguage]);
    NSLog(@"Background fetch completed...");
    
}


/* GET CCOKIE AND SEND THEM TO THE SPECIAL ARRAY cookieListWish */
- (NSString *)getCookiesLanguage {
    NSLog(@"imant cookies");
    NSString *urlCookie = @"http://www3.presesserviss.lv";
    
    NSHTTPURLResponse * response;
    NSError * error;
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlCookie] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSArray *cookies =[[NSArray alloc]init];
    cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields]
    forURL:[NSURL URLWithString:urlCookie]]; // send to URL, return NSArray
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        if([[cookie name] isEqualToString:@"qtrans_front_language"]){
            NSString *list = [cookie value];
            return list;
        }
    }
    return @"";
}

@end
