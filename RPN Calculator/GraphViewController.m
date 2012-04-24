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

@end

@implementation GraphViewController
@synthesize description = _description;
@synthesize dataSourceForGraph = _dataSourceForGraph;
@synthesize XYvalues = _XYvalues;
@synthesize graphView = _graphView;


- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
    self.description.text = [self.dataSourceForGraph descriptionText];
    self.description.backgroundColor = [UIColor whiteColor];
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
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


- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || 
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.graphView.scale *= gesture.scale;
//        NSLog(@"gV.scale %f",self.graphView.scale);
        gesture.scale = 1;
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
