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
    // y-axis
    CGContextMoveToPoint(context, 0, -self.verticalShift);
    CGContextAddLineToPoint(context, 0, -self.verticalShift+self.bounds.size.height);
    // x-axis
    CGContextMoveToPoint(context, -self.horizontalShift, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width-self.horizontalShift, 0);
    
    CGContextStrokePath(context);

// ticks
    CGFloat majorTickLength = 10;
    CGFloat minorTickLength = 4;
    UIFont *font = [UIFont systemFontOfSize:10];
    CGAffineTransform textTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextBeginPath(context);

    CGFloat xStep = 50;
    CGFloat xTicksStart = ceilf(-self.horizontalShift/xStep)*xStep;
    CGFloat xTicksEnd = floorf((self.bounds.size.width-self.horizontalShift)/xStep)*xStep;
    CGContextMoveToPoint(context, xTicksStart-xStep/2, -minorTickLength/2);
    CGContextAddLineToPoint(context, xTicksStart-xStep/2, minorTickLength/2);
    for (float i = xTicksStart; i <= xTicksEnd; i += xStep) {
        CGContextMoveToPoint(context, i, -majorTickLength/2);
        CGContextAddLineToPoint(context, i, majorTickLength/2);
        CGRect textRect;
        NSString *tickValue = [NSString stringWithString:[[NSNumber numberWithInt:rint(i)] stringValue]];
        if ([tickValue isEqualToString:@"0"])tickValue = @"";
        textRect.size = [tickValue sizeWithFont:font];
        textRect.origin.x = i - textRect.size.width / 2;
        textRect.origin.y = - 20 - textRect.size.height / 2;
        [tickValue drawInRect:textRect withFont:font];
        textRect = CGRectApplyAffineTransform(textRect, textTransform);
        CGContextMoveToPoint(context, i+xStep/2, -minorTickLength/2);
        CGContextAddLineToPoint(context, i+xStep/2, minorTickLength/2);
    }

//    CGFloat yStep = 50;
    CGFloat yStep = [self tickStepCalculateFor:self.bounds.size.height/self.yScale];
    CGFloat yTicksEnd = ceilf(-self.verticalShift/(yStep*self.yScale))*yStep;
    CGFloat yTicksStart = floorf(-(self.verticalShift-self.bounds.size.height)/(yStep*self.yScale))*yStep;
    NSLog(@"TS%f TE%f vS%f bH%f yS%f ySc%f",yTicksStart,yTicksEnd,self.verticalShift,self.bounds.size.height,yStep,self.yScale);
    CGContextMoveToPoint(context, -minorTickLength/2, self.yScale * (yTicksStart - yStep / 2));
    CGContextAddLineToPoint(context, minorTickLength/2, self.yScale * (yTicksStart - yStep / 2));
    for (float i = yTicksStart; i <= yTicksEnd; i += yStep) {
        CGContextMoveToPoint(context, -majorTickLength/2, self.yScale * i);
        CGContextAddLineToPoint(context, majorTickLength/2, self.yScale * i);
        CGRect textRect;
        textRect = CGRectApplyAffineTransform(textRect, textTransform);
        NSString *tickValue;
        if (i < 10) {
            tickValue = [NSString stringWithString:[[NSNumber numberWithFloat:i] stringValue]];
        } else {
            tickValue = [NSString stringWithString:[[NSNumber numberWithInt:rint(i)] stringValue]];
        }
        if ([tickValue isEqualToString:@"0"])tickValue = @"";
        textRect.size = [tickValue sizeWithFont:font];
        textRect.origin.x = 20 - textRect.size.width / 2;
        textRect.origin.y = self.yScale * i - textRect.size.height / 2;
        [tickValue drawInRect:textRect withFont:font];
        CGContextMoveToPoint(context, -minorTickLength/2, self.yScale * (i + yStep / 2));
        CGContextAddLineToPoint(context, minorTickLength/2, self.yScale * (i + yStep / 2));
    }

    CGContextStrokePath(context);

}

- (CGFloat)tickStepCalculateFor:(CGFloat)axisRange
{
    CGFloat tickStep = 1;
    if (axisRange < 1) {
        NSString *axisRangeString = [NSString stringWithFormat:@"%f",fabs(axisRange)];
        NSLog(@"%f",fabs(axisRange));
        NSLog(@"%@",axisRangeString);
        unichar charAtIndex;
        int charPosition;
        for (int i = 0; i < axisRangeString.length; i++) {
            charAtIndex = [axisRangeString characterAtIndex:i];
            if (charAtIndex != '0' && charAtIndex != '.') {
                charPosition = i;
                break;
            }
        }
        NSLog(@"charAtIndex %C %d", charAtIndex, charPosition);
        if (charAtIndex >= '0' && charAtIndex <= '4') {
            tickStep = 0.5 * powf(10, -(charPosition-1));
        } else if ((charAtIndex >= '5' && charAtIndex <= '9')) {
            tickStep = powf(10, -(charPosition-1));
        }
    } else {
        NSString *axisRangeString = [NSString stringWithFormat:@"%d",lrintf(abs(axisRange))];
        unichar firstChar = [axisRangeString characterAtIndex:0];
        if (firstChar >= '0' && firstChar <= '4') {
            tickStep = 0.5 * powf(10, axisRangeString.length-1);
        } else if ((firstChar >= '5' && firstChar <= '9')) {
            tickStep = powf(10, axisRangeString.length-1);
        }
    }
    return tickStep;
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
    self.horizontalShift = 283;
    NSArray *yValues = [self.dataSource yValuesForXFromZeroTo:self.bounds.size.width
                                                   withXScale:self.xScale
                                                    andXShift:self.horizontalShift];
    for (int i = 0; i < self.bounds.size.width; i++) {
        currPoint.y = [[yValues objectAtIndex:i] floatValue];
        if (currPoint.y > maxValue) maxValue = currPoint.y;
        if (currPoint.y < minValue) minValue = currPoint.y;
    }
    self.yScale = self.bounds.size.height/(minValue - maxValue);
    self.yScale = -400;
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];
    self.verticalShift = self.bounds.size.height+(minValue * self.yScale);
    self.verticalShift = 330;
    CGContextTranslateCTM(context, self.horizontalShift, self.verticalShift);
//    CGContextScaleCTM(context, 1.0, -1.0);

    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    for (int i = 0; i < self.bounds.size.width; i++) {
        currPoint.x = i-self.horizontalShift;
        currPoint.y = [[yValues objectAtIndex:i] floatValue] * self.yScale;
        if (i==0) {
            CGContextMoveToPoint(context, currPoint.x, currPoint.y);
        } else {
            CGContextAddLineToPoint(context, currPoint.x, currPoint.y);
        }
    }
    CGContextStrokePath(context);

    [self drawAxisInContext:context];

    UIGraphicsPopContext();
}


@end
