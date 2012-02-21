//
//  PieChartController.m
//  Money
//
//  Created by Andrea Barbon on 12/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "PieChartController.h"

@implementation PieChartController

@synthesize categories, movements, flow;



#pragma mark fractalsoft

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    df = [[NSDateFormatter alloc] init];    [df setDateFormat:@"MMMM yyyy"];
    [df setLocale:[NSLocale currentLocale]]; 
    
    date = [NSDate date];
    date = [self shiftDate:date ofOneMonthInDirection:1];
    date = [self shiftDate:date ofOneMonthInDirection:-1];
    
    UIColors = COLORI
    
    filteredCategories = [[NSMutableArray alloc] initWithCapacity:[categories count]];
    pieCharts = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i=0; i<3; i++) {
        PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(i*SCREEN_W,10,SCREEN_W,SCREEN_W)];
        [pieCharts addObject:pieChart];
    }
    
    //Order and filter categories
    for (int i=0; i<3; i++) {
        [self filterCategoriesOfPieNumber:i];    
        [self showPieChartNumber:i];
    }
    
    scrollView.contentOffset = CGPointMake(SCREEN_W, 0);


    
    
    //Add the info box
    box.frame = CGRectMake(250, 560, 470, 150);
    
    box.layer.cornerRadius = 10;
    box.layer.masksToBounds = 1;
    
    [self.view bringSubviewToFront:box];
    
    [flowSwitch setSelectedSegmentIndex:1];
    monthLabel.text = [[df stringFromDate:date] capitalizedString];
       
}

-(void)showPieChartNumber:(int)n {
    
    if (n>2 || n<0)
        return;
    
    int height = MAX(80*[filteredCategories count]+20, SCREEN_W);
    int width = SCREEN_W;
    scrollView.contentSize = CGSizeMake(SCREEN_W*3, height);    

    
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(n*SCREEN_W,10,SCREEN_W,SCREEN_W)];        
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, pieChart.frame.size.width,pieChart.frame.size.height);
    
    //pieChart.backgroundColor = [UIColor blueColor];
    
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    pieChart.showArrow = 0;
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:35];     
    
    NSMutableArray *components = [NSMutableArray array];
    for (Category *cat in filteredCategories) 
    {
        if ([cat.total floatValue] != 0) 
        {
            PCPieComponent *component = [PCPieComponent pieComponentWithTitle:cat.name value:[cat.total floatValue]];
            [components addObject:component];
            [component setColour:[UIColors objectAtIndex:[cat.color intValue]]];
        }
    }
    [pieChart setComponents:components];
    
    [pieCharts replaceObjectAtIndex:n withObject:pieChart];
    
    [scrollView addSubview:pieChart];
    
    if (n==1) {
        totalLabel.text = [NSString stringWithFormat:@"%.0f €", total];
    }
    
}

-(void)filterCategoriesOfPieNumber:(int)n {
    
    total = 0;
    
    int m = n-1;

    
    filteredCategories = [NSMutableArray arrayWithArray:categories];
    
    NSLog(@"Filtering, flow = %@", flow);
    
    NSMutableArray *null = [[NSMutableArray alloc] initWithCapacity:[filteredCategories count]];
    
    

    NSDate *dateIn = [self shiftDate:date ofOneMonthInDirection:m];
    NSDate *dateOut = [self shiftDate:dateIn ofOneMonthInDirection:1];
    
    for (Category *cat in filteredCategories) {
        
        float tot = 0;
        for (Movement *mov in cat.movements) {
            if ([mov.flow isEqualToString:flow] && mov.link==nil 
                && [mov.date timeIntervalSinceDate:dateIn]>=0
                && [mov.date timeIntervalSinceDate:dateOut]<0)
                tot += [mov.value floatValue];
        }        
        
        if (tot == 0) 
            [null addObject:cat];
        else
            cat.total = [NSNumber numberWithFloat:tot];
        
        total += tot;
    }
    
    [filteredCategories removeObjectsInArray:null];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compare:)];
    filteredCategories = [NSMutableArray arrayWithArray:[filteredCategories sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
    
}

-(IBAction)switchFlow {
        
    if (flowSwitch.selectedSegmentIndex == 0)
        flow = @"+";
    else
        flow = @"-";
    
    [self reload];
    
}

-(NSDate*)shiftDate:(NSDate*)date_ ofOneMonthInDirection:(int)direction {
    
    if (direction==0)
        return date_;
    
    int day = 60*60*24;
        
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date_];
    
    int mese = comps.month;
    
    while (comps.month == mese) {
        date_ = [date_ dateByAddingTimeInterval:direction*day];
        comps = [gregorian components:unitFlags fromDate:date_];
    }
    
    while (comps.day != 1) {
        date_ = [date_ dateByAddingTimeInterval:-day];
        comps = [gregorian components:unitFlags fromDate:date_];
    }
        
    while (comps.hour != 0) {
        date_ = [date_ dateByAddingTimeInterval:-60*60];
        comps = [gregorian components:unitFlags fromDate:date_];
    }
    
    while (comps.minute != 0) {
        date_ = [date_ dateByAddingTimeInterval:-60];
        comps = [gregorian components:unitFlags fromDate:date_];
    }
    
    while (comps.second != 0) {
        date_ = [date_ dateByAddingTimeInterval:-1];
        comps = [gregorian components:unitFlags fromDate:date_];
    }
    
    return date_;
}

-(void)reload {

    monthLabel.text = [[df stringFromDate:date] capitalizedString];

    for (int i=0; i<3; i++) {
        [self filterCategoriesOfPieNumber:i];
        [[pieCharts objectAtIndex:i] removeFromSuperview];
        [self showPieChartNumber:i];
    }
    
    [self.view bringSubviewToFront:box];


}


#pragma mark scrollView delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_ {
    
    int direction;

    //NSLog(@"Content offset = %.2f", scrollView.contentOffset.x);
    
    if (scrollView.contentOffset.x <2*SCREEN_W && scrollView.contentOffset.x >=SCREEN_W) 
        return;

    
    if (scrollView.contentOffset.x >= 2*SCREEN_W) {
        NSLog(@"Destra");
        direction = 1;
    } else {
        NSLog(@"Sinistra");
        direction = -1;
    }
    
    date = [self shiftDate:date ofOneMonthInDirection:direction];
    scrollView_.contentOffset = CGPointMake(SCREEN_W, 0);    
    [self reload];

}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
