//
//  Movement.h
//  Money
//
//  Created by Andrea Barbon on 18/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Link, Pig;

@interface Movement : NSManagedObject

@property (nonatomic, retain) NSNumber * bookmark;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * fixed;
@property (nonatomic, retain) NSString * flow;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Link *link;
@property (nonatomic, retain) Pig *pig;

@end
