//
//  GraphViewController.m
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/17/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController ()
@property (nonatomic, weak) IBOutlet GraphView *graphView;

@end

@implementation GraphViewController

@synthesize XYvalues = _XYvalues;
@synthesize graphView = _graphView;

- (void)setXYvalues:(NSDictionary *)XYvalues
{
    if (XYvalues != _XYvalues) {
        _XYvalues = XYvalues;
        [self.graphView setXYvalues:XYvalues];
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
    [self.graphView setXYvalues:self.XYvalues];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
