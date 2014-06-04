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
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

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
    [self getFootPics];
}

-(void)getFootPics
{
    NSString *feet = @"feet";
    NSString *foot = @"foot";
    NSString *perPage = [NSString stringWithFormat:@"%ld", (long)self.numofFriends];

    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5ad3d2d5952f1e0a4a111e54c686d08e&tags=%@+%@&per_page=%@&format=json&nojsoncallback=1",feet, foot, perPage];

    NSLog(@"%@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *flickrResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

         NSArray *JSONArray = [[flickrResults objectForKey:@"photos"] objectForKey:@"photo"];

         int random = arc4random() % self.numofFriends;

         NSDictionary *dictionary = [JSONArray objectAtIndex:random];
         
             NSString *farm = [dictionary objectForKey:@"farm"];
             NSString *server = [dictionary objectForKey:@"server"];
             NSString *ident = [dictionary objectForKey:@"id"];
             NSString *secret = [dictionary objectForKey:@"secret"];

             NSString *imageURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_m.jpg",farm, server, ident, secret];
             NSURL *imageURL = [NSURL URLWithString:imageURLString];
             NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
             self.detailItem.profilepic = imageData;

             UIImage *image = [UIImage imageWithData:self.detailItem.profilepic];
             self.profileImage.image = image;
     }];
}

@end

