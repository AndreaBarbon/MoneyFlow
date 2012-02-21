//
//  EditMovementViewController.h
//  Money
//
//  Created by Andrea Barbon on 11/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movement.h"
#import "Category.h"
#import "Link.h"
#import "Pig.h"

@protocol ModalProtocol

-(void)saveMovement:(Movement*)movement;

@end

@interface EditMovementViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate> {
    
    float value;
    NSArray *numbers;
    NSArray *numbersCent;
    
    IBOutlet UIView *bookmarksView;
    IBOutlet UIButton *okBtn;
    IBOutlet UITableView *bookmarksTableView;
    IBOutlet UISwitch *linkSwitch;
    IBOutlet UIPickerView *linkPicker;
    IBOutlet UILabel *linkLabel;
    
    
    NSMutableArray *bookmarks;
    Category *category;
}

@property (nonatomic, assign) id<ModalProtocol> delegate;

@property (nonatomic, retain) Movement *movement;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSMutableArray *pigs;
@property (nonatomic) bool newRecord;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UISwitch *bookmarkSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *fixedSwitch;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UIPickerView *valuePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *categoryPicker;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

-(void)resetPickers;
-(NSString*)stringForValue:(float)v;
-(NSArray*)fetchBookmarksWithFlow:(NSString*)f;
-(NSArray*)fetchCategories;
-(NSArray*)fetchPigs;

-(int)indexOfCategory:(Category*)cat;
-(int)indexOfPig:(Pig*)pig;
-(void)setValue:(float)v inPicker:(UIPickerView*)picker;
-(void)deleteBookmarkAtIndex:(int)r;
-(IBAction)link:(id)sender;



@end
