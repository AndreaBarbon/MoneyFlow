//
//  ChoosePig.h
//  Money
//
//  Created by Andrea Barbon on 19/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pig.h"
#import "MoneyViewController.h"

@class ChoosePig;

@protocol choosePigDelegate
- (void)choosePigDidFinish:(ChoosePig *)controller;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@interface ChoosePig : MoneyViewController <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    
    NSMutableArray *pigs;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *nameField;
    IBOutlet UIView *nameFieldBkg;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
    Pig *editingPig;
    
}

@property (weak, nonatomic) IBOutlet id <choosePigDelegate> delegate;

-(void)scrollToPig:(Pig*)pig;
-(IBAction)add:(id)sender;
-(Pig*)newPig;
-(void)refresh;
-(void)showDeleteAllert;

@end
