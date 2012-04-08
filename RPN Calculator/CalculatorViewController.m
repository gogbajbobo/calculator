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
    NSLog(@"digit pressed = %@", digit);
}

+ (NSString *)logUpdate
{
    return nil;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfTheEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
//    self.log.text = [self.log.text stringByAppendingString:[sender.currentTitle stringByAppendingString:@" "]];
    self.log.text = [self.brain showDescription];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed {
    if (self.userIsInTheMiddleOfTheEnteringANumber) {
//        self.log.text = [self.log.text stringByAppendingString:[self.display.text stringByAppendingString:@" "]];
        if (self.userIsEnteringANumber) {
            [self.brain pushOperand:[NSNumber numberWithDouble:[self.display.text doubleValue]]];
            NSLog(@"enter pressed, send to brain = %@", self.display.text);
        } else {
            [self.brain pushOperand:self.display.text];        
            NSLog(@"enter pressed, send to brain = %@", self.display.text);
        }
        self.userIsInTheMiddleOfTheEnteringANumber = NO;
        self.userIsEnteringANumber = NO;
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
    NSLog(@"floatingPoint pressed = %@", @".");
}

- (IBAction)functionsPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfTheEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
//    self.log.text = [self.log.text stringByAppendingString:[sender.currentTitle stringByAppendingString:@" "]];
    self.log.text = [self.brain showDescription];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    NSLog(@"what pressed = %@", sender.currentTitle);
}

- (IBAction)piEntered:(UIButton *)sender {
    if (self.userIsInTheMiddleOfTheEnteringANumber) [self enterPressed];
//    self.display.text = [NSString stringWithFormat:@"%g", M_PI];
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
