//
//  Category.m
//  Money
//
//  Created by Andrea Barbon on 10/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "Category.h"
#import "Movement.h"


@implementation Category

@synthesize total;

@dynamic color;
@dynamic name;
@dynamic movements;

- (NSComparisonResult)compare:(Category *)otherObject {
    
    return [self.total compare:otherObject.total];

}

@end
