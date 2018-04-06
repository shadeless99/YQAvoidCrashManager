//
//  YQViewController.m
//  YQAvoidCrashManager
//
//  Created by gyq19900513@126.com on 04/06/2018.
//  Copyright (c) 2018 gyq19900513@126.com. All rights reserved.
//

#import "YQViewController.h"
#import "YQAvoidCrashManager.h"

@interface YQViewController ()

@end

@implementation YQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 开启防崩溃
    [YQAvoidCrashManager startAvoid];
    
    NSMutableArray *arr = [NSMutableArray array];
    id obj = [arr objectAtIndex:1];
    NSLog(@"obj : %@",obj);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
