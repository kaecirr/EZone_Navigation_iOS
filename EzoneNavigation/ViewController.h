//
//  ViewController.h
//  EzoneNavigation
//
//  Created by Keyur Modi on 9/9/17.
//  Copyright © 2017 Keyur Modi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapScreenVC.h"
#import "CalibrationIndicator.h"

@import IndoorAtlas;

@interface ViewController : UIViewController <IALocationManagerDelegate> {
    NSTimer *timer;
    
    UIImageView *imgViewBG;
    
}


-(void)loadSreenUI;

-(void) loadNextScreen;

@end

