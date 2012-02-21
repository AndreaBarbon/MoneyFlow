//
//  MainViewController.m
//  Money
//
//  Created by Andrea Barbon on 06/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize flipsidePopoverController = _flipsidePopoverController;

@synthesize display, equalView, valuePickerEqual;


#pragma mark fractalsoft

-(void)viewDidLoad {
    [super viewDidLoad];
    
    movements = [[NSMutableArray alloc] initWithArray:[self fetchMovements]];
    pigs = [[NSMutableArray alloc] initWithArray:[self fetchPigs]];

    [self createStandardPigsIfNeeded];
    [self createStandardCategoriesIfNeeded];
    [self switchToPigNamed:@"Portafoglio"];
    date = [NSDate date];
    
    [self updateDisplayWithValue:[self.currentPig.value floatValue]];
    
    
    
    choose = [[ChoosePig alloc] init];
    choose.delegate = self;
    choose.view.frame = CGRectMake(0, 280, choose.view.frame.size.width, choose.view.frame.size.height);
    [self.view addSubview:choose.view];
    [self.view bringSubviewToFront:equalView];
    [choose scrollToPig:self.currentPig];
    
    
    movementEditor = [[EditMovementViewController alloc] init];
    movementEditor.delegate = self;
    movementEditor.managedObjectContext = self.managedObjectContext;
    movementEditor.view.frame = CGRectMake(0, 262, 768, 742);
    
    df = [[NSDateFormatter alloc] init];    [df setDateFormat:@"dd MMMM yyyy"];
    [df setLocale:[NSLocale currentLocale]];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0; i<10; i++) {[array addObject:[NSString stringWithFormat:@"%d", i]];}
    numbers = [NSArray arrayWithArray:array];
    
    NSMutableArray *arrayCent = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i=0; i<20; i++) {[arrayCent addObject:[NSString stringWithFormat:@"%d", i*5]];}
    numbersCent = [NSArray arrayWithArray:arrayCent];
    

	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)plot:(id)sender {
    
    GraphViewController *graphController = [[GraphViewController alloc] init];
    graphController.categories = movementEditor.categories;
    graphController.movements = movements;
        
    [self presentModalViewController:graphController animated:TRUE];
}

-(IBAction)ok:(id)sender{
    
    if ([flow isEqualToString:@"="]) {
        
        [self equalize];
        NSLog(@"Equalized");
        equalView.hidden = 1;

    } else {
        
        [self saveMovement:currentMovement];
    }
    
    [self refresh];
    
}

-(IBAction)cancel:(id)sender {
    
    if (newMovement) {
        [self.managedObjectContext deleteObject:currentMovement];
    }
    
    equalView.hidden = 1;
    newMovement = 0;
}

-(void)resetPickers {
    
    value = 0;
    
    for (int i=0; i<4; i++) {
        [valuePickerEqual selectRow:0 inComponent:i animated:0];
    }
    
}

-(IBAction)move:(id)sender {
 
    UIButton *btn = (UIButton*)sender;
    [self resetPickers];
    flow = btn.titleLabel.text;

    
    if ([flow isEqualToString:@"+"] || [flow isEqualToString:@"-"]) {

        currentMovement = [self newMovement];
        currentMovement.pig = self.currentPig;
        currentMovement.flow = flow;
        movementEditor.movement = currentMovement;

        movementEditor.newRecord = 1;
        movementEditor.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentModalViewController:movementEditor animated:YES];
        //movementEditor.view.superview.frame = CGRectMake(0, 262, 768, 750);
                
    } else {
            
        value = [display.text floatValue];
        [self setValue:[display.text floatValue] inPicker:valuePickerEqual];
        
        if (value>0)
            plusMinus.selectedSegmentIndex = 0;
        else
            plusMinus.selectedSegmentIndex = 1;
        
        equalView.hidden = 0;
    }
    
}

-(void)updateDisplayWithValue:(float)v {

    display.text = [NSString stringWithFormat:@"%0.2f", v];
        
}

-(void)refresh {
    
    movements = [NSMutableArray arrayWithArray:[self fetchMovements]];
    [movementsTableView reloadData];
    [self updatePig:self.currentPig];
    navBar.topItem.title = self.currentPig.name;
    
}

-(void)setValue:(float)v inPicker:(UIPickerView*)picker {
    
    NSString *s = [movementEditor stringForValue:v];
    
    for (int j=0; j<3; j++) {
        int i = [[NSString stringWithFormat:@"%c", [s characterAtIndex:j]] intValue];
        [picker selectRow:i inComponent:j animated:0];
    }
    
    int i = [[NSString stringWithFormat:@"%c%c", [s characterAtIndex:4], [s characterAtIndex:5]] intValue];
    [picker selectRow:i/5 inComponent:3 animated:0];
    
}



#pragma mark CoreData 

-(void)equalize {
    
    float oldValue = [display.text floatValue];
    
    int i = plusMinus.selectedSegmentIndex;
    value = (1-2*i)*ABS(value);
    
    
    if (value < oldValue) {
        flow = @"-";
        value = oldValue - value;
    }
    else {
        flow = @"+";
        value = value - oldValue;
    }
    
    currentMovement = [self newMovement];
    currentMovement.name = @"Equalize";
    currentMovement.date = [NSDate date];
    currentMovement.flow = flow;
    currentMovement.bookmark = [NSNumber numberWithInt:0];
    currentMovement.value = [NSNumber numberWithFloat:value];
    currentMovement.pig = self.currentPig;

    [self saveMovement:currentMovement];
    
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

-(NSArray*)fetchMovements {
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movement" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pig.name == %@", self.currentPig.name];
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

-(NSArray*)fetchMovementsBetweenDateIn:(NSDate*)dateIN dateOut:(NSDate*)dateOUT {
   
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *managedObjectModel = [[context persistentStoreCoordinator] managedObjectModel];
    NSError *error = nil;
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:dateIN, dateOUT, nil] 
                                                     forKeys:[NSArray arrayWithObjects:@"DATE_IN", @"DATE_OUT", nil]];
    
    NSFetchRequest *req = [managedObjectModel fetchRequestFromTemplateWithName:@"betweenDates" substitutionVariables:subs];
    
    NSArray *results = [[self managedObjectContext] executeFetchRequest:req error:&error];
    NSLog(@"Found %d record.", [results count]);
    
    return results;
    
}

-(void)deleteMovementAtIndex:(int)r {
    
    NSManagedObjectContext *context = [self managedObjectContext];

    Movement *mov = [movements objectAtIndex:r];
    Link *link = mov.link;
    
    if (link != nil) {
        [context deleteObject:link.movementIn];
        [context deleteObject:link.movementOut];
        [context deleteObject:link];
    } else {
        [context deleteObject:mov];
    }
    
    //Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante la eliminazione: %@", [error localizedDescription]);
	} else {
        NSLog(@"Movement deleted!");
    }
    
}

-(Movement*)newMovement {
    
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"Movement" 
            inManagedObjectContext:self.managedObjectContext];
}

-(Pig*)findPigWithName:(NSString*)name {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //Save pig's value
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pig" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.currentPig.name];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    return [[context executeFetchRequest:request error:&error] lastObject];
    
}

-(void)updatePig:(Pig*)pig {
    
    float total = 0;
    for (Movement *mov in movements) {
        if ([mov.flow isEqualToString:@"+"])
            total += [mov.value floatValue];
        else
            total -= [mov.value floatValue];
    }

    NSManagedObjectContext *context = [self managedObjectContext];    
    pig.value = [NSNumber numberWithFloat:total];
    
    
    //Effettuiamo il salvataggio gestendo eventuali errori
    NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
	} else {
        NSLog(@"Saved value: %.2f € for pig: %@", [pig.value floatValue], pig.name);
        [self updateDisplayWithValue:total];        
    }
    
}

-(void)addPigWithName:(NSString*)name {
    
	NSManagedObjectContext *context = [self managedObjectContext];
    
    Movement *pig = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Pig" 
                     inManagedObjectContext:context];
    
    pig.name = name;
    
	//Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
	} else {
        NSLog(@"Created pig named: %@",name);
    }
    
}

-(void)addCategoryWithName:(NSString*)name {
    
	NSManagedObjectContext *context = [self managedObjectContext];
    
    Movement *pig = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Category" 
                     inManagedObjectContext:context];
    
    pig.name = name;
    
	//Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
	} else {
        NSLog(@"Created category named: %@",name);
    }
    
}

-(void)createStandardPigsIfNeeded {
    
	NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"Pig" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
    
    if ([pigs count]<2) {
        [self addPigWithName:@"Portafoglio"];
        [self addPigWithName:@"Conto corrente"];
    }
    
    NSLog(@"Pigs created");

    
}

-(void)createStandardCategoriesIfNeeded {
    
	NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"Category" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
    
	NSError *error;
	NSArray *cats = [context executeFetchRequest:fetchRequest error:&error];
    if ([cats count]<4) {
        [self addCategoryWithName:@"Trasporto pubblico"];
        [self addCategoryWithName:@"Mangiare fuori"];
        [self addCategoryWithName:@"Spesa"];
        [self addCategoryWithName:@"Università"];
        [self addCategoryWithName:@"Vestiti"];
        [self addCategoryWithName:@"Party"];
        [self addCategoryWithName:@"Erba"];
    }
    
    NSLog(@"Categories created");
    
}

-(void)switchToPigNamed:(NSString*)name {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"Pig" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
    
    for (Pig *pig in pigs) {
        if ([pig.name isEqualToString:name]) {
            self.currentPig = pig;
        }
    }
    
    [self refresh];

}

-(void)saveMovement:(Movement*)movement {
    
	NSManagedObjectContext *context = [self managedObjectContext];
    
	//Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
	} else {
        NSLog(@"Saved: %@, %@%.2f € in date %@ in pig: %@", movement.name, flow, value, [df stringFromDate:date], movement.pig.name);
    }
    
    [self refresh];
    [self updatePig:self.currentPig];
    
}



#pragma mark PickerDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        
    NSLog(@"Selected");
    
    NSString *s = [movementEditor stringForValue:value];
    
    if (component<3) {
        NSRange r = NSMakeRange(component, 1);
        s = [s stringByReplacingCharactersInRange:r withString:[numbers objectAtIndex:row]];
    } else {
        NSRange r = NSMakeRange(component+1, 2);
        NSString *t = [numbersCent objectAtIndex:row];
        if ([t isEqualToString:@"5"]) {
            t = [@"0" stringByAppendingFormat:t];
        }
        s = [s stringByReplacingCharactersInRange:r withString:t];
    }
    
    value = [s floatValue];
            
    //NSLog(@"Value = %.2f", value);

}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        
    switch ((int)component) {
        case 0:
            return [numbers objectAtIndex:row];
            break;
        case 1:
            return [numbers objectAtIndex:row];
            break;            
        case 2:
            return [numbers objectAtIndex:row];
            break;          
        case 3:
            return [numbersCent objectAtIndex:row];
            break; 
        default: return @"?";
            break;
    }
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
        return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
        
    switch ((int)component) {
        case 0:
            return [numbers count];
            break;
        case 1:
            return [numbers count];
            break;
        case 2:
            return [numbers count];
            break;
        case 3:
            return [numbersCent count];
            break;            
        default: return 0;
            break;
    }
    
}




#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == movementsTableView)
        return [movements count];
    else
        return [pigs count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int r = indexPath.row;
    
    if (tableView == movementsTableView) {
        
        static NSString *CellIdentifier = @"Blog";
        MovementCell *cell = (MovementCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            Movement *mov = [movements objectAtIndex:r];
            
            if ([mov.flow isEqualToString:@"-"])
                cell.textLabel.textColor = [UIColor redColor];
            else
                cell.textLabel.textColor = [UIColor greenColor];
            
            
            NSString *nib = @"MovementCell";
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            
            
            cell.name.text = mov.name;
            cell.date.text = [df stringFromDate:mov.date];
            cell.category.text = mov.category.name;
            cell.value.text = [NSString stringWithFormat:@"%@%.2f €", mov.flow, [mov.value floatValue]];
            
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        return cell;

        
    }
    
    return nil;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int r = indexPath.row;
    
    if (tableView == movementsTableView) {

        currentMovement = [movements objectAtIndex:r];
        
        if (![currentMovement.name isEqualToString:@"Equalize"]) {
            
            newMovement = 0;
            
            movementEditor.movement = currentMovement;
            flow = currentMovement.flow;
            value = [currentMovement.value floatValue];
            
            movementEditor.newRecord = 0;
            movementEditor.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentModalViewController:movementEditor animated:YES];
            
        }
            
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == movementsTableView)
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleNone;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [movementsTableView setEditing:editing animated:YES];
}

-(void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (tv == movementsTableView) {
            
            //first update the total
            flow = [[movements objectAtIndex:indexPath.row] flow];
            if ([flow isEqualToString:@"+"]) {
                value = [display.text floatValue] - [[(Movement*)[movements objectAtIndex:indexPath.row] value] floatValue];
            } else
                value = [display.text floatValue] + [[(Movement*)[movements objectAtIndex:indexPath.row] value] floatValue];
            [self updateDisplayWithValue:value];
            
            //then remove the entry from the db
            [self deleteMovementAtIndex:indexPath.row];
            
            //then remove the row
            [movements removeObjectAtIndex:indexPath.row];
            [movementsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}



#pragma mark - View lifecycle

-(void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
            interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            return FALSE;
        }
    }
    
    return TRUE;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - Flipside View Controller

-(void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }

}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popoverController = nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Preparing DC");
    
    [[segue destinationViewController] setDelegate:self];
    UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];

    
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        
        UINavigationController *nav = (UINavigationController*)[popoverController contentViewController];
        FlipsideViewController *flip = (FlipsideViewController*)[nav visibleViewController];
        NSLog(@"Title = %@", @"flip");

        flip.managedObjectContext = self.managedObjectContext;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    } else {
        
        ChoosePig *choose_ = (ChoosePig*)[popoverController contentViewController];

        choose_.managedObjectContext = self.managedObjectContext;
                
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            
            choosePigPopoverController = popoverController;
            popoverController.delegate = self;
        }
        
    }
}

-(IBAction)togglePopover:(id)sender {
   
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
        [self refresh];
        
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}


#pragma mark - Choose Pig

-(IBAction)choosePig:(id)sender {
    
    if (choosePigPopoverController) {
        [choosePigPopoverController dismissPopoverAnimated:YES];
        choosePigPopoverController = nil;
        [self refresh];
        
    } else {
        [self performSegueWithIdentifier:@"showChoosePig" sender:sender];
    }
}

-(void)choosePigDidFinish:(ChoosePig *)controller {

    self.currentPig = controller.currentPig;    
    [self refresh];

    
}



@end
