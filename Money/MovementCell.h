//
//  MovementCell.h
//  Money
//
//  Created by Andrea Barbon on 11/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovementCell : UITableViewCell {
    

}

@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *value;
@property (nonatomic, retain) IBOutlet UILabel *category;

@end
