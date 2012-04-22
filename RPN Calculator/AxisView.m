//
//  AxisView.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/21/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import "AxisView.h"

@implementation AxisView

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor greenColor] setStroke];
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 100, 100);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}
*/

@end
