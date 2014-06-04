#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Foot.h"
#import "Person.h"
#import "FootTableViewCell.h"

@interface MasterViewController ()

@property NSString *hairiness;
@property NSNumber *size;
@property NSNumber *stench;
@property NSInteger friends;

@end

@implementation MasterViewController


-(void)viewDidLoad
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];

    [super viewDidLoad];

    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"PersonCache"];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];


    self.friends = [self.managedObjectContext registeredObjects].count;
    
    NSLog(@"%ld", (long)self.friends);

    if (self.friends == 0) {
    [self getFriends];
    }
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
             
             person.name = namefromJSON;
             [self createFootProperties];

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
         self.friends = [self.managedObjectContext registeredObjects].count;
         NSLog(@"%ld", (long)self.friends);
     }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Person *person = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    DetailViewController *destinationVC = segue.destinationViewController;
    destinationVC.detailItem = person;
    destinationVC.numofFriends = self.friends;
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
    cell.stenchLabel.text = [NSString stringWithFormat:@"%@", [[person.feet anyObject] stench]];
    cell.sizeLabel.text = [NSString stringWithFormat:@"%@", [[person.feet anyObject] footsize]];

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
}




@end