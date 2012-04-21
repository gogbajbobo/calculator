//
//  DescriptionView.h
//  RPN Calculator
//
//  Created by Григорьев Максим on 4/21/12.
//  Copyright (c) 2012 IMT RAS, ИПТМ РАН. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DescriptionViewDataSource

- (NSString *)descriptionText;

@end


@interface DescriptionView : UIView
@property (nonatomic,weak) IBOutlet id <DescriptionViewDataSource> descriptionDataSource;

@end
