//
//  ZGCHypnosisViewController.m
//  iOS_View_Controllers-HypnoNerd
//
//  Created by EvilKernel on 2/28/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCHypnosisViewController.h"
#import "ZGCHypnosisView.h" //my view class

@interface ZGCHypnosisViewController () <UITextFieldDelegate> // conforms to TextField protocol


@end


@implementation ZGCHypnosisViewController

/* Overriding UIViewContrllers designated initializer to get and set a tab bar item
 for this controller */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
    // Set the tab bar item's title
    self.tabBarItem.title = @"Hypnotize";
    
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
    // Adding this to illustrate lazy loading, that is
    // views load when they are needed - never call a class view in its
    // init method to not break this.
    NSLog(@"%@ loaded its view", NSStringFromClass(self.class)); // could've just used literal name
    
    /* SILVER Challenge - adding a UISegmentedControl for red, green, blue
     when the user taps a segmented control, circle color changes */
    // Using viewDidLoad as per reference doc. you configure view elements here if overridinf loadView for manual view
    // Adding new control
    UISegmentedControl *colorControl = [[UISegmentedControl alloc] initWithItems:@[@"red", @"green", @"blue"]];
    // Defining frame for control
    colorControl.frame = CGRectMake((self.view.bounds.origin.x + 85), self.view.bounds.origin.y + 550, 200, 30);
    // configuring control
    colorControl.tintColor = [UIColor blackColor];
    
    // define target actions
    [colorControl addTarget:self.view
                     action:@selector(selectCircleColor:)
           forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:colorControl];
   
    //- Text Fields -//
    // adding a text field
    CGRect frame = CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    // Setting the border style on the text field to see it more clearly
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me";
    // UITextInputTrait class, properties that define kbd - here we set return keyboard key. "DONE" in this case.
    textField.returnKeyType = UIReturnKeyDone;
    
    // Defining delegate (for call backs)
    textField.delegate = self; // delegate is the controller itself in this case
    
    [self.view addSubview:textField];
    
    // Key-value test //
    //[self.view setValue:[UIColor redColor] forKey:@"circleColor"];
    

}

#pragma  - textfield delegate protocol method
//we are implementing it to take the action we want when RETURN (DONE in this case) is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // NSLog(@"%@", textField.text);
    
    // Calling the random label method via this protocol method so it gets called on return
    // for the text field
    [self drawHypnoticMessage:textField.text];
    textField.text = @"";     // blank out the text field afterwards
    [textField resignFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - labels at random positions
- (void)drawHypnoticMessage:(NSString *)message {
    for (int i = 0; i < 20; i++) {
        
        UILabel *messageLabel = [[UILabel alloc] init];
        
        // Configure the label's color and text
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.minimumScaleFactor = 5; // text size
        messageLabel.text = message;
        
        // This method resizes the label, which will be relative
        // to the text that it is displaying
        [messageLabel sizeToFit];
        
        // Get a random x value that fits within the hypnosis view's width
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        
        // Get a randome y value that fits within the hypnosis view height
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        
        // Update the label's frame
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;

        // Finally, add the label to the hiearchy
        [self.view addSubview:messageLabel];
        // sending to back so it doesnr overlap over textfield
        [self.view sendSubviewToBack:messageLabel];
        
        // adding a "paralax" for mption effect on this UIlabel view objects
        UIInterpolatingMotionEffect *motionEffect; // class for tilting a view
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
        // The Parallax can only be tested on an actual device.  test on iPhone //
                                               
        
    }
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
