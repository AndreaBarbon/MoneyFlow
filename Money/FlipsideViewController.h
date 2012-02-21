//
//  FlipsideViewController.h
//  Money
//
//  Created by Andrea Barbon on 06/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Category.h"
#import "NewCategory.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *categories;
    IBOutlet UITableView *tableview;
    NSArray *UIColors;

}

@property (weak, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)done:(id)sender;
-(IBAction)add:(id)sender;

-(void)deleteCategoryAtIndex:(int)r;
-(NSArray*)fetchCategories;


@end

#define PCColorBlue [UIColor colorWithRed:0.0 green:153/255.0 blue:204/255.0 alpha:1.0]
#define PCColorGreen [UIColor colorWithRed:153/255.0 green:204/255.0 blue:51/255.0 alpha:1.0]
#define PCColorOrange [UIColor colorWithRed:1.0 green:153/255.0 blue:51/255.0 alpha:1.0]
#define PCColorRed [UIColor colorWithRed:1.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define PCColorYellow [UIColor colorWithRed:1.0 green:220/255.0 blue:0.0 alpha:1.0]
#define PCColorDefault [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]
