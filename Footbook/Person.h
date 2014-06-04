//
//  Person.h
//  Footbook
//
//  Created by David Warner on 6/4/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *feet;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addFeetObject:(NSManagedObject *)value;
- (void)removeFeetObject:(NSManagedObject *)value;
- (void)addFeet:(NSSet *)values;
- (void)removeFeet:(NSSet *)values;

@end
