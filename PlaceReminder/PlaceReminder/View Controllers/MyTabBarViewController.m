//
//  MyTabBarViewController.m
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import "MyTabBarViewController.h"
#import "PlaceholderDataSource.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // creazione del datasource e popolamento
    self.dataSource = [[PlaceholderDataSource alloc] init];
//    [self.dataSource addPlaceholdersDiProva];
    
    if(self.dataSource != nil) {
        self.placeholders = [self.dataSource getPlaceholdersOrderedByLastModificationData];
    }
}

@end
