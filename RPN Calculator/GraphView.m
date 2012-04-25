//
//  GraphView.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/18/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import "GraphView.h"

@interface GraphView()
@property (nonatomic) BOOL scaleChanged;
@property (nonatomic) BOOL shifted;

@end

@implementation GraphView
@synthesize dataSource = _dataSource;
@synthesize xScale = _xScale;
@synthesize yScale = _yScale;
@synthesize verticalShift = _verticalShift;
@synthesize horizontalShift = _horizontalShift;

// It's possible to 
@synthesize scale = _scale;
@synthesize scaleChanged = _scaleChanged;
@synthesize shifted = _shifted;
@synthesize xyScaleRelation = _xyScaleRelation;

- (CGFloat)scale
{
    if (!_scale) _scale = 1.0;
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if (!self.scaleChanged) {
        _scale = 1;
        self.xScale = scale/self.xyScaleRelation;
        self.yScale = scale;
        NSLog(@"scale %f xScale %f yScale %f xyScaleRelation %f",self.scale, self.xScale, self.yScale, self.xyScaleRelation);
        self.scaleChanged = YES;
    } else {
        _scale = 1;
        self.xScale *= scale;
        self.yScale *= scale;
    }

//    [self setNeedsDisplay];
}

- (CGFloat)xScale
{
    if (!_xScale) _xScale = 1.0;
    return _xScale;
}

- (void)setXScale:(CGFloat)xScale
{
    _xScale = xScale;
    [self setNeedsDisplay];
}

- (CGFloat)yScale
{
    if (!_yScale) _yScale = 1.0;
    return _yScale;
}

- (void)setYScale:(CGFloat)yScale
{
    _yScale = yScale;
    [self setNeedsDisplay];
}

- (void)setVerticalShift:(CGFloat)verticalShift
{
    _verticalShift = verticalShift;
    self.shifted = YES;
}

//- (void)setHorizontalShift:(CGFloat)horizontalShift
//{
//    _horizontalShift = horizontalShift;
//    self.shifted = YES;
//}

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

// x-axis ticks and labels
//    CGFloat xStep = 50;
    CGFloat xStep = [self tickStepCalculateFor:self.bounds.size.width/self.xScale];
    CGFloat xTicksStart = ceilf(-self.horizontalShift/(xStep*self.xScale))*xStep;
    CGFloat xTicksEnd = floorf((self.bounds.size.width-self.horizontalShift)/(xStep*self.xScale))*xStep;
    NSLog(@"TS%f TE%f vS%f bH%f yS%f ySc%f",xTicksStart,xTicksEnd,self.horizontalShift,self.bounds.size.width,xStep,self.xScale);
    CGContextMoveToPoint(context, self.xScale * (xTicksStart - xStep / 2), -minorTickLength/2);
    CGContextAddLineToPoint(context, self.xScale * (xTicksStart-xStep/2), minorTickLength/2);
    for (float i = xTicksStart; i <= xTicksEnd; i += xStep) {
        i = rintf(i / xStep) * xStep;
        CGContextMoveToPoint(context, self.xScale * i, -majorTickLength/2);
        CGContextAddLineToPoint(context, self.xScale * i, majorTickLength/2);
        CGRect textRect;
        NSString *tickValue;
        if (fabs(i) < 10) {
            tickValue = [NSString stringWithString:[[NSNumber numberWithFloat:i] stringValue]];
        } else {
            tickValue = [NSString stringWithString:[[NSNumber numberWithInt:rint(i)] stringValue]];
        }
        if ([tickValue isEqualToString:@"0"])tickValue = @"";
        textRect.size = [tickValue sizeWithFont:font];
        textRect.origin.x = self.xScale * i - textRect.size.width / 2;
        textRect.origin.y = - 15 - textRect.size.height / 2;
        [tickValue drawInRect:textRect withFont:font];
        textRect = CGRectApplyAffineTransform(textRect, textTransform);
        CGContextMoveToPoint(context, self.xScale * (i+xStep/2), -minorTickLength/2);
        CGContextAddLineToPoint(context, self.xScale * (i+xStep/2), minorTickLength/2);
    }

// y-axis ticks and labels
//    CGFloat yStep = 50;
    CGFloat yStep = [self tickStepCalculateFor:self.bounds.size.height/self.yScale];
    CGFloat yTicksEnd = ceilf(-self.verticalShift/(yStep*self.yScale))*yStep;
    CGFloat yTicksStart = floorf(-(self.verticalShift-self.bounds.size.height)/(yStep*self.yScale))*yStep;
    CGContextMoveToPoint(context, -minorTickLength/2, self.yScale * (yTicksStart - yStep / 2));
    CGContextAddLineToPoint(context, minorTickLength/2, self.yScale * (yTicksStart - yStep / 2));
    for (float i = yTicksStart; i <= yTicksEnd; i += yStep) {
        i = rintf(i / yStep) * yStep;
        CGContextMoveToPoint(context, -majorTickLength/2, self.yScale * i);
        CGContextAddLineToPoint(context, majorTickLength/2, self.yScale * i);
        CGRect textRect;
        textRect = CGRectApplyAffineTransform(textRect, textTransform);
        NSString *tickValue;
        if (fabs(i) < 10) {
            tickValue = [NSString stringWithString:[[NSNumber numberWithFloat:i] stringValue]];
        } else {
            tickValue = [NSString stringWithString:[[NSNumber numberWithInt:rint(i)] stringValue]];
        }
        if ([tickValue isEqualToString:@"0"])tickValue = @"";
        textRect.size = [tickValue sizeWithFont:font];
        textRect.origin.x = 20 - textRect.size.width / 2;
        textRect.origin.y = self.yScale * i - 5 - textRect.size.height / 2;
        [tickValue drawInRect:textRect withFont:font];
        CGContextMoveToPoint(context, -minorTickLength/2, self.yScale * (i + yStep / 2));
        CGContextAddLineToPoint(context, minorTickLength/2, self.yScale * (i + yStep / 2));
    }

    CGContextStrokePath(context);

}

- (CGFloat)tickStepCalculateFor:(CGFloat)axisRange
{
    CGFloat tickStep = 1;
    if (fabs(axisRange) < 1) {
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
        if (charAtIndex >= '2' && charAtIndex <= '5') {
            tickStep = 0.5 * powf(10, -(charPosition-1));
        } else if (charAtIndex >= '6' && charAtIndex <= '9') {
            tickStep = powf(10, -(charPosition-1));
        } else if (charAtIndex == '1') {
            tickStep = powf(10, -(charPosition));
        }
    } else {
        CGFloat powOfTen = [[NSString stringWithFormat:@"%d",lrintf(abs(axisRange))] length];
        NSString *axisRangeString = [NSString stringWithFormat:@"%f",fabs(axisRange)];
        NSLog(@"pOT %f aR %f aRS %@",powOfTen,axisRange,axisRangeString);
        unichar firstChar = [axisRangeString characterAtIndex:0];
        if (firstChar >= '2' && firstChar <= '5') {
            tickStep = 0.5 * powf(10, powOfTen - 1);
        } else if (firstChar >= '6' && firstChar <= '9') {
            tickStep = powf(10, powOfTen - 1);
        } else if (firstChar == '1') {
            tickStep = powf(10, powOfTen - 2);            
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
    self.horizontalShift = 20;

    
//    self.xScale = 1;
    NSArray *yValues = [self.dataSource yValuesForXFromZeroTo:self.bounds.size.width
                                                   withXScale:self.xScale
                                                    andXShift:self.horizontalShift];
    for (int i = 0; i < self.bounds.size.width; i++) {
        currPoint.y = [[yValues objectAtIndex:i] floatValue];
        if (currPoint.y > maxValue) maxValue = currPoint.y;
        if (currPoint.y < minValue) minValue = currPoint.y;
    }
    if (!self.scaleChanged) {
        self.xyScaleRelation = self.bounds.size.height/(minValue - maxValue);
        self.scale = self.bounds.size.height/(minValue - maxValue);
        NSLog(@"scale no changed");
    }
    if (!self.shifted) {
        self.verticalShift = self.bounds.size.height-(minValue * self.yScale);        
        NSLog(@"and no shifted");
    }
//    self.verticalShift = 330;

    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];
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
