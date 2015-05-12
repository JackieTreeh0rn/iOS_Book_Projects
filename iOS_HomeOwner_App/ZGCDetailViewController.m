//
//  ZGCDetailViewController.m
//  iOS_HomeOwner_App
//
//  Created by EvilKernel on 4/23/15
//  Copyright (c) 2015 Zerogravity. All rights reserved
//

#import "ZGCDetailViewController.h"
#import "ZGCItem.h"

@interface ZGCDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation ZGCDetailViewController

/* UINavigationControllers send out viewWillAppear: and viewWillDissapear: to the 
 UIViewControllers as viewcontrollers are popped in and out of the stack */

/* Overriding 'viewWillAppear:' to setup the
 subviews of this controller's view to show the
 properties of the item 
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]; //you always call super on this method as per the reference
    
    ZGCItem *item = self.item;

    self.nameField.text = item.itemName;
    self.nameField.returnKeyType = UIReturnKeyDone;
    self.serialNumberField.text = item.serialNumber;
    self.serialNumberField.returnKeyType = UIReturnKeyDone;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    /// BRONZE CHALLENGE - DISPLAY A NUMBERPAD FOR THE VALUE FIELD ///
    self.valueField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    /// SILVER CHALLENGE part1 - DISMISSING A NUMBER BAD (adding a UItoolbar with a done button is my solution) ///
    CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 30.0);
    UIToolbar *inputAccessoryView = [[UIToolbar alloc] initWithFrame:accessFrame];
    inputAccessoryView.translucent = YES;
    inputAccessoryView.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self.valueField action:@selector(resignFirstResponder)];
    
    
    [inputAccessoryView setItems:@[done] animated:YES];

    self.valueField.inputAccessoryView = inputAccessoryView;
    
    

    // Creating an NSDateFormatter  that will turn date into simple date string
    // again, static variables are not destroyed when method finishes - gets declared only once in this case, stays alove while app is in memory
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    
}

/* Overriding viewWillDissapear: to set the properties
 of its 'item' to the contents of the textfields when 
 popping it off the stack 
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated]; //you always call super on this method as per the reference
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    ZGCItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue]; // NSString to int
    
}

# pragma mark - Target Actions

- (IBAction)takePicture:(id)sender {
    // Instantiate a new UIImagePickerController
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Define Source Type //
    // If the device has a camera, take a picture, otherwise...
    // Just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Define delegate
    imagePicker.delegate = self;
    //imagePicker.showsCameraControls = YES;
    
    // Present the UIViewController's view on the screen -MODALLY-
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
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

# pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Put image onto the screeen in our image view
    self.imageView.image = image;
    
    // Take the image picker off the screen, call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// SILVER CHALLENGE part2 ///
# pragma mark - UITextField Delegate Methods
// Using this delegate method to hide keyboard on each field when 'Return' is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
