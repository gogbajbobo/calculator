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
//@synthesize varsDisplay = _varsDisplay;
@synthesize variableValues = _variableValues;

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    [_brain setVariableValuesWith:self.variableValues];
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
    NSLog(@"opPressed result = %f",result);
    self.log.text = [self.brain showDescription];
    NSLog(@"opPressed log text = %@",self.log.text);
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
            self.log.text = [self.brain showDescription];
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

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfTheEnteringANumber) [self enterPressed];
    NSString *variable = sender.currentTitle;
    self.display.text = variable;
    self.userIsInTheMiddleOfTheEnteringANumber = YES;
    [self enterPressed];
}

//- (IBAction)testButtonPressed:(UIButton *)sender {
//    NSArray *valuesArray = [NSArray array];
//    if ([sender.currentTitle isEqualToString:@"test0"]) {
//        [self setVariableValues:nil];
//    } else {
//        if ([sender.currentTitle isEqualToString:@"test1"]) {
//            valuesArray = [NSArray 
//                       arrayWithObjects:
//                       [NSNumber numberWithInt:1],
//                       [NSNumber numberWithInt:2],
//                       [NSNumber numberWithInt:3],
//                       nil];
//            NSLog(@"%@",valuesArray);
//        } else if ([sender.currentTitle isEqualToString:@"test2"]) {
//            valuesArray = [NSArray 
//                       arrayWithObjects:
//                       [NSNumber numberWithDouble:1.23],
//                       [NSNumber numberWithDouble:2.34],
//                       [NSNumber numberWithDouble:3.45],
//                       nil];
//            NSLog(@"%@",valuesArray);
//        }
//        [self setVariableValues:[self createVariableDictionary:valuesArray]];
//    }
//}

- (void)initializeVariables {
    NSArray *valuesArray = [NSArray 
                            arrayWithObjects:
                            [NSNumber numberWithInt:1],
//                            [NSNumber numberWithInt:2],
//                            [NSNumber numberWithInt:3],
                            nil];
    [self setVariableValues:[self createVariableDictionary:valuesArray]];
}

- (NSDictionary *)createVariableDictionary:(NSArray *)valuesArray
{
    NSArray *keysArray = [NSArray 
                          arrayWithObjects:
                          @"x",
//                          @"y",
//                          @"z",
                          nil];
    NSString *displayText = @"";
    for (int i=0; i<keysArray.count; i++) {
        displayText = [displayText stringByAppendingString:[NSString stringWithFormat:@"%@ = %@  ",[keysArray objectAtIndex:i],[[valuesArray objectAtIndex:i] stringValue]]];
    }
    NSLog(@"dT %@",displayText);
//    self.varsDisplay.text = displayText;

    return [NSDictionary dictionaryWithObjects:valuesArray 
                                       forKeys:keysArray];
}

- (IBAction)undoButtonPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfTheEnteringANumber) {
        if ([self.display.text length]>0) {
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];        
        } else {
            self.userIsInTheMiddleOfTheEnteringANumber = NO;
            self.display.text = @"end";
        }
    } else {
        NSLog(@"opPressed %@",sender.currentTitle);
        [self operationPressed:sender];
    }
}




- (void)viewDidUnload {
    [self setLog:nil];
//    [self setVarsDisplay:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [self initializeVariables];
}

@end
