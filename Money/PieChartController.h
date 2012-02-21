//
//  PieChartController.h
//  Money
//
//  Created by Andrea Barbon on 12/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPieChart.h"
#import "Category.h"
#import "NewCategory.h"
#import "Movement.h"
#import <QuartzCore/QuartzCore.h>

#define SCREEN_W 768


@interface PieChartController : UIViewController <UIScrollViewDelegate> {
    
    NSArray *UIColors;
    IBOutlet UIView *box;
    IBOutlet UILabel *monthLabel;
    IBOutlet UILabel *totalLabel;
    IBOutlet UISegmentedControl *flowSwitch;
    IBOutlet UIScrollView *scrollView;
    
    NSMutableArray *filteredCategories;
    
    NSMutableArray *pieCharts;
    
    NSDateFormatter *df;
    NSDate *date;
    float total;
    
}

@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSArray *movements;
@property (nonatomic, retain) NSString *flow;

-(IBAction)switchFlow;
-(void)reload;
-(void)filterCategoriesOfPieNumber:(int)n;
-(void)showPieChartNumber:(int)n;
-(NSDate*)shiftDate:(NSDate*)date_ ofOneMonthInDirection:(int)direction;

@end
