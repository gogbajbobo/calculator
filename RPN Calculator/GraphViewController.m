//
//  GraphViewController.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/17/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic) CGPoint touchPoint;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;


@end

@implementation GraphViewController
@synthesize description = _description;
@synthesize dataSourceForGraph = _dataSourceForGraph;
@synthesize XYvalues = _XYvalues;
@synthesize graphView = _graphView;
@synthesize touchPoint = _touchPoint;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;


- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}


- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
    self.description.text = [self.dataSourceForGraph descriptionText];
    self.description.backgroundColor = [UIColor whiteColor];
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTap:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tripleTap];
}

- (NSArray *)yValuesForXFromZeroTo:(int)xMaxValue
                        withXScale:(CGFloat)xScale
                         andXShift:(CGFloat)xShift
{
    NSMutableArray *yArray = [NSMutableArray array];
    for (int i = 0; i <= xMaxValue; i++) {
        [yArray addObject:[NSNumber numberWithDouble:[self.dataSourceForGraph yValueFor:(i-xShift)/xScale]]];
    }
    return yArray;
}

- (void)tripleTap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || 
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint location = [gesture locationInView:self.graphView];
        self.graphView.verticalShift = location.y;
        self.graphView.horizontalShift = location.x;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || 
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphView];
        self.graphView.verticalShift += translation.y;
        self.graphView.horizontalShift += translation.x;
        [gesture setTranslation:CGPointZero inView:self.graphView];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || 
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint currentTouchPoint = [gesture locationOfTouch:0 inView:self.graphView];
        CGFloat xDiff = fabs(currentTouchPoint.x - self.touchPoint.x);
        CGFloat yDiff = fabs(currentTouchPoint.y - self.touchPoint.y);
        if (fabs(xDiff/yDiff) < 1) {
            self.graphView.yScale *= gesture.scale;
        } else if (fabs(yDiff/xDiff) < 1) {
            self.graphView.xScale *= gesture.scale;
        } else {
            [self.graphView changeScale:gesture.scale];
        }
        gesture.scale = 1;
        self.touchPoint = currentTouchPoint;
    }
}



// ________________________________________________________________________



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end
