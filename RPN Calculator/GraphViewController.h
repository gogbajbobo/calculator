//
//  GraphViewController.h
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/17/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@protocol DataTransmit <NSObject>

- (float)yValueFor:(int)xValue;

@end


@interface GraphViewController : UIViewController

@property (nonatomic,weak) IBOutlet NSDictionary *XYvalues;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet id <DataTransmit> dataSourceForGraph;


@end
