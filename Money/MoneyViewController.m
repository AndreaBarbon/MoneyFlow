//
//  MoneyViewController.m
//  Money
//
//  Created by Andrea Barbon on 20/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "MoneyViewController.h"

@implementation MoneyViewController

@synthesize managedObjectContext, currentPig;

-(void)saveMovement:(Movement*)movement {
    
	NSManagedObjectContext *context = [self managedObjectContext];
    
	//Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
	} else {
        NSLog(@"Saved: %@, %@%.2f € in date %@ in pig: %@", movement.name, movement.flow, [movement.value floatValue], [df stringFromDate:movement.date], movement.pig.name);
    }
    
}

-(NSArray*)fetchMovements {
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movement" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pig.name == %@", currentPig.name];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if ([array count] == 0) {
        NSLog(@"Error = %@", error);
    }
    
    return array;
    
}


-(NSArray*)fetchPigs {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pig" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if ([array count] == 0) {
        NSLog(@"Error = %@", error);
    }
    
    return array;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
