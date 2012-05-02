//
//  CalculatorViewController.h
//  RPN Calculator
//
//  Created by Григорьев Максим on 3/19/12.
//  Copyright (c) 2012 Maxim V. Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"

@interface CalculatorViewController : RotatableViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *log;
//@property (weak, nonatomic) IBOutlet UILabel *varsDisplay;



@property (nonatomic, strong) NSDictionary *variableValues;

@end
