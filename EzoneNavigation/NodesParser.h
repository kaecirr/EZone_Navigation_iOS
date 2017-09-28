//
//  NodesParser.h
//  EzoneNavigation
//
//  Created by Keyur Modi on 28/9/17.
//  Copyright © 2017 Keyur Modi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NodesParser : NSObject <NSURLConnectionDelegate> {
    NSMutableData   *responseData;
}

-(void) getPathDetails;

@end
