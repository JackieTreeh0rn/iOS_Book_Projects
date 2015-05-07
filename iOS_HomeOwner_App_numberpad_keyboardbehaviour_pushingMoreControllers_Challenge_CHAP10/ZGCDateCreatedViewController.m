//
//  ZGCDateCreatedViewController.m
//  iOS_HomeOwner_App_numberpad_keyboardbehaviour_pushingMoreControllers_Challenge_CHAP10
//
//  Created by EvilKernel on 4/28/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCDateCreatedViewController.h"
#import "ZGCItem.h"

@interface ZGCDateCreatedViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ZGCDateCreatedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]; // always call super first on this method
    
    // Date must be in the future - forcing  datepicker date to always be future 60 sec
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
    //self.navigationItem.hidesBackButton = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.item setDateCreated:self.datePicker.date];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    // Popping off this viewcontroller off the stack, goes back to the previous one
    [self.navigationController popViewControllerAnimated:YES];
}

/* Overriding the synthetized setter method for the 'item' property
 in order to set the navItem property of the this view controller using this
 method (can't do it in its 'init' since we do not know what 'item' will be
 until it gets assigned
 */
- (void)setItem:(ZGCItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
    
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
