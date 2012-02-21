//
//  GraphViewController.m
//  Money
//
//  Created by Andrea Barbon on 16/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "GraphViewController.h"

@implementation GraphViewController

@synthesize categories, movements;


#pragma mark fractalsoft

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pieController = [[PieChartController alloc] init];
    pieController.categories = self.categories;
    pieController.flow = @"-";
    
    [scrollView addSubview:pieController.view];
    
    

    float height = pieController.view.frame.size.height;
    
    //Secondo grafico
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, SCREEN_W, 600)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view];
    
    //Terzo grafico
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, height+600, SCREEN_W, 600)];
    view2.backgroundColor = [UIColor blueColor];
    [scrollView addSubview:view2];
    
    scrollView.contentSize = CGSizeMake(SCREEN_W, 1200+height);
     
    
    
}


-(IBAction)close:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
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
