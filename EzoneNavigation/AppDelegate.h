//
//  AppDelegate.h
//  EzoneNavigation
//
//  Created by Keyur Modi on 9/9/17.
//  Copyright © 2017 Keyur Modi. All rights reserved.
//

#import <UIKit/UIKit.h>

@import IndoorAtlas;

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                  *window;
@property (strong, nonatomic) ViewController            *viewController;
@property (strong, nonatomic) UINavigationController    *navController;

@end

