//
//  DescriptionView.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/21/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import "DescriptionView.h"

@implementation DescriptionView

@synthesize descriptionDataSource = _descriptionDataSource;

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
    CGContextRef descriptonContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(descriptonContext, 1.0);
    [[UIColor redColor] setStroke];

    CGAffineTransform textTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    textTransform = CGAffineTransformTranslate(textTransform, 5, 5-self.bounds.size.height);
    
    UIGraphicsPushContext(descriptonContext);
    CGContextBeginPath(descriptonContext);
    
    NSString *descriptionText = [self.descriptionDataSource descriptionText];
    if (!descriptionText) descriptionText = @"";
    const char *textString = [descriptionText UTF8String];
    CGContextSetTextDrawingMode(descriptonContext, kCGTextFill);
    CGContextSelectFont(descriptonContext, "Helvetica", 14, kCGEncodingMacRoman);
    CGContextSetTextMatrix(descriptonContext, textTransform);
    CGContextShowText(descriptonContext, textString, strlen(textString));
//    CGContextMoveToPoint(descriptonContext, self.bounds.origin.x, self.bounds.origin.y);
//    CGContextAddLineToPoint(descriptonContext, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(descriptonContext);
    UIGraphicsPopContext();


}


@end
