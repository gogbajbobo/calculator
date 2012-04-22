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
}

- (NSArray *)yValues:(int)xMaxValue
{
    float scale = 0.1;
    NSMutableArray *yArray = [NSMutableArray array];
    for (int i = 0; i <= xMaxValue; i++) {
        [yArray addObject:[NSNumber numberWithDouble:[self.dataSourceForGraph yValueFor:i*scale]]];
    }
    return yArray;
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
