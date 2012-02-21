//
//  EditMovementViewController.m
//  Money
//
//  Created by Andrea Barbon on 11/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "EditMovementViewController.h"

@implementation EditMovementViewController

@synthesize movement, newRecord, bookmarkSwitch, fixedSwitch, nameField, valuePicker, datePicker, categoryPicker, managedObjectContext, delegate, categories, pigs;


-(void)viewDidLoad {
    [super viewDidLoad];
    
    bookmarks = [[NSMutableArray alloc] init];
    categories = [[NSMutableArray alloc] initWithArray:[self fetchCategories]];
    pigs = [[NSMutableArray alloc] initWithArray:[self fetchPigs]];

    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0; i<10; i++) {[array addObject:[NSString stringWithFormat:@"%d", i]];}
    numbers = [NSArray arrayWithArray:array];
    
    NSMutableArray *arrayCent = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i=0; i<20; i++) {[arrayCent addObject:[NSString stringWithFormat:@"%d", i*5]];}
    numbersCent = [NSArray arrayWithArray:arrayCent];
    
}

-(void)viewWillAppear:(BOOL)animated {
    if (movement.link == nil) {
        
        linkSwitch.on = 0;
        linkPicker.hidden = 1;
        
    } else {
        linkSwitch.on = 1;
        linkPicker.hidden = 0;
        
        int row;
        if ([movement.flow isEqualToString:@"+"])
            row = [self indexOfPig:movement.link.movementOut.pig];
        else
            row = [self indexOfPig:movement.link.movementOut.pig];
        
        [linkPicker selectRow:row inComponent:0 animated:YES];
    }
        
    if ([movement.flow isEqualToString:@"+"])
        linkLabel.text = @"Prelievo da";
    else
        linkLabel.text = @"Bonifico a";


    bookmarksView.hidden = !newRecord;
    
    bookmarks =     [NSMutableArray arrayWithArray:[self fetchBookmarksWithFlow:movement.flow]];
    categories =    [NSMutableArray arrayWithArray:[self fetchCategories]];
    pigs =          [NSMutableArray arrayWithArray:[self fetchPigs]];
    
    [bookmarksTableView reloadData];
    [categoryPicker reloadComponent:0];
    [linkPicker reloadComponent:0];
    
    if (!newRecord) {
        nameField.text = movement.name;
        value = [movement.value floatValue];
        [self setValue:value inPicker:valuePicker];
        datePicker.date = movement.date;
        fixedSwitch.on = [movement.fixed intValue];
        bookmarkSwitch.on = [movement.bookmark intValue];
        [categoryPicker selectRow:[self indexOfCategory:movement.category] inComponent:0 animated:NO];
    } else {
        value = 0;
        nameField.text = @"";
        bookmarkSwitch.on = 0;
        datePicker.date = [NSDate date];
        [self setValue:value inPicker:valuePicker];
        category = [categories objectAtIndex:[categoryPicker selectedRowInComponent:0]];

    }
    
}

-(int)indexOfCategory:(Category*)cat {
    
    for (int i=0; i<[categories count]; i++) {
        if ([categories objectAtIndex:i]==cat) {
            return i;
        }
    }
    
    return 0;
}

-(int)indexOfPig:(Pig*)pig {
    
    for (int i=0; i<[pigs count]; i++) {
        if ([pigs objectAtIndex:i]==pig) {
            return i;
        }
    }
    
    return 0;
}

-(void)setValue:(float)v inPicker:(UIPickerView*)picker {
    
    NSString *s = [self stringForValue:v];
    
    for (int j=0; j<3; j++) {
        int i = [[NSString stringWithFormat:@"%c", [s characterAtIndex:j]] intValue];
        [picker selectRow:i inComponent:j animated:0];
    }
    
    int i = [[NSString stringWithFormat:@"%c%c", [s characterAtIndex:4], [s characterAtIndex:5]] intValue];
    [picker selectRow:i/5 inComponent:3 animated:0];
    
}

-(NSArray*)fetchBookmarksWithFlow:(NSString*)f {
        
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movement" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookmark == 1 AND flow == %@", f];
    [request setPredicate:predicate];
    
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

-(NSArray*)fetchPigs {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pig" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name != %@", movement.pig.name];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if ([array count] == 0) {
        NSLog(@"Error = %@", error);
    }
    
    return array;
}

-(void)resetPickers {
        
    for (int i=0; i<4; i++) {
        [valuePicker selectRow:0 inComponent:i animated:0];
    }
    
    datePicker.date = [NSDate date];
    nameField.text = @"";
}

-(NSString*)stringForValue:(float)v {
    
    if (v<0) v = v*(-1);
    
    NSString *s = [NSString stringWithFormat:@"%.2f", v];
    
    while ([s length]<6) {
        s = [@"0" stringByAppendingFormat:s];
    }
    
    return s;
}

-(void)deleteBookmarkAtIndex:(int)r {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Movement *mov = [bookmarks objectAtIndex:r];
    mov.bookmark = 0;
    
    //Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante la eliminazione: %@", [error localizedDescription]);
	} else {
        NSLog(@"Bookmark deleted!");
    }
    
}

-(IBAction)ok:(id)sender{
    
    movement.name = nameField.text;
    movement.value = [NSNumber numberWithFloat:value];
    movement.date = datePicker.date;
    movement.fixed = [NSNumber numberWithInt:fixedSwitch.isOn];
    movement.bookmark =[NSNumber numberWithInt:bookmarkSwitch.isOn];
    category = [categories objectAtIndex:[categoryPicker selectedRowInComponent:0]];
    movement.category = category;
    
        
    if (linkSwitch.on) { //Aggiunge il link e crea il movimento inverso
     
        Movement *oppositeMov;
        Link *link;
        
        if (movement.link == nil) {
            
            link = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Link" 
                          inManagedObjectContext:self.managedObjectContext];
            
            oppositeMov = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Movement" 
                                     inManagedObjectContext:self.managedObjectContext];
            
        } else {
            
            link = movement.link;
            if ([movement.flow isEqualToString:@"+"])
                oppositeMov = link.movementOut;
            else
                oppositeMov = link.movementIn;
        }
        
        for (NSString *attributeName in [[movement entity] attributesByName]) {
            [oppositeMov setValue:[movement valueForKey:attributeName] forKey:attributeName];
        }
        
        oppositeMov.pig = [pigs objectAtIndex:[linkPicker selectedRowInComponent:0]];
        oppositeMov.category = movement.category;

        
        if ([movement.flow isEqualToString:@"+"]) {
            oppositeMov.flow = @"-";
            link.movementIn = movement;
            link.movementOut = oppositeMov;
        } else {
            oppositeMov.flow = @"+";
            link.movementIn = oppositeMov;
            link.movementOut = movement;
        }
        
        movement.link = link;
        oppositeMov.link = link;
        
        [self.delegate saveMovement:oppositeMov];
        

   } 
   else if(movement.link != nil) { //cancella eventuale link esistente e movimento inverso
        
       Movement *oppositeMov;
        if ([movement.flow isEqualToString:@"+"])
            oppositeMov = movement.link.movementOut; 
        else 
            oppositeMov = movement.link.movementIn;
       
       [self.managedObjectContext deleteObject:movement.link];
       [self.managedObjectContext deleteObject:oppositeMov];
        
    }

    [self.delegate saveMovement:movement];

    [self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)cancel:(id)sender {
    
    if (newRecord) {
        [self.managedObjectContext deleteObject:movement];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)link:(id)sender {
    
    linkPicker.hidden = !linkSwitch.on;
    
}


#pragma mark PickerDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == categoryPicker) {
        
        category = [categories objectAtIndex:row];
        
    } else if (pickerView == linkPicker) {
    
        return;
    
    } else {
        
        NSString *s = [self stringForValue:value];
        
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
        
    }
    
    //NSLog(@"Value = %.2f", value);
    
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        
    
    if (pickerView == categoryPicker) {
        
        return [[categories objectAtIndex:row] name];
        
    } else if (pickerView == linkPicker) {
        
        return [[pigs objectAtIndex:row] name];
        
    } else {
        
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
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == categoryPicker || pickerView == linkPicker) 
        return 1;
    else
        return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == categoryPicker) {
        
        return [categories count];
        
    } else if (pickerView == linkPicker) {
        
        return [pigs count];
        
    } else {
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
    
}




#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [bookmarks count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    int r = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
        
    Movement *mov = [bookmarks objectAtIndex:r];

    cell.textLabel.text = mov.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%.2f €", mov.flow, [mov.value floatValue]];
            
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int r = indexPath.row;
            
    Movement *mov = [bookmarks objectAtIndex:r];
    nameField.text = mov.name;
    bookmarkSwitch.on = 0;
    fixedSwitch.on = [mov.fixed intValue];
    [self setValue:[mov.value floatValue] inPicker:valuePicker];
    value = [mov.value floatValue];
    [categoryPicker selectRow:[self indexOfCategory:mov.category] inComponent:0 animated:YES];
    category = mov.category;

}

//Editing

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return UITableViewCellEditingStyleDelete;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [bookmarksTableView setEditing:editing animated:YES];
}

-(void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
            
            //first remove the entry from the db
            [self deleteBookmarkAtIndex:indexPath.row];
            
            //then remove the row
            [bookmarks removeObjectAtIndex:indexPath.row];
            [bookmarksTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
    }
}


#pragma mark - View lifecycle

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
