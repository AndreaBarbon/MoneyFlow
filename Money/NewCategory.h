//
//  NewCategory.h
//  Money
//
//  Created by Andrea Barbon on 10/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Category.h"

@interface NewCategory : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *tableview;
    IBOutlet UITextField *nameField;
    int selectedColor;
    NSArray *colors;
    NSArray *UIColors;
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Category *category;


@end

#define BLU [UIColor blueColor]
#define GIALLO [UIColor colorWithRed:1.0 green:220/255.0 blue:0.0 alpha:1.0]
#define ROSSO [UIColor colorWithRed:1.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define VERDE [UIColor colorWithRed:153/255.0 green:204/255.0 blue:51/255.0 alpha:1.0]
#define AZZURRINO [UIColor colorWithRed: 66.0/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:1]
#define ARANCIONE [UIColor colorWithRed:1.0 green:153/255.0 blue:51/255.0 alpha:1.0]
#define GRIGIO [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]



#define COLORI [NSArray arrayWithObjects:BLU, GIALLO, ROSSO, VERDE, AZZURRINO, ARANCIONE, GRIGIO, [UIColor lightGrayColor], [UIColor purpleColor], [UIColor brownColor], [UIColor magentaColor], nil];

#define VIEW_STYLIZE view.layer.cornerRadius = 10;      view.layer.masksToBounds = 1;       view.layer.borderWidth = 1;     view.layer.borderColor = [[UIColor grayColor] CGColor];

