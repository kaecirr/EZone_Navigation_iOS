//
//  NodesParser.m
//  EzoneNavigation
//
//  Created by Keyur Modi on 28/9/17.
//  Copyright © 2017 Keyur Modi. All rights reserved.
//

#import "NodesParser.h"

@implementation NodesParser

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)getPathDetails {
    
    NSArray *reqObjectsArray = @[@"computerScience", @"second", @"-31.97444473", @"115.8599", @"-31.97222274", @"115.823", @"DJ"];
    
    NSArray *reqKeysArray = @[@"building", @"floor", @"startLongitude", @"startLatitude", @"endLongitude", @"endLatitude", @"algorithm"];
    
    NSDictionary *requestDataDict = [NSDictionary dictionaryWithObjects:reqObjectsArray forKeys:reqKeysArray];
    
    
    NSMutableDictionary *jsonRequestDict = [NSMutableDictionary dictionaryWithObject:@"" forKey:@"requestMessage"];
    
    [jsonRequestDict setObject:requestDataDict forKey:@"mapDataRequest"];
    
    NSLog(@"json request dictionary is %@",jsonRequestDict);
    
    NSError *error;
    
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:jsonRequestDict options:0 error:&error];
    
    NSURL *url = [NSURL URLWithString:@"http://52.64.190.66:8080/springMVC-1.0-SNAPSHOT/path"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody: jsonRequestData];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Error, didFailWithError() ran");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    responseData= [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
    
//    NSLog(@"response data in didReceiveData is %@", responseData);
    
    
    NSError *error;
    
    //AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];

    NSDictionary *dictResponseJSON =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"response dictionay in didReceiveData is %@", dictResponseJSON);
    
    if(error) {
        NSLog(@"error didReceiveData is %@", error.description);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self processResponseData:responseData];
}

-(void) processResponseData: (NSData *) data {
//    NSError *error;
//    
//    NSDictionary *dictResponseJSON =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    
//    NSLog(@"response dictionay in processData is %@", dictResponseJSON);
}

@end
