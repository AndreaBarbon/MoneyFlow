//
//  NewCategory.m
//  Money
//
//  Created by Andrea Barbon on 10/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//


#import "NewCategory.h"

@implementation NewCategory
@synthesize managedObjectContext, category;

- (void)viewDidLoad
{
    [super viewDidLoad];

    selectedColor = [category.color intValue];
    UIColors = COLORI;
    
    nameField.text = self.title;
    colors = [NSArray arrayWithObjects:@"Blu", @"Giallo", @"Rosso", @"Verde", @"Azzurrino", @"Arancione", @"Grigio scuro", @"Grigio chiaro", @"Viola", @"Marrone", nil];
    
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [colors count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    int r = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [colors objectAtIndex:r];
    if (selectedColor == r) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(210, 5, 40, 30)];    
    VIEW_STYLIZE
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    UIColor *color = [UIColors objectAtIndex:r];
    view.backgroundColor = color;
    [cell addSubview:view];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int r = indexPath.row;
    
    selectedColor = r;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    
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

-(IBAction)ok:(id)sender {
    
    if (![nameField.text isEqualToString:@""]) {
        category.name = nameField.text;
        category.color = [NSNumber numberWithInt:selectedColor];

        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
        } else {
            NSLog(@"Categoria salvata!");
        }
        
        [[self navigationController] popViewControllerAnimated:TRUE];
        
    } else {
        //implementare errore
    }
}

#pragma mark - View lifecycle

-(void)viewWillDisappear:(BOOL)animated {
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
