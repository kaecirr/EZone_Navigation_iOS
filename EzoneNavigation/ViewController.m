//
//  ViewController.m
//  EzoneNavigation
//
//  Created by Keyur Modi on 9/9/17.
//  Copyright © 2017 Keyur Modi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self loadSreenUI];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadNextScreen) userInfo:nil repeats:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Loading Methods
-(void)loadSreenUI {
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - 20.0, self.view.frame.size.width, 20.0)];
    
    lblTitle.text = @"EZONE NAVIGATION";
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblTitle];
}

-(void)loadNextScreen {
    MapScreenVC *mapScreen = [[MapScreenVC alloc] init];
    
    [self.navigationController pushViewController:mapScreen animated:YES];
    
    mapScreen = nil;

}

@end
