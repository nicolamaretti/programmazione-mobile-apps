//
//  PlaceholderMapViewController.m
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import "PlaceholderMapViewController.h"
#import <MapKit/MapKit.h>
#import "Placeholder.h"
#import "Placeholder+MapAnnotation.h"
#import "PlaceholderDetailFromMapTableViewController.h"
#import "MyTabBarViewController.h"

NSString *const geofenceNotification = @"geofenceNotification";

@interface PlaceholderMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MyTabBarViewController *tbvc;

- (void)addAnnotations:(NSArray <Placeholder *> *)placeholders;
- (void)addGeofenceForPlaceholders:(NSArray <Placeholder *> *)placeholders;
- (void)showAlert:(NSString *)regionName;

@end

@implementation PlaceholderMapViewController

- (CLLocationManager *)locationManager {
    if(!_locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    
    self.tbvc = (MyTabBarViewController *) [self tabBarController];
    self.placeholders = [self.tbvc.dataSource getPlaceholders];
    
    // configurazione del locationManager
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 100;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    // aggiungo le annotazioni
    [self addAnnotations:self.placeholders];
    
    // aggiungo le geofence
    [self addGeofenceForPlaceholders:self.placeholders];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%f", userLocation.coordinate.latitude);
}

- (void)viewWillAppear:(BOOL)animated {
    // mi faccio ridare i dati (in caso ci siano modifiche)
    self.placeholders = [self.tbvc.dataSource getPlaceholders];
    
    // debug
    NSLog(@"size:");
    for (int i = 0; i < self.placeholders.count; ++i) {
        Placeholder *placeholder = (Placeholder *) [self.placeholders objectAtIndex:i];
        NSLog(@"%@", placeholder.location.name);
    }
    
    // rimuovo le annotazioni precedenti
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // aggiungo le nuove annotazioni
    [self addAnnotations:self.placeholders];
    
    // aggiungo le geofence
    [self addGeofenceForPlaceholders:self.placeholders];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *AnnotationIdentifier = @"MapAnnotationView";
    
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if(!view) {
        view = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:AnnotationIdentifier];
        view.canShowCallout = YES;
    }
    
    view.annotation = annotation;

    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    imageView.image = [UIImage systemImageNamed:@"location.north.circle"];
    view.leftCalloutAccessoryView = imageView;
    
    return view;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    if([control isEqual:view.rightCalloutAccessoryView]) {
        [self performSegueWithIdentifier:@"ShowPlaceholderFromMap" sender:view];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    [self.mapView setCenterCoordinate:myLocation animated:YES];
}

- (void)addAnnotations:(NSArray <Placeholder *> *)placeholders {
    [placeholders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[Placeholder class]]) {
                Placeholder *placeholder = (Placeholder *)obj;
                [self.mapView addAnnotation:placeholder];
            }
    }];
}

// geofence
- (void)addGeofenceForPlaceholders:(NSArray <Placeholder *> *)placeholders {
    [placeholders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[Placeholder class]]) {
                Placeholder *placeholder = (Placeholder *)obj;
                
                /// creo la regione
                // coordinate
                CLLocationCoordinate2D placeholderCoordinate = CLLocationCoordinate2DMake(placeholder.location.latitude, placeholder.location.longitude);
                
                // radius in metri
                CLLocationDistance radius = 100.0;
                
                CLCircularRegion *geofenceRegion = [[CLCircularRegion alloc] initWithCenter:placeholderCoordinate radius:radius identifier:placeholder.title];
                
                
                // inizio monitoraggio regione
                [self.locationManager startMonitoringForRegion:geofenceRegion];
                
//                NSLog(@"Inizio monitoraggio: %f - %f - %f - %@", geofenceRegion.center.latitude, geofenceRegion.center.longitude, geofenceRegion.radius, geofenceRegion.identifier);
            }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSString *regionName = [region identifier];

    NSLog(@"%@", [@"Sei entrato nella regione: " stringByAppendingString:regionName]);
            
    // creo un alert per la notifica
    [self showAlert:regionName];
}

- (void)showAlert:(NSString *)regionName {
    NSString *title = [@"You are near" stringByAppendingString:regionName];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:@"Empty."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmationAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];
    
    [alert addAction:confirmationAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowPlaceholderFromMap"]) {
        if([segue.destinationViewController isKindOfClass:[PlaceholderDetailFromMapTableViewController class]]) {
            PlaceholderDetailFromMapTableViewController *vc = (PlaceholderDetailFromMapTableViewController *)segue.destinationViewController;
            
            if([sender isKindOfClass:[MKAnnotationView class]]) {
                MKAnnotationView *view = (MKAnnotationView *)sender;
                
                id annotation = view.annotation;
                
                if([annotation isKindOfClass:[Placeholder class]]) {
                    Placeholder *placeholder = (Placeholder *)annotation;
                    
                    vc.placeholder = placeholder;
                }
            }
        }
    }
}

@end
