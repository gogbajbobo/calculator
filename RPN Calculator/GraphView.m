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
    CGFloat maxValue = 0.0;
    CGFloat minValue = 0.0;
    CGFloat scale = 0.0;
    NSArray *yValues = [self.dataSource yValues:self.bounds.size.width];
    for (int i = 0; i < self.bounds.size.width; i++) {
        currPoint.y = [[yValues objectAtIndex:i] floatValue];
        if (currPoint.y > maxValue) maxValue = currPoint.y;
        if (currPoint.y < minValue) minValue = currPoint.y;
    }
    scale = self.bounds.size.height/(maxValue - minValue);
    NSLog(@"height%f",self.bounds.size.height);
    NSLog(@"max%fmin%fscale%f",maxValue,minValue,scale);
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];
    CGFloat verticalShift = self.bounds.size.height+(minValue * scale);
    NSLog(@"vS%f",verticalShift);
    CGContextTranslateCTM(context, 0.0, verticalShift);
    CGContextScaleCTM(context, 1.0, -1.0);

    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, currPoint.x, currPoint.y);
    for (int i = 0; i < self.bounds.size.width; i++) {
        currPoint.x = i;
        currPoint.y = [[yValues objectAtIndex:i] floatValue] * scale;        
        CGContextAddLineToPoint(context, currPoint.x, currPoint.y);
    }
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}


@end
