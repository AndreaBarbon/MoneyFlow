//
//  Category.h
//  Money
//
//  Created by Andrea Barbon on 10/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movement;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *movements;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addMovementsObject:(Movement *)value;
- (void)removeMovementsObject:(Movement *)value;
- (void)addMovements:(NSSet *)values;
- (void)removeMovements:(NSSet *)values;
- (NSComparisonResult)compare:(Category*)otherObject;

@end
