//
//  GraphViewController.h
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/17/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController

@property (nonatomic,weak) IBOutlet NSDictionary *XYvalues;
@property (nonatomic,weak) IBOutlet id <GraphViewDataSource> dataSourceForGraph;

@end
