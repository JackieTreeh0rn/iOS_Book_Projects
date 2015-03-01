//
//  ZGCHypnosisViewController.m
//  iOS_View_Controllers-HypnoNerd
//
//  Created by EvilKernel on 2/28/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCHypnosisViewController.h"
#import "ZGCHypnosisView.h" //my view class

@interface ZGCHypnosisViewController ()

@end

@implementation ZGCHypnosisViewController

/* Creating view hierarchy programmatically, not using XIB/NIB */
    // not using NIB so no initWithNIB is called
- (void)loadView {
    // Create View
    ZGCHypnosisView *backgroundView = [[ZGCHypnosisView alloc] init];
    // Set it as *the* root view of this view controller
    self.view = backgroundView;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
