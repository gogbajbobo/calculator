//
//  GraphView.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/18/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView
@synthesize XYvalues = _XYvalues;

- (void)setXYvalues:(NSDictionary *)XYvalues
{
    if (XYvalues != _XYvalues) {
        _XYvalues = XYvalues;
        NSLog(@"XYvalues inside GraphView %@",_XYvalues);
        [self setNeedsDisplay];
    }
}

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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint currPoint;
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, currPoint.x, currPoint.y);
    NSLog(@"self.XYvalues%@",self.XYvalues);
    for (int i = 0; i < [self.XYvalues allKeys].count; i++) {
        currPoint.x = [[[self.XYvalues allKeys] objectAtIndex:i] floatValue];
        currPoint.y = [[[self.XYvalues allValues] objectAtIndex:i] floatValue];
        CGContextAddLineToPoint(context, currPoint.x, currPoint.y);
    }
    CGContextStrokePath(context);
    UIGraphicsPopContext();

}


@end
