//
//  FlipsideViewController.m
//  Money
//
//  Created by Andrea Barbon on 06/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize managedObjectContext;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColors = COLORI
    
    tableview.separatorColor = [UIColor clearColor];
    tableview.backgroundColor = [UIColor colorWithRed:247.f/255.f green:247.f/255.f blue:247.f/255.f alpha:1];
    
    categories = [[NSMutableArray alloc] init];
    NSLog(@"Fetching...");

	// Do any additional setup after loading the view, typically from a nib.
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(IBAction)add:(id)sender {
    
    //Add a category
    
    NewCategory *controller = [[NewCategory alloc] init];
    controller.title = @"Nuova Categoria";
    controller.managedObjectContext = self.managedObjectContext;
    controller.category = [NSEntityDescription
     insertNewObjectForEntityForName:@"Category" 
     inManagedObjectContext:self.managedObjectContext];

    [self.navigationController pushViewController:controller animated:YES];

    
    
}


#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    categories = [NSMutableArray arrayWithArray:[self fetchCategories]];
    return [categories count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    int r = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    Category *cat = [categories objectAtIndex:r];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 75, 30)];    
    VIEW_STYLIZE
    UIColor *color = [UIColors objectAtIndex:[cat.color intValue]];
    view.backgroundColor = color;
    
    cell.accessoryView = view;
    
    cell.textLabel.text = cat.name;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int r = indexPath.row;
    
    NewCategory *controller = [[NewCategory alloc] init];
    controller.title = [[categories objectAtIndex:r] name];
    controller.managedObjectContext = self.managedObjectContext;
    controller.category = [categories objectAtIndex:r];
    
    
   [self.navigationController pushViewController:controller animated:YES];
        
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return UITableViewCellEditingStyleDelete;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [tableview setEditing:editing animated:YES];
}

-(void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //first remove the entry from the db
        [self deleteCategoryAtIndex:indexPath.row];
        
        //then remove the row
        [categories removeObjectAtIndex:indexPath.row];
        [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(void)deleteCategoryAtIndex:(int)r {
    
    [self.managedObjectContext deleteObject:[categories objectAtIndex:r]];
    [self.managedObjectContext save:nil];
}

-(NSArray*)fetchCategories {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if ([array count] == 0) {
        NSLog(@"Error = %@", error);
    }
    
    return array;
}



- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableview reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
