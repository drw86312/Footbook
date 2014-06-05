#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Foot.h"
#import "Person.h"
#import "FootTableViewCell.h"

@interface MasterViewController ()

@property NSString *hairiness;
@property NSNumber *size;
@property NSNumber *stench;
@property NSData *footPhoto;
@property NSInteger friends;
@property NSFetchRequest *request;
@property NSMutableArray *imageDataArray;

@end

@implementation MasterViewController


-(void)viewDidLoad
{
    [super viewDidLoad];

    self.request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    self.imageDataArray = [[NSMutableArray alloc] init];

    self.request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"PersonCache"];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    self.friends = [self.managedObjectContext registeredObjects].count;
    [self setFriendsCount];
    [self getFootPics];

}

-(void)getFriends
{
    NSString *urlString = @"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/4/friends.json";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSArray *array  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

         for (NSString *namefromJSON in array) {
             
             Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
             [self createFootProperties];

             person.name = namefromJSON;
             person.profilepic = self.footPhoto;

             int feet = arc4random() % 50;
             int counter = 0;
             NSMutableSet *mutableSet = [[NSMutableSet alloc] init];

             while (counter < feet)
                {
                 Foot *foot = [NSEntityDescription insertNewObjectForEntityForName:@"Foot" inManagedObjectContext:self.managedObjectContext];
                 foot.stench = self.stench;
                 foot.footsize = self.size;
                 foot.hairiness = self.hairiness;
                 foot.person = person;

                 [mutableSet addObject:foot];
                 counter ++;
                }

             NSSet *set = [NSSet setWithSet:mutableSet];
             [person addFeet:set];
             [self.managedObjectContext save:nil];
            }
         [self setFriendsCount];
         [self.tableView reloadData];
     }];
}

-(void)getFootPics
{
    NSString *feet = @"feet";

    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5ad3d2d5952f1e0a4a111e54c686d08e&tags=%@&per_page=40&format=json&nojsoncallback=1",feet];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *flickrResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

         NSArray *array = [[flickrResults objectForKey:@"photos"] objectForKey:@"photo"];

         NSLog(@"%lu", array.count);

         for (NSDictionary *dictionary in array) {
         NSString *farm = [dictionary objectForKey:@"farm"];
         NSString *server = [dictionary objectForKey:@"server"];
         NSString *ident = [dictionary objectForKey:@"id"];
         NSString *secret = [dictionary objectForKey:@"secret"];

         NSString *imageURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_m.jpg",farm, server, ident, secret];
         NSURL *imageURL = [NSURL URLWithString:imageURLString];
         NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        [self.imageDataArray addObject:imageData];
            }
        if (self.friends == 0) {
            [self getFriends];
        }
    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Person *person = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    DetailViewController *destinationVC = segue.destinationViewController;
    destinationVC.detailItem = person;
    destinationVC.imagesArrayFromSource = self.imageDataArray;
    destinationVC.title = person.name;
}


#pragma mark - Tableview methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    FootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.nameLabel.text = person.name;
    cell.numOfFeetLabel.text = @(person.feet.count).description;
    cell.hairinessLabel.text = [[person.feet anyObject] hairiness];
    cell.sizeLabel.text = [NSString stringWithFormat:@"%@", [[person.feet anyObject] footsize]];
    UIImage *image = [UIImage imageWithData:person.profilepic];
    UIImage *thumbnail = [self generatePhotoThumbnail:image];
    cell.imageView.image = thumbnail;

    return cell;
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.tableView reloadData];
}

#pragma mark - Helper method

-(void)createFootProperties
{
    NSArray *hairiness =  [NSArray arrayWithObjects:@"Silky Smooth", @"Stubbly", @"Hairsuite", @"Furry", @"Extremely", nil];
    int randomHairiness = arc4random() % hairiness.count;
    self.hairiness = [hairiness objectAtIndex:randomHairiness];

    int size = arc4random() % 16;
    NSNumber *size1 = [NSNumber numberWithInt:size];
    self.size = size1;

    int stench = arc4random() % 10;
    NSNumber *stench1 = [NSNumber numberWithInt:stench];
    self.stench = stench1;

    NSData *footPhotoData = self.imageDataArray.firstObject;
    self.footPhoto = footPhotoData;
    [self.imageDataArray removeObjectAtIndex:0];
}

-(void)setFriendsCount
{
    [self.request setEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext]];
    [self.request setIncludesSubentities:NO];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:self.request error:nil];
    self.friends = count;
}

- (UIImage *)generatePhotoThumbnail:(UIImage *)image
{
    // Create a thumbnail version of the image for the event object.

    CGFloat thumbnailsize = 75.0;
    CGSize size = image.size;
    CGSize croppedSize;

    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;

    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension.
    // So clip the extra portion from x or y coordinate
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }

    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping

    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, thumbnailsize, thumbnailsize);

    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing

    return thumbnail;
}



@end