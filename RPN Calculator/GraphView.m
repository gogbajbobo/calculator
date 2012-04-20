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
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, currPoint.x, currPoint.y);
//    CGContextAddLineToPoint(context, 10, 10);
//    CGContextAddLineToPoint(context, 10, 50);
//    CGContextAddLineToPoint(context, 50, 50);
//    CGContextAddLineToPoint(context, 50, 100);
//    CGContextAddLineToPoint(context, 100, 100);
//    CGContextAddLineToPoint(context, 100, 200);
//    CGContextAddLineToPoint(context, 200, 200);
//    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    NSLog(@"%f",self.bounds.size.width);
    NSLog(@"%f",self.bounds.size.height);
    CGFloat maxValue;
    CGFloat maxKey;
    NSLog(@"Xvalues %@", [self.dataSource xValues]);
    NSLog(@"Yvalues %@", [self.dataSource yValues]);
    for (int i = 0; i < [self.dataSource xValues].count; i++) {
        currPoint.x = [[[self.dataSource xValues] objectAtIndex:i] floatValue];
        currPoint.y = [[[self.dataSource yValues] objectAtIndex:i] floatValue];
        if (currPoint.x > maxKey) maxKey = currPoint.x;
        if (currPoint.y > maxValue) maxValue = currPoint.y;
        CGContextAddLineToPoint(context, currPoint.x, currPoint.y);
    }
    CGContextScaleCTM(context,1,1);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}


@end
