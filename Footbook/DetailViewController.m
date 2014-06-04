//
//  DetailViewController.m
//  Footbook
//
//  Created by David Warner on 6/4/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFeetLabel;
@property (weak, nonatomic) IBOutlet UILabel *hairinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *stenchLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *footSizeLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nameLabel.text = self.detailItem.name;
    self.numFeetLabel.text = @(self.detailItem.feet.count).description;
    self.hairinessLabel.text = [[self.detailItem.feet anyObject] hairiness];
    self.stenchLevelLabel.text = [NSString stringWithFormat:@"%@", [[self.detailItem.feet anyObject] stench]];
    self.footSizeLabel.text = [NSString stringWithFormat:@"%@", [[self.detailItem.feet anyObject] footsize]];
}

@end

