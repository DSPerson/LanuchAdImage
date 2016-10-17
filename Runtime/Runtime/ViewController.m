//
//  ViewController.m
//  Runtime
//
//  Created by 杜帅 on 16/10/10.
//  Copyright © 2016年 杜帅. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>

#import "CheckLauchImage.h"
@interface ViewController () <UIAlertViewDelegate> {
    UIAlertController *alerC;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [CheckLauchImage checkLanuchImage:3 isShowAd:true ignore:false];
    [CheckLauchImage downLauchImageUrl:@"http://192.168.0.165/Upload/ads.jpg" update:true];
    
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)next:(id)sender {
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    id arr = [userD objectForKey:@"keyArr"];
    NSMutableArray *new = [(NSMutableArray *)arr mutableCopy];
    [new addObject:@"6"];
    
}


@end
