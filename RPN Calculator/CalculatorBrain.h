//
//  CalculatorBrain.h
//  RPN Calculator
//
//  Created by Григорьев Максим on 3/19/12.
//  Copyright (c) 2012 Maxim V. Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(id)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearBrain;
- (NSString *)showDescription;

@property (readonly) id program;

// comment to test git source control

@property (nonatomic, strong) NSDictionary *variableValues;

+ (double) runProgram:(id)program;

+ (double) runProgram:(id)program
  usingVariableValues:(NSDictionary *)variableValues;

+ (NSString *)descriptionOfProgram:(id)program;

+ (NSSet *)variablesUsedInProgram:(id)program;

@end
