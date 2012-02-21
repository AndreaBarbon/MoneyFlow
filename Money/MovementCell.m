//
//  MovementCell.m
//  Money
//
//  Created by Andrea Barbon on 11/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "MovementCell.h"


@implementation MovementCell

@synthesize name, date, value, category;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIButton *)findButtonInView:(UIView *)view {
	UIButton *button = nil;
    
	if ([view isMemberOfClass:[UIButton class]]) {
		return (UIButton *)view;
	}
    
	if (view.subviews && [view.subviews count] > 0) {
		for (UIView *subview in view.subviews) {
			button = [self findButtonInView:subview];
			if (button) return button;
		}
	}
    
	return button;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:FALSE animated:animated];
    
    // Configure the view for the selected state
}

 @end
