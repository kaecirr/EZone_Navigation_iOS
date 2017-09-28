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
    
    NSArray *reqObjectsArray = [NSArray arrayWithObjects:@"computerScience", @"second", @"31.2", @"29.8", @"31.8", @"29.6", nil];
    
    NSArray *reqKeysArray = [NSArray arrayWithObjects:@"building", @"floor", @"startLongitude", @"startLatitude", @"endLongitude", @"endLatitude", nil];
    
    NSDictionary *requestDataDict = [NSDictionary dictionaryWithObjects:reqObjectsArray forKeys:reqKeysArray];
    
    NSDictionary *jsonRequestDict = [NSDictionary dictionaryWithObject:requestDataDict forKey:@"requestData"];
    
    NSLog(@"json request dictionary is %@",jsonRequestDict);
    
    NSError *error;
    
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:jsonRequestDict options:0 error:&error];
    
    NSURL *url = [NSURL URLWithString:@"http://52.64.190.66:8080/springMVC-1.0-SNAPSHOT/"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody: jsonRequestData];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    //[NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:nil];

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
    
    NSLog(@"response data in didReceiveData is %@", responseData);
    
    NSError *error;
    
    //AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];

    NSDictionary *dictResponseJSON =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"response dictionay in didReceiveData is %@", dictResponseJSON);
    
    if(error) {
        NSLog(@"error didReceiveData is %@", error.description);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self processResponseData:responseData];
}

-(void) processResponseData: (NSData *) data {
    NSError *error;
    
    NSDictionary *dictResponseJSON =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"response dictionay in didFinishLoading is %@", dictResponseJSON);
}

@end
