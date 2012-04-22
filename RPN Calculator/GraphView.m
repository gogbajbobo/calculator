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
@synthesize xScale = _xScale;
@synthesize yScale = _yScale;
@synthesize verticalShift = _verticalShift;
@synthesize horizontalShift = _horizontalShift;

- (CGFloat)xScale
{
    if (!_xScale) _xScale = 1.0;
    return _xScale;
}

- (CGFloat)yScale
{
    if (!_yScale) _yScale = 1.0;
    return _yScale;
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

- (void)drawAxisInContext:(CGContextRef)context
{
// axis
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blackColor] setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.verticalShift);
    CGContextAddLineToPoint(context, 0, self.verticalShift-self.bounds.size.height);
    CGContextMoveToPoint(context, -self.horizontalShift, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width-self.horizontalShift, 0);
    CGContextStrokePath(context);
//ticks
    CGContextSetLineWidth(context, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 10, -5);
    CGContextAddLineToPoint(context, 10, 5);
    CGContextStrokePath(context);

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
    self.horizontalShift = 200;
    NSArray *yValues = [self.dataSource yValuesForXFromZeroTo:self.bounds.size.width
                                                   withXScale:self.xScale
                                                    andXShift:self.horizontalShift];
    for (int i = 0; i < self.bounds.size.width; i++) {
        currPoint.y = [[yValues objectAtIndex:i] floatValue];
        if (currPoint.y > maxValue) maxValue = currPoint.y;
        if (currPoint.y < minValue) minValue = currPoint.y;
    }
    self.yScale = self.bounds.size.height/(maxValue - minValue);
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];
    self.verticalShift = self.bounds.size.height+(minValue * self.yScale);
//    NSLog(@"vS%fmV%fyS%fH%f",self.verticalShift,minValue,self.yScale,self.bounds.size.height);
    self.verticalShift = 130;
    CGContextTranslateCTM(context, self.horizontalShift, self.verticalShift);
    CGContextScaleCTM(context, 1.0, -1.0);

    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, currPoint.x, currPoint.y);
    for (int i = 0; i < self.bounds.size.width; i++) {
        currPoint.x = i-self.horizontalShift;
        currPoint.y = [[yValues objectAtIndex:i] floatValue] * self.yScale;        
        CGContextAddLineToPoint(context, currPoint.x, currPoint.y);
    }
    CGContextStrokePath(context);

    [self drawAxisInContext:context];

    UIGraphicsPopContext();
}


@end
