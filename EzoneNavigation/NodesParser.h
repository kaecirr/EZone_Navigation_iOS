//
//  NodesParser.h
//  EzoneNavigation
//
//  Created by Keyur Modi on 28/9/17.
//  Copyright © 2017 Keyur Modi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol NodesParserDelegate <NSObject>

-(void) NodesParserDidReceiveData:(NSDictionary *) dictOfNodesParser;
-(void) NodesParserDidReceiveError:(NSError *) error;

@end


@interface NodesParser : NSObject <NSURLConnectionDelegate> {
    NSMutableData   *responseData;
}

@property (nonatomic, weak) id  <NodesParserDelegate> NodesDelegate;

-(void) getPathDetailsWithCurrentLocation:(CLLocation *) currLocation andDestinationLocation:(CLLocation *) destLocation;

@end
