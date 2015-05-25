//
//  ZGCDrawViewController.m
//  ZGCTouchTracker
//
//  Created by EviLKerneL on 5/25/15.
//  Copyright (c) 2015 EviLKerneL. All rights reserved.
//

#import "ZGCDrawViewController.h"
#import "ZGCDrawView.h"

@interface ZGCDrawViewController ()

@end

@implementation ZGCDrawViewController


#pragma mark - View Life Cycle

- (void)loadView {
    // overriding loadView method to load my own view
    self.view = [[ZGCDrawView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
