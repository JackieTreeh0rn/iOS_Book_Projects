//
//  ZGCViewController.m
//  iOS_Quiz
//
//  Created by EvilKernel on 2/19/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCViewController.h"

@interface ZGCViewController ()
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic) int currentQuestionIndex;
@end


@implementation ZGCViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create two arrays filld with questions and answers and make pointers
        self.questions = @[@"From what is Cognac made?",
                           @"What is 7+7?",
                           @"What is the capital of Vermont?"];
        
        self.answers = @[@"Grapes",
                         @"14",
                         @"Montpelier"];
        
    }
    // Return the address of the new object
    return self;
}


- (IBAction)showQuestion:(id)sender {
    // Step to the next question
    NSLog(@"current question index: %d", self.currentQuestionIndex);
    self.currentQuestionIndex++;
    // AM I past the las question?
    if (self.currentQuestionIndex == [self.questions count]) {
        // Go back to the first question
        self.currentQuestionIndex = 0;
    }
    // Get the string at that index in the question array
    NSString *question = self.questions[self.currentQuestionIndex];
    // Display question on question label
    self.questionLabel.text = question;
    // Reset the answer label
    self.answerLabel.text = @"???";
    
}


- (IBAction)showAnswer:(id)sender {
    // What is the answer to th current question?
    if ((self.questionLabel.text.length == 0)) {
        return;
    }
    NSString *answer = self.answers[self.currentQuestionIndex];
    // Display it in the answer label
    self.answerLabel.text = answer;
   
    
}


@end
