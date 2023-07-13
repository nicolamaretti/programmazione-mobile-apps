//
//  PlaceholderListTableViewController.m
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import "PlaceholderListTableViewController.h"
#import "Placeholder.h"
#import "PlaceholderList.h"
#import "PlaceholderDataSource.h"
#import "PlaceholderDetailTableViewController.h"
#import "MyTabBarViewController.h"
#import "NewPlaceholderViewController.h"

@interface PlaceholderListTableViewController ()

@property (nonatomic, strong) PlaceholderList *placeholders;
@property (nonatomic, strong) MyTabBarViewController *tbvc;
- (void)refreshTableView;

@end

@implementation PlaceholderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"List";
    
    self.tbvc = (MyTabBarViewController *) [self tabBarController];
    self.placeholders = self.tbvc.placeholders;
    
    // debug
    for(int i = 0; i < [self.placeholders size]; ++i) {
        Placeholder *placeholder = [self.placeholders placeholderAtIndex:i];
        
        NSLog(@"Placeholder %d: %@ %@ %@ %@ %@", i, placeholder.location.name, [placeholder displayLocationLatitude], [placeholder displayLocationLongitude], [placeholder displayCreationFullDate], [placeholder displayLastModificationFullDate]);
    }
    
    // attesa di aggiunta di placeholder
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:PlaceholderListHasChangedNotification
                                               object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshTableView];
}

- (void)refreshTableView {
    dispatch_queue_t fetchDataQueue = dispatch_queue_create("FetchData", NULL);
    
    dispatch_async(fetchDataQueue, ^{
        self.placeholders = [self.tbvc.dataSource getPlaceholdersOrderedByLastModificationData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            if(self.refreshControl)
                [self.refreshControl endRefreshing];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.placeholders size] != 0) {
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        self.tableView.backgroundView = emptyLabel;
        
        return 1;
    }
    else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        messageLabel.text = @"No Placeholders";
        messageLabel.textColor = [UIColor systemGray2Color];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.placeholders size];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceholderCell" forIndexPath:indexPath];
    
    Placeholder *placeholder = [self.placeholders placeholderAtIndex:indexPath.row];
    
    cell.textLabel.text = placeholder.location.name;
    
    NSString *lastModified = @"Last modified: ";
    NSString *detailString = [lastModified stringByAppendingString:[placeholder displayLastModificationFullDate]];
    cell.detailTextLabel.text = detailString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        Placeholder *placeholder = [self.placeholders placeholderAtIndex:indexPath.row];
        
        
        // rimuovo il placeholder dal data source
        [self.tbvc.dataSource deletePlaceholder:placeholder];
        
//        // debug
//        NSLog(@"After deletion:");
//        PlaceholderList *list = [self.tbvc.dataSource getPlaceholdersOrderedByLastModificationData];
//
//        for(int i = 0; i < [list size]; ++i) {
//            NSLog(@"%@", [list placeholderAtIndex:i].location.name);
//        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowPlaceholderDetail"]) {
        if([segue.destinationViewController isKindOfClass:[PlaceholderDetailTableViewController class]]) {
            PlaceholderDetailTableViewController *vc = (PlaceholderDetailTableViewController *)segue.destinationViewController;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            
            Placeholder *placeholder = [self.placeholders placeholderAtIndex:indexPath.row];
            
            vc.placeholder = placeholder;
            vc.indexPath = indexPath;
        }
    }
    else if([segue.identifier isEqualToString:@"NewPlaceholder"]) {
        if([segue.destinationViewController isKindOfClass:[NewPlaceholderViewController class]]) {
            NewPlaceholderViewController *vc = (NewPlaceholderViewController *)segue.destinationViewController;

            vc.dataSource = self.tbvc.dataSource;
        }
    }
}

@end
