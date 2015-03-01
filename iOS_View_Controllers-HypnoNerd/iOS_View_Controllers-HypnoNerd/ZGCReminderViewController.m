//
//  ZGCReminderViewController.m
//  iOS_View_Controllers-HypnoNerd
//
//  Created by EvilKernel on 2/28/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCReminderViewController.h"

@interface ZGCReminderViewController ()
// Class extension
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation ZGCReminderViewController

/* Overriding UIViewControllers designated initializer to include
 tab bar item */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = self.tabBarItem;
        
        // Give it a label
        tbi.title = @"Reminder";
        
        // Give it an image
        UIImage *i = [UIImage imageNamed:@"Time.png"];
        tbi.image = i;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Target Action
- (IBAction)addReminder:(id)sender {
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
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
