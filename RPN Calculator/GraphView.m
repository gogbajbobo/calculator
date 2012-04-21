//
//  GraphView.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/18/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView
@synthesize dataSource = _dataSource;


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
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint currPoint;
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, currPoint.x, currPoint.y);
    NSLog(@"w%f",self.bounds.size.width);
    NSLog(@"h%f",self.bounds.size.height);
    CGFloat maxValue;
    CGFloat minValue;
    NSArray *yValues = [self.dataSource yValues:self.bounds.size.width];
    for (int i = 0; i < self.bounds.size.width; i++) {
        currPoint.x = i;
        currPoint.y = [[yValues objectAtIndex:i] floatValue];
        if (currPoint.y > maxValue) maxValue = currPoint.y;
        if (currPoint.y < minValue) minValue = currPoint.y;
        CGContextAddLineToPoint(context, currPoint.x, currPoint.y);
    }
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}


@end
