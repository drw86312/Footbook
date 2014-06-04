//
//  DetailViewController.h
//  Footbook
//
//  Created by David Warner on 6/4/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Foot.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Person *detailItem;
@property NSMutableArray *imagesArrayFromSource;

@end
