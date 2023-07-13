//
//  NewPlaceholderViewController.m
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import "NewPlaceholderViewController.h"
#import "NewPlaceholderTableViewController.h"
#import "PlaceholderDataSource.h"

NSString *const doneButtonPressedNotification = @"doneButtonPressedNotification";

@interface NewPlaceholderViewController ()

@end

@implementation NewPlaceholderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)cancelButtonPressed:(id)sender {
    // debug
    NSLog(@"Cancel button pressed.");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed {
    // debug
    NSLog(@"Done button pressed.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:doneButtonPressedNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissVC)
                                                 name:dataSavedNotification
                                               object:nil];
}

- (void)dismissVC {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:dataSaved object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"NewPlaceholderPrompt"]) {
        if([segue.destinationViewController isKindOfClass:[NewPlaceholderTableViewController class]]) {
            NewPlaceholderTableViewController *vc = (NewPlaceholderTableViewController *)segue.destinationViewController;

            vc.dataSource = self.dataSource;
        }
    }
}

@end
