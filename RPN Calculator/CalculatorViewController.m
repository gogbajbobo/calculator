//
//  CalculatorViewController.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 3/19/12.
//  Copyright (c) 2012 Maxim V. Grigoriev. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfTheEnteringANumber;
@property (nonatomic) BOOL userIsEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize userIsInTheMiddleOfTheEnteringANumber = _userIsInTheMiddleOfTheEnteringANumber;
@synthesize userIsEnteringANumber = _userIsEnteringANumber;
@synthesize display = _display;
@synthesize log = _log;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfTheEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfTheEnteringANumber = YES;
        self.userIsEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfTheEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    self.log.text = [self.brain showDescription];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed {
    if (self.userIsInTheMiddleOfTheEnteringANumber) {
        if (self.userIsEnteringANumber) {
            [self.brain pushOperand:[NSNumber numberWithDouble:[self.display.text doubleValue]]];
        } else {
            [self.brain pushOperand:self.display.text];        
        }
        self.userIsInTheMiddleOfTheEnteringANumber = NO;
        self.userIsEnteringANumber = NO;
//        if ([self.log.text isEqualToString:@""]) {
            self.log.text = [self.brain showDescription];
//        } else {
//            self.log.text = [NSString stringWithFormat:@"%@,%@",self.log.text,[self.brain showDescription]];            
//        }
    }
}


- (IBAction)floatingPointPressed {
    if (self.userIsInTheMiddleOfTheEnteringANumber) {
        NSRange range = [self.display.text rangeOfString:@"."];
        if (range.location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    } else {
        self.display.text = [@"0" stringByAppendingString:@"."];
        self.userIsInTheMiddleOfTheEnteringANumber = YES;
        self.userIsEnteringANumber = YES;
    }
}

- (IBAction)functionsPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfTheEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    self.log.text = [self.brain showDescription];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)piEntered:(UIButton *)sender {
    if (self.userIsInTheMiddleOfTheEnteringANumber) [self enterPressed];
    self.display.text = [NSString stringWithString:@"π"];
    self.userIsInTheMiddleOfTheEnteringANumber = YES;
    [self enterPressed];
}


- (IBAction)clearLogPressed {
    self.log.text = @"";
}


- (IBAction)clearBrainPressed {
    self.display.text = @"";
    self.log.text = @"";
    self.userIsInTheMiddleOfTheEnteringANumber = NO;
    self.userIsEnteringANumber = NO;
    [self.brain clearBrain];
}


- (void)viewDidUnload {
    [self setLog:nil];
    [super viewDidUnload];
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfTheEnteringANumber) [self enterPressed];
    NSString *variable = sender.currentTitle;
    self.display.text = variable;
    self.userIsInTheMiddleOfTheEnteringANumber = YES;
    [self enterPressed];
}

@end
