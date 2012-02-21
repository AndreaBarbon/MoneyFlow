//
//  Pig.h
//  Money
//
//  Created by Andrea Barbon on 18/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movement;

@interface Pig : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSSet *movements;
@end

@interface Pig (CoreDataGeneratedAccessors)

- (void)addMovementsObject:(Movement *)value;
- (void)removeMovementsObject:(Movement *)value;
- (void)addMovements:(NSSet *)values;
- (void)removeMovements:(NSSet *)values;

@end
