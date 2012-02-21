//
//  MoneyViewController.h
//  Money
//
//  Created by Andrea Barbon on 20/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pig.h"
#import "Movement.h"

#define SCREEN_W 768

@interface MoneyViewController : UIViewController {
 
    NSDateFormatter *df;

}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Pig *currentPig;

-(NSArray*)fetchMovements;
-(void)saveMovement:(Movement*)movement;
-(NSArray*)fetchPigs;

@end
