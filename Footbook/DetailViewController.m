//
//  DetailViewController.m
//  Footbook
//
//  Created by David Warner on 6/4/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFeetLabel;
@property (weak, nonatomic) IBOutlet UILabel *hairinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *stenchLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *footSizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *textInput;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *commentsArray;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];

    self.nameLabel.text = self.detailItem.name;
    self.numFeetLabel.text = @(self.detailItem.feet.count).description;
    self.hairinessLabel.text = [[self.detailItem.feet anyObject] hairiness];
    self.stenchLevelLabel.text = [NSString stringWithFormat:@"%@", [[self.detailItem.feet anyObject] stench]];
    self.footSizeLabel.text = [NSString stringWithFormat:@"%@", [[self.detailItem.feet anyObject] footsize]];
    self.profileImage.image = [UIImage imageWithData:self.detailItem.profilepic];

}
- (IBAction)onSubmitButtonPressed:(id)sender
{
    if (self.textInput.text)
    {
        NSString *comment = self.textInput.text;
        [self.commentsArray addObject:comment];
        self.textInput.text = @"";
        [self.textInput resignFirstResponder];
        [self.tableView reloadData];
        [self save];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.commentsArray objectAtIndex:indexPath.row];
    return cell;
}


- (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
}

- (void)save
{
    NSURL *plist = [[self documentsDirectory]URLByAppendingPathComponent:@"feet.plist"];
    [self.commentsArray writeToURL:plist atomically:YES];

}

- (void)load
{
    NSURL *plist = [[self documentsDirectory]URLByAppendingPathComponent:@"feet.plist"];
    self.commentsArray = [NSMutableArray arrayWithContentsOfURL:plist];
    if (!self.commentsArray)
    {
        self.commentsArray = [NSMutableArray array];
    }
}

@end

