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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
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
    
    imgViewBG = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    imgViewBG.image = [UIImage imageNamed:@"spalsh_2.png"];
    
    [self.view addSubview:imgViewBG];
    
}

-(void)loadNextScreen {
    MapScreenVC *mapScreen = [[MapScreenVC alloc] init];
    
    [self.navigationController pushViewController:mapScreen animated:YES];
    
    mapScreen = nil;

}

@end
