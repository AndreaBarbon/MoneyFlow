//
//  ChoosePig.m
//  Money
//
//  Created by Andrea Barbon on 19/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "ChoosePig.h"

@implementation ChoosePig

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = delegate.managedObjectContext;
    self.currentPig = [(MoneyViewController*)delegate currentPig];

    [self refresh];

}

-(IBAction)add:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    if (btn == btn2) {
        
        if ([btn.titleLabel.text isEqualToString:@"Add"]) {
            
            [btn setTitle:@"Ok" forState:UIControlStateNormal];
            [btn1 setTitle:@"Cancel" forState:UIControlStateNormal];
            nameField.hidden = 0;
            nameFieldBkg.hidden = 0;
            nameField.text = @"";
            [nameField becomeFirstResponder];

            
        } else {
            
            if (btn3.hidden) {
                editingPig = [self newPig];
            }
            editingPig.name = nameField.text;
            [self.managedObjectContext save:nil];
            [btn setTitle:@"Add" forState:UIControlStateNormal];
            [btn1 setTitle:@"Edit" forState:UIControlStateNormal];
            nameField.hidden = 1;
            nameFieldBkg.hidden = 1;
            btn3.hidden = 1;
            [nameField resignFirstResponder];
            self.currentPig = editingPig;
            [self refresh];

        }
        
    } else if(btn == btn1) {
        
        if ([btn.titleLabel.text isEqualToString:@"Edit"]) {
            
            [btn2 setTitle:@"Ok" forState:UIControlStateNormal];
            [btn1 setTitle:@"Cancel" forState:UIControlStateNormal];
            nameField.hidden = 0;
            nameFieldBkg.hidden = 0;
            btn3.hidden = 0;
            [nameField becomeFirstResponder];
            editingPig = [self currentPig];
            nameField.text = editingPig.name;
            
        } else {
            
            [btn2 setTitle:@"Add" forState:UIControlStateNormal];
            [btn1 setTitle:@"Edit" forState:UIControlStateNormal];
            nameField.hidden = 1;
            nameFieldBkg.hidden = 1;
            btn3.hidden = 1;
            [nameField resignFirstResponder];
            
        }
    } else {

        //ALLERT!!!
        [nameField resignFirstResponder];
        [self showDeleteAllert];

    }
    
}

-(void)showDeleteAllert {
    
    NSString *msg = [NSString stringWithFormat:@"Sei sicuro di voler eliminare \"%@\" ? Tutti i dati in esso contenuti verranno persi", editingPig.name];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione"
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:@"Annulla"
                                            otherButtonTitles:@"Elimina", nil];
    
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Annulla"])
    {
        NSLog(@"Annullato");
    }
    else if([title isEqualToString:@"Elimina"])
    {
        [[self managedObjectContext] deleteObject:self.currentPig];
        
        [btn2 setTitle:@"Add" forState:UIControlStateNormal];
        [btn1 setTitle:@"Edit" forState:UIControlStateNormal];
        nameField.hidden = 1;
        nameFieldBkg.hidden = 1;
        btn3.hidden = 1;
        self.currentPig = nil;
        [self refresh];
        
    }
    
}

-(void)refresh{
    
    pigs = [[NSMutableArray alloc] initWithArray:[self fetchPigs]];
    
    if (self.currentPig == nil)
        self.currentPig = [pigs objectAtIndex:0];
    
    NSLog(@"Current pig = %@", self.currentPig.name);

    
    for (UILabel *label in scrollView.subviews) {
        [label removeFromSuperview];
    }
    
    int height = self.view.frame.size.height;
    
    [scrollView setContentSize:CGSizeMake(SCREEN_W*[pigs count], height)];
    
    for (int i=0; i<[pigs count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 + SCREEN_W*i, height-55, 500, 50)];
        label.font = [UIFont systemFontOfSize:25];
        label.text = [[pigs objectAtIndex:i] name];
        label.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:label];
        label.textColor = [UIColor orangeColor];
    }    
    
    [self scrollToPig:self.currentPig];
    [delegate choosePigDidFinish:self];

    
}

-(Pig*)newPig {
    
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"Pig" 
            inManagedObjectContext:self.managedObjectContext];
}

-(void)scrollToPig:(Pig*)pig {
    
    for (int i=0; i<[pigs count]; i++) {
        if ([pigs objectAtIndex:i] == pig) {
            [scrollView setContentOffset:CGPointMake(SCREEN_W*i, 0)];
            self.currentPig = pig;
            return;
        }
    }
    
    [scrollView setContentOffset:CGPointMake(0, 0)];

}


#pragma mark scrollView delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_ {
        
    NSLog(@"Content offset = %.2f", scrollView.contentOffset.x);
    
    int i = ceil( scrollView.contentOffset.x/SCREEN_W);
    
    self.currentPig = [pigs objectAtIndex:i];
        
    [delegate choosePigDidFinish:self];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
        
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    pigs = [NSMutableArray arrayWithArray:[self fetchPigs]];

    return [pigs count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int r = indexPath.row;
    
    static NSString *cellIdentifier = @"pigCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [[pigs objectAtIndex:r] name];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int r = indexPath.row;
    self.currentPig = [pigs objectAtIndex:r];
    [self.delegate choosePigDidFinish:self];
    
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
