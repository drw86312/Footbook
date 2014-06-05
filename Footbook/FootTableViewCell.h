//
//  FootTableViewCell.h
//  Footbook
//
//  Created by David Warner on 6/4/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfFeetLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stenchLabel;
@property (weak, nonatomic) IBOutlet UILabel *hairinessLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@end
