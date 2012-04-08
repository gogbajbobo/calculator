//
//  CalculatorBrain.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 3/19/12.
//  Copyright (c) 2012 Maxim V. Grigoriev. All rights reserved.
//

// comment to test git source control 2


#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize variableValues = _variableValues;

- (NSString *)showDescription
{
    return [self.class descriptionOfProgram:self.program];
}

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)clearBrain {
    self.programStack = nil;
}

- (void)pushOperand:(id)operand
{
    NSArray *operationArray = [NSArray arrayWithObjects:@"sin", @"cos", @"sqrt", nil];
    if ([operand isKindOfClass:[NSNumber class]]) {
        [self.programStack addObject:[NSNumber numberWithDouble:[operand doubleValue]]];
    } else if ([operand isKindOfClass:[NSString class]]) {
        if ([operationArray containsObject:operand]) {
            [self.programStack addObject:[NSString stringWithString:[operand stringValue]]];
        } else if ([operand isEqual:@"π"]) {
            [self.programStack addObject:[NSNumber numberWithDouble:M_PI]];
        } else if ([self.variableValues.allKeys containsObject:operand]) {
            [self.programStack addObject:[self.variableValues valueForKey:operand]];
        } else {
            [self.programStack addObject:[NSNumber numberWithInt:0]];
        }
    }
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariableValues:self.variableValues];
}

- (id)program
{
    return [self.programStack copy];
}

- (NSDictionary *)variableValues
{
    if (_variableValues == nil) _variableValues = [[NSDictionary alloc] init];
    NSArray *keysArray = [NSArray arrayWithObjects:@"x",@"y",@"z", nil];
    NSArray *valuesArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], nil];
    _variableValues = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    return _variableValues;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self buildDescriptionOfProgram:(NSMutableArray *)stack];
}

+ (NSString *)buildDescriptionOfProgram:(NSMutableArray *)stack
{
    id result = nil;
    NSLog(@"stack_count%d", stack.count);
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = topOfStack;   
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        if ([[NSArray arrayWithObjects: @"sin", @"cos", @"sqrt", nil] containsObject:topOfStack]) {
            result = [NSString stringWithFormat:@"%@%@%@%@", topOfStack, @"(", [self buildDescriptionOfProgram:stack], @")"];
        } else if ([[NSArray arrayWithObjects: @"+", @"*", @"-", @"/", nil] containsObject:topOfStack]) {
            id secondArgument = [self buildDescriptionOfProgram:stack];
            id firstArgument = [self buildDescriptionOfProgram:stack];
            if ([firstArgument isKindOfClass:[NSString class]]) firstArgument = [NSString stringWithFormat:@"%@%@%@", @"(", firstArgument, @")"];
            if ([secondArgument isKindOfClass:[NSString class]]) secondArgument = [NSString stringWithFormat:@"%@%@%@", @"(", secondArgument, @")"];
            result = [NSString stringWithFormat:@"%@%@%@", firstArgument, topOfStack, secondArgument];                
        } else {
            result = topOfStack;
        }
    }
    NSLog(@"result%@", result);
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSSet *varSet = [NSSet set];
    NSSet *operationSet = [NSSet setWithObjects:@"sin",@"cos",@"sqrt",@"*",@"/",@"+",@"-",@"π", nil];
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSString class]]) {
        if (![operationSet containsObject:topOfStack]){
            if (![varSet containsObject:topOfStack]) {
                varSet = [varSet setByAddingObject:topOfStack];
            }
        }
    }
    return varSet;
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];

    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([@"/" isEqualToString:operation]) {
            NSNumber *divider = [NSNumber numberWithDouble:[self popOperandOffStack:stack]];
            result = [self popOperandOffStack:stack] / divider.doubleValue;
        } else if ([@"-" isEqualToString:operation]) {
            NSNumber *subtracter = [NSNumber numberWithDouble:[self popOperandOffStack:stack]];           
            result = [self popOperandOffStack:stack] - subtracter.doubleValue;
        } else if ([@"sin" isEqualToString:operation]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([@"cos" isEqualToString:operation]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([@"sqrt" isEqualToString:operation]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}


@end
