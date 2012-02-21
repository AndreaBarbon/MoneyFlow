//
//  GraphViewController.h
//  Money
//
//  Created by Andrea Barbon on 16/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartController.h"

@interface GraphViewController : UIViewController {

    IBOutlet UIScrollView *scrollView;
    PieChartController *pieController;

}

@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSArray *movements;

-(IBAction)close:(id)sender;


@end
