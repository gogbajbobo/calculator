//
//  CalculatorBrain.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 3/19/12.
//  Copyright (c) 2012 Maxim V. Grigoriev. All rights reserved.
//


#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize variableValues = _variableValues;
@synthesize constantValues = _constantValues;


- (void)setVariableValuesWith:(NSDictionary *)variableDictionary {
    if ([variableDictionary isKindOfClass:NSDictionary.class]) {
        self.variableValues = variableDictionary;        
    } else {
        self.variableValues = [NSDictionary dictionary];
    }
}


- (NSString *)showDescription
{
    return [CalculatorBrain 
                descriptionOfProgram:self.program
//                usingVariableValues:self.variableValues
            ];
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
    if ([operand isKindOfClass:[NSNumber class]]) {
        [self.programStack 
         addObject:[NSNumber numberWithDouble:[operand doubleValue]]];
    } else if ([operand isKindOfClass:[NSString class]]) {
        [self.programStack 
         addObject:[NSString stringWithString:operand]];
    }
}

- (double)performOperation:(NSString *)operation
{
    if ([operation isEqualToString:@"Undo"]) {
        NSLog(@"Undo pressed");
        if ([self.programStack lastObject]) {
            [self.programStack removeLastObject];
            NSLog(@"Last object YES");
        }
    } else {
        [self.programStack addObject:operation];
    }
    return [CalculatorBrain 
            runProgram:self.program 
            usingVariableValues:self.variableValues];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
               usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    stack = [self replaceVariableWithValuesIn:stack usingVariableDictionary:variableValues];
    return [self descriptionOfProgram:stack];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self 
            buildDescriptionOfProgram:(NSMutableArray *)stack 
            callingByOperationWithPriority:0];
}

+ (NSString *)buildDescriptionOfProgram:(NSMutableArray *)stack
         callingByOperationWithPriority:(int)priority
{
    NSString *result = nil;
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
        if ([topOfStack isKindOfClass:[NSNumber class]]) {
            result = [topOfStack stringValue];
        } else if ([topOfStack isKindOfClass:[NSString class]]) {
            if ([[NSArray arrayWithObjects: @"sin", @"cos", @"sqrt", nil] containsObject:topOfStack]) {
                result = [NSString stringWithFormat:@"%@(%@)", topOfStack, [self buildDescriptionOfProgram:stack callingByOperationWithPriority:1]];
            } else if ([[NSArray arrayWithObjects: @"+", @"*", @"-", @"/", nil] containsObject:topOfStack]) {
                int p = 1;
                if ([topOfStack isEqual:@"*"]||[topOfStack isEqual:@"/"]) p = 2;
                id secondArgument = [self buildDescriptionOfProgram:stack callingByOperationWithPriority:p];
                id firstArgument = [self buildDescriptionOfProgram:stack callingByOperationWithPriority:p];
                NSString *stringFormat;
                if (priority>p) {
                    stringFormat = @"(%@)";
                } else {
                    stringFormat = @"%@";
                }
                result = [NSString stringWithFormat:stringFormat,[NSString stringWithFormat:@"%@%@%@",firstArgument,topOfStack,secondArgument]];
            } else {
                result = topOfStack;
            }
        }
    }
    if (priority==0 && stack.count>0) result = [NSString stringWithFormat:@"%@,%@",result,[self buildDescriptionOfProgram:stack callingByOperationWithPriority:0]];
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSSet *operationSet = [NSSet 
                           setWithObjects:
                            @"sin",
                            @"cos",
                            @"sqrt",
                            @"*",
                            @"/",
                            @"+",
                            @"-",
                            @"π",
                            @"e",
                            nil];
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self variableFinder:stack usingOperationSet:operationSet];
}

+ (NSSet *)variableFinder:(NSMutableArray *)stack
        usingOperationSet:(NSSet *)operationSet
{
    NSMutableSet *varSet = [NSMutableSet set];
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
        if ([topOfStack isKindOfClass:[NSString class]]) {
            if (![operationSet containsObject:topOfStack]){
                if (![varSet containsObject:topOfStack]) {
                    [varSet 
                     unionSet:
                        [[self 
                          variableFinder:stack 
                          usingOperationSet:operationSet] 
                     setByAddingObject:topOfStack]];
                }
            }
        }
        [varSet unionSet:[self variableFinder:stack 
                            usingOperationSet:operationSet]];
    }
    return varSet;
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    NSLog(@"popOperandOffStack");
    if (topOfStack) {
        NSLog(@"topOfStack YES");
        [stack removeLastObject];

        if ([topOfStack isKindOfClass:[NSNumber class]]) {
            result = [topOfStack doubleValue];
        }
        else if ([topOfStack isKindOfClass:[NSString class]]) {
            
            NSString *operation = topOfStack;
            if ([@"+" isEqualToString:operation]) {
                result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
            } else if ([@"*" isEqualToString:operation]) {
                result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
            } else if ([@"/" isEqualToString:operation]) {
                NSNumber *divider = [NSNumber numberWithDouble:[self popOperandOffStack:stack]];
                if (divider.doubleValue==0){
                    divider=[NSNumber numberWithDouble:1];
                } else {
                    NSNumber *firstArgument = [NSNumber numberWithDouble:[self popOperandOffStack:stack]];
                    result = firstArgument.doubleValue / divider.doubleValue;                    
                }
            } else if ([@"-" isEqualToString:operation]) {
                NSNumber *subtracter = [NSNumber numberWithDouble:[self popOperandOffStack:stack]];           
                result = [self popOperandOffStack:stack] - subtracter.doubleValue;
            } else if ([@"sin" isEqualToString:operation]) {
                result = sin([self popOperandOffStack:stack]);
            } else if ([@"cos" isEqualToString:operation]) {
                result = cos([self popOperandOffStack:stack]);
            } else if ([@"sqrt" isEqualToString:operation]) {
                result = sqrt([self popOperandOffStack:stack]);
            } else if ([@"π" isEqualToString:operation]) {
                result = M_PI;
            } else {
                result = 0;
            }
        }
    }
    
    return result;
}

+ (NSMutableArray *)replaceVariableWithValuesIn:(NSMutableArray *)stack
                        usingVariableDictionary:(NSDictionary *)variableValues
{
    NSLog(@"replaceVWV");
    NSMutableArray *result = stack;
    if (result.count>0) {
        NSMutableArray *keysArray = [NSMutableArray arrayWithArray:variableValues.allKeys];
        for (int i=0; i<=keysArray.count-1; i++) {
            NSString *key = [keysArray objectAtIndex:i];
            for (int j=0; j<=result.count-1; j++) {
                NSString *values = [result objectAtIndex:j];
                if ([values isEqual:key]) {
                    [result replaceObjectAtIndex:j 
                                      withObject:[variableValues valueForKey:key]];
                }
            }
        }
    }
    return result;
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues
{
    NSLog(@"runProgram usingVV");
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    stack = [self replaceVariableWithValuesIn:stack usingVariableDictionary:variableValues];
    return [self runProgram:stack];
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
