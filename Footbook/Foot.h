//
//  Foot.h
//  Footbook
//
//  Created by David Warner on 6/4/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Foot : NSManagedObject

@property (nonatomic, retain) NSNumber * footsize;
@property (nonatomic, retain) NSNumber * stench;
@property (nonatomic, retain) NSString * hairiness;
@property (nonatomic, retain) Person *person;

@end
