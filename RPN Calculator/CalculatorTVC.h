//
//  CalculatorTVC.h
//  RPN Calculator
//
//  Created by Григорьев Максим on 5/12/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorTVC;

@protocol CalculatorTVCDelegate <NSObject>

@optional
- (void)calculatorTVC:(CalculatorTVC *)sender
         choseProgram:(id)program;

@end

@interface CalculatorTVC : UITableViewController
@property (nonatomic, strong) NSArray *programs;
@property (nonatomic, weak) id <CalculatorTVCDelegate> delegate;

@end
