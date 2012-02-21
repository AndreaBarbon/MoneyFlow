//
//  Link.h
//  Money
//
//  Created by Andrea Barbon on 18/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movement;

@interface Link : NSManagedObject

@property (nonatomic, retain) Movement *movementIn;
@property (nonatomic, retain) Movement *movementOut;

@end
