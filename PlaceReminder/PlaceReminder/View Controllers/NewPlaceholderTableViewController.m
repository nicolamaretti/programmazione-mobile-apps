//
//  NewPlaceholderTableViewController.m
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import "NewPlaceholderTableViewController.h"
#import "NewPlaceholderViewController.h"
#import "Placeholder.h"
#import "PlaceholderDataSource.h"
#import "MyTabBarViewController.h"

NSString *const empty = @"EMPTY";
NSString *const error = @"ERROR";
NSString *const address = @"ADDRESS";
NSString *const coordinates = @"COORDINATES";
NSString *const dataSavedNotification = @"dataSavedNotification";

@interface NewPlaceholderTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, strong) Poi *location;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSDate *creationDate;

- (void)dismissKeyboard;
- (void)handleDoneButtonPressed;
- (void)showAlert:(NSString *)message;
- (void)saveData:(NSString *)message;
- (void)createNewPlaceholder;

@end

@implementation NewPlaceholderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addressTextField.delegate = self;
    self.latitudeTextField.delegate = self;
    self.longitudeTextField.delegate = self;
    
    [self.addressTextField becomeFirstResponder];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    // Mi metto in attesa dell'evento "DoneButtonPressed"
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDoneButtonPressed)
                                                 name:doneButtonPressedNotification
                                               object:nil];
}

- (void)dismissKeyboard {
    [self.addressTextField resignFirstResponder];
    [self.latitudeTextField resignFirstResponder];
    [self.longitudeTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //NSLog(@"textFieldDidBeginEditing");
    textField.textColor = [UIColor colorNamed:@"Black"];
}

- (void)handleDoneButtonPressed {
    // debug
    NSLog(@"Code of handleDoneButtonPressed");

    if([self.addressTextField.text isEqualToString:@""] && ![self.latitudeTextField.text isEqualToString:@""] && ![self.longitudeTextField.text isEqualToString:@""]) {
        // compilati solo i campi delle coordinate
        
        // debug
        NSLog(@"Prendo le coordinate");
        
        [self saveData:coordinates];
    }
    else if(![self.addressTextField.text isEqualToString:@""] && [self.latitudeTextField.text isEqualToString:@""] && [self.longitudeTextField.text isEqualToString:@""]) {
        // compilato solo il campo dell'indirizzo
        
        // debug
        NSLog(@"Prendo l'indirizzo");
        
        [self saveData:address];
    }
    else if([self.addressTextField.text isEqualToString:@""] && [self.latitudeTextField.text isEqualToString:@""] && [self.longitudeTextField.text isEqualToString:@""]) {
        // i campi sono tutti vuoti
        
        // debug
        NSLog(@"Vuoto");
        
        [self showAlert:empty];
    }
    else {
        // debug
        NSLog(@"Problemi problemi");
        
        [self showAlert:error];
    }
}

- (void)showAlert:(NSString *)message {
    // case empty
    if([message isEqualToString:empty]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MISSING FIELDS"
                                                                       message:@"Please compile 'Search by address' or 'Search by coordinates'."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmationAction = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:nil];
        
        [alert addAction:confirmationAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    // case error
    else if([message isEqualToString:error]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                       message:@"Please compile ONLY ONE between 'Search by address' and 'Search by coordinates'."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmationAction = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:nil];
        
        [alert addAction:confirmationAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)saveData:(NSString *)message {
    // debug
    NSLog(@"Code of saveData");
    
    NSString *addressString;
    NSString *latitudeString;
    NSString *longitudeString;
    
    if([message isEqualToString:address]) {
        addressString = self.addressTextField.text;
        
        self.location = [[Poi alloc] initWithName:addressString];
        
        // setup delle coordinate
        [self.location getCoordinatesFromAddress];
    }
    else if([message isEqualToString:coordinates]) {
        latitudeString = self.latitudeTextField.text;
        longitudeString = self.longitudeTextField.text;
        
        double lat = [latitudeString doubleValue];
        double lon = [longitudeString doubleValue];
        
        self.location = [[Poi alloc] initWithLatitude:lat longitude:lon];
        
        // setup dell'indirizzo
        [self.location getAddressFromCoordinates];
    }
    
    self.notes = self.descriptionTextView.text;
    self.creationDate = [[NSDate alloc] init];
    
    // mi metto in attesa dell'update della location
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createNewPlaceholder) name:LocationUpdatedNotification
                                               object:nil];

//    [[NSNotificationCenter defaultCenter] removeObserver:self name:doneButtonPressed object:nil];
}

- (void)createNewPlaceholder {
    Placeholder *placeholder = [[Placeholder alloc] initWithLocation:self.location
                                                               notes:self.notes
                                                        creationDate:self.creationDate
                                                lastModificationDate:self.creationDate];

    [self.dataSource addPlaceholder:placeholder];

    // debug
    NSArray *array = [self.dataSource getPlaceholders];
    NSLog(@"size: %lu", array.count);
    for (int i = 0; i < array.count; ++i) {
        Placeholder *placeholder = (Placeholder *) [array objectAtIndex:i];
        NSLog(@"%@, %f, %f", placeholder.location.name, placeholder.location.latitude, placeholder.location.longitude);
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:dataSavedNotification
                                                        object:self];
}

@end
