//
//  CBViewController.m
//  CBDesignView
//
//  Created by changbiao on 06/12/2017.
//  Copyright (c) 2017 changbiao. All rights reserved.
//

#import "CBViewController.h"

@interface CBViewController ()

@end

@implementation CBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [self.view addSubview:lab];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
       lab.text = @"分线程中调用测试";
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
