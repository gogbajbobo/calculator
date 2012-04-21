//
//  GraphViewController.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/17/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController () <GraphViewDataSource, DescriptionViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet DescriptionView *descriptionView;

@end

@implementation GraphViewController

@synthesize XYvalues = _XYvalues;
@synthesize dataSourceForGraph = _dataSourceForGraph;
@synthesize dataSourceForDescription = _dataSourceForDescription;
@synthesize graphView = _graphView;
@synthesize descriptionView = _descriptionView;

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
}

- (void)setDescriptionView:(DescriptionView *)descriptionView
{
    _descriptionView = descriptionView;
    self.descriptionView.descriptionDataSource = self;
}

- (NSArray *)yValues:(int)xMaxValue
{
    return [self.dataSourceForGraph yValues:xMaxValue];    
}

- (NSString *)descriptionText
{
    NSLog(@"GVC%@",[self.dataSourceForDescription descriptionText]);
    return [self.dataSourceForDescription descriptionText];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end
