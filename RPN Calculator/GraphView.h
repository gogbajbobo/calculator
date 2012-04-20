//
//  GraphView.h
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/18/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDataSource

- (NSArray *)xValues;
- (NSArray *)yValues;

@end

@interface GraphView : UIView

@property (nonatomic,weak) IBOutlet id <GraphViewDataSource> dataSource;

@end
