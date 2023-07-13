//
//  PlaceholderDetailFromMapTableViewController.m
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import "PlaceholderDetailFromMapTableViewController.h"

@interface PlaceholderDetailFromMapTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *locationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationLatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationLongitudeTextField;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModificationDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic) BOOL locationNameTextFieldHasChanged;
@property (nonatomic) BOOL locationCoordinatesTextFieldHasChanged;
@property (nonatomic) BOOL descriptionTextViewHasChanged;

- (void)dismissVC;
- (void)showAlert;
- (void)textFieldDidChange:(UITextField *)textField;
- (void)textViewDidBeginEditing:(UITextView *)textView;

@end

@implementation PlaceholderDetailFromMapTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationNameTextField.delegate = self;
    self.locationLatitudeTextField.delegate = self;
    self.locationLongitudeTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    
    self.locationNameTextFieldHasChanged = NO;
    self.locationCoordinatesTextFieldHasChanged = NO;
    self.descriptionTextViewHasChanged = NO;
    
    [self.locationNameTextField addTarget:self
                                   action:@selector(textFieldDidChange:)
                         forControlEvents:UIControlEventEditingDidBegin];
    [self.locationLatitudeTextField addTarget:self
                                   action:@selector(textFieldDidChange:)
                         forControlEvents:UIControlEventEditingDidBegin];
    [self.locationLongitudeTextField addTarget:self
                                   action:@selector(textFieldDidChange:)
                         forControlEvents:UIControlEventEditingDidBegin];
    
    // nascondo l'ultima section con il bottone del salvataggio
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    [self.tableView cellForRowAtIndexPath:indexPath].hidden = YES;
    
    self.title = self.placeholder.location.name;
    
    self.locationNameTextField.text = self.placeholder.location.name;
    self.locationLatitudeTextField.text = [self.placeholder displayLocationLatitude];
    self.locationLongitudeTextField.text = [self.placeholder displayLocationLongitude];
    
    self.creationDateLabel.text = [self.placeholder displayCreationFullDate];
    self.lastModificationDateLabel.text = [self.placeholder displayLastModificationFullDate];

    self.descriptionTextView.text = self.placeholder.notes;
}

- (void)viewWillAppear:(BOOL)animated {
    // nascondo l'ultima section con il bottone del salvataggio
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    [self.tableView cellForRowAtIndexPath:indexPath].hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    self.title = @"Modification view";
    
    // mostro la cella che ha il bottone
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    [self.tableView cellForRowAtIndexPath:indexPath].hidden = NO;
    
    // rendo le celle della sezione 0 modificabili (LOCATION)
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [cell setUserInteractionEnabled:YES];
    }
    
    // rendo le celle della sezione 2 modificabili (DESCRIPTION)
    for (int i = 0; i < [self.tableView numberOfRowsInSection:2]; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:2];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [cell setUserInteractionEnabled:YES];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    // debug
    NSLog(@"saveButton pressed");
    
    NSString *newDescription = self.descriptionTextView.text;
    NSDate *newModificationDate = [[NSDate alloc] init];
    
    if(self.locationNameTextFieldHasChanged == YES) {
        // debug
        NSLog(@"self.locationNameTextFieldHasChanged == YES");
        
        NSString *newLocationName = self.locationNameTextField.text;
        
        [self.placeholder updatePlaceholderWithLocationName:newLocationName
                                                      notes:newDescription
                                       lastModificationDate:newModificationDate];
        
        // update delle coordinate
        [self.placeholder.location getCoordinatesFromAddress];
        
        // mi metto in attesa dell'update della location
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissVC)
                                                     name:LocationUpdatedNotification
                                                   object:nil];
    }
    else if(self.locationCoordinatesTextFieldHasChanged == YES) {
        // debug
        NSLog(@"self.locationCoordinatesTextFieldHasChanged == YES");
        
        NSString *newLocationLatitude = self.locationLatitudeTextField.text;
        NSString *newLocationLongitude = self.locationLongitudeTextField.text;
        
        // converto le coordinate in double
        double lat = [newLocationLatitude doubleValue];
        double lon = [newLocationLongitude doubleValue];
        
        [self.placeholder updatePlaceholderWithlocationLatitude:lat
                                              locationLongitude:lon
                                                          notes:newDescription
                                           lastModificationDate:newModificationDate];
        
        // update dell'indirizzo
        [self.placeholder.location getAddressFromCoordinates];
        
        // mi metto in attesa dell'update della location
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissVC)
                                                     name:LocationUpdatedNotification
                                                   object:nil];
    }
    
    else if(self.descriptionTextViewHasChanged == YES) {
        // debug
        NSLog(@"self.descriptionTextViewHasChanged == YES");
        
        [self.placeholder updatePlaceholderNotes:newDescription
                            lastModificationDate:newModificationDate];
        
        [self dismissVC];
    }
    else {
        // debug
        NSLog(@"Nothing to modify.");
        
        [self showAlert];
    }
    
    // debug
    NSLog(@"Save ended");
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"NOTHING TO SAVE"
                                                                   message:@"Nothing has been modified."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmationAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];
    
    [alert addAction:confirmationAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if([textField isEqual:self.locationNameTextField]) {
        // debug
        NSLog(@"%d", self.locationNameTextFieldHasChanged);
        NSLog(@"locationNameTextFieldDidChange");
        
        self.locationNameTextFieldHasChanged = YES;
        self.locationCoordinatesTextFieldHasChanged = NO;
        NSLog(@"%d", self.locationNameTextFieldHasChanged);
    }
    else if([textField isEqual:self.locationLatitudeTextField] || [textField isEqual:self.locationLongitudeTextField]) {
        // debug
        NSLog(@"%d", self.locationCoordinatesTextFieldHasChanged);
        NSLog(@"locationLatitudeTextFieldDidChange | locationLongitudeTextFieldDidChange");
        
        self.locationCoordinatesTextFieldHasChanged = YES;
        self.locationNameTextFieldHasChanged = NO;
        NSLog(@"%d", self.locationCoordinatesTextFieldHasChanged);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // debug
    NSLog(@"textViewDidBeginEditing");
    self.descriptionTextViewHasChanged = YES;
    NSLog(@"%d", self.descriptionTextViewHasChanged);
}

@end
