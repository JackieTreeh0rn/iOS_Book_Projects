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
    // Do any additional setup after loading the view from its nib
    // viewDidLoad gets run once when the viewcontroller is loaded
    // ...Adding this to illustrate lazy loading, that is
    // views load when they are needed - never call a class view in its init method to
    // not break this.
    NSLog(@"%@ loaded its view", NSStringFromClass(self.class)); // could've just used literal name
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /* overriding viewWillAppear allows you to do additional initializations
     on subviews before they appaer to the user (init methods dont work for this
     as the views are not fully loaded yet) viewWillAppear gets executed everytime the
     view controller appears onscreen */
    // in this case, we want this customozation to ocur everytime this
    // viewController is loaded, for its view
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60]; // no dates in the past allowed
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Target Action
- (IBAction)addReminder:(id)sender {
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
    // Adding a local notification
    UILocalNotification *note = [[UILocalNotification alloc] init];
    // Configuring local notification
    note.alertBody = @"Hypnotize me!";
    note.alertLaunchImage = @"Hypno.png"; // added an image for the pop-up
    note.fireDate = date; // set for date
    /* Scheduling with the shared application - the single instance of UIApplication */
    // First have to register so user approves first
    // Define a notification settings instance to pass as argument
    UIUserNotificationSettings *noteSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:[NSSet set]];
    // register with notification settings the types of alerts your app needs
    [[UIApplication sharedApplication] registerUserNotificationSettings:noteSettings];
    // schedule the notification now that we have access
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
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
