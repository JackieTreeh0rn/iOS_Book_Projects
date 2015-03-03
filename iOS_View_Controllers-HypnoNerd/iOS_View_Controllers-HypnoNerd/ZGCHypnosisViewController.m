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

/* Overriding UIViewContrllers designated initializer to get and set a tab bar item
 for this controller */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
    // Set the tab bar item's title
    self.tabBarItem.title = @"@Hypnotize";
    
    // Create a UIImage from a file
    // this will use Hypno@2x.png on retin display devices
    UIImage *i = [UIImage imageNamed:@"Hypno.png"];
    
    // Put that image on the tab bar item
    self.tabBarItem.image = i;
        
    }
    
    return self;

}


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
    
    // adding this to illustrate lazy loading, that is
    // views load when they are needed - never call a class view in its init method to
    // not break this.
    NSLog(@"%@ loaded its view", NSStringFromClass(self.class)); // could've just used literal name
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
