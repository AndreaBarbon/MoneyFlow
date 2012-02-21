//
//  MainViewController.h
//  Money
//
//  Created by Andrea Barbon on 06/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Pig.h"
#import "Movement.h"
#import "Category.h"
#import "EditMovementViewController.h"
#import "MovementCell.h"
#import "GraphViewController.h"
#import "ChoosePig.h"
#import "MoneyViewController.h"

#define LIMIT 10

@interface MainViewController : MoneyViewController <choosePigDelegate, FlipsideViewControllerDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate, ModalProtocol> {
        
    float value;
    NSDate *date;
    NSString *flow;
    NSArray *numbers;
    NSArray *numbersCent;
    ChoosePig *choose;

    IBOutlet UITableView *movementsTableView;
    IBOutlet EditMovementViewController *movementEditor;
    IBOutlet UISegmentedControl *plusMinus;
    IBOutlet UINavigationBar *navBar;
    UIPopoverController *choosePigPopoverController;
    
    Movement *currentMovement;
    bool newMovement;
    
    NSMutableArray *movements;
    NSMutableArray *pigs;
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (nonatomic, retain) IBOutlet UILabel *display;
@property (nonatomic, retain) IBOutlet UIView *equalView;
@property (nonatomic, retain) IBOutlet UIPickerView *valuePickerEqual;

-(IBAction)move:(id)sender;
-(IBAction)ok:(id)sender;
-(IBAction)cancel:(id)sender;

-(void)resetPickers;
-(void)createStandardPigsIfNeeded;
-(void)createStandardCategoriesIfNeeded;
-(void)switchToPigNamed:(NSString*)name;
-(void)updatePig:(Pig*)pig;
-(Pig*)findPigWithName:(NSString*)name;


-(void)equalize;
-(NSArray*)fetchMovements;
-(NSArray*)fetchPigs;
-(void)refresh;
-(void)setValue:(float)v inPicker:(UIPickerView*)picker;
-(void)deleteMovementAtIndex:(int)r;
-(Movement*)newMovement;

-(void)updateDisplayWithValue:(float)v;

@end
