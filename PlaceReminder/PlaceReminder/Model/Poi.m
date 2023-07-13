//
//  Poi.m
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import "Poi.h"

NSString *const LocationUpdatedNotification = @"LocationUpdatedNotification";

@interface Poi ()

- (void)setCoordinatesWithLatitude:(double)latitude
                         longitude:(double)longitude;
- (void)setAddress:(NSString *)address;

@end

@implementation Poi

- (instancetype)initWithName:(NSString *)name
                    latitude:(double)latitude
                   longitude:(double)longitude {
    if(self = [super init]) {
        _name = name;
        _latitude = latitude;
        _longitude = longitude;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name
                     latitude:0.0
                    longitude:0.0];
}

- (instancetype)initWithLatitude:(double)latitude
                       longitude:(double)longitude {
    return [self initWithName:@""
                     latitude:latitude
                    longitude:longitude];
}

- (void)getCoordinatesFromAddress {
    // debug
    NSLog(@"code of getCoordinatesFromAddress");
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    dispatch_queue_t geocodeQueue = dispatch_queue_create("geocodeQueue", NULL);
    
    dispatch_async(geocodeQueue, ^{
        [geocoder geocodeAddressString:self.name
                     completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Unable to forward geocode address with error: %@", error);
                
                [self setCoordinatesWithLatitude:0.0
                                       longitude:0.0];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdatedNotification object:self];

                return;
            }

            if(placemarks && placemarks.count > 0) {
                NSObject *obj = [placemarks objectAtIndex:0];

                if([obj isKindOfClass:[CLPlacemark class]]) {
                    CLPlacemark *placemark = (CLPlacemark *)obj;
                    
                    [self setCoordinatesWithLatitude:placemark.location.coordinate.latitude
                                           longitude:placemark.location.coordinate.longitude];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdatedNotification object:self];
                }
            }
        }];
    });
}

- (void)getAddressFromCoordinates {
    // debug
    NSLog(@"code of getAddressFromCoordinates");
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    dispatch_queue_t geocodeQueue = dispatch_queue_create("geocodeQueue", NULL);
    
    // creo la location per il reverse geocoding
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    
    dispatch_async(geocodeQueue, ^{
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Unable to reverse geocode coordinates with error: %@", error);
                
                [self setAddress:@"UNDEFINED LOCATION"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdatedNotification object:self];
            }

            else if(placemarks && placemarks.count > 0) {
                NSLog(@"Location found");
                NSObject *obj = [placemarks objectAtIndex:0];

                if([obj isKindOfClass:[CLPlacemark class]]) {
                    CLPlacemark *placemark = (CLPlacemark *)obj;
                    
                    NSString *city = placemark.thoroughfare;
                    NSString *locality = placemark.locality;
                    
                    // debug
                    NSLog(@"City: %@", city);
                    NSLog(@"Locality: %@", locality);
                    
                    // ulteriore check oer la validita' dei dati restituiti
                    if(city == (id)[NSNull null] || city.length == 0 || locality == (id)[NSNull null] || locality.length == 0) {
                        [self setAddress:@"LOCATION UNDEFINED"];
                    }
                    else {
                        NSString *newAddress = [[city stringByAppendingString:@", "] stringByAppendingString:locality];
                        
                        [self setAddress:newAddress];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdatedNotification object:self];
                }
            }
        }];
    });
}

- (void)setCoordinatesWithLatitude:(double)latitude
                         longitude:(double)longitude {
    self.latitude = latitude;
    self.longitude = longitude;
}

- (void)setAddress:(NSString *)address {
    self.name = address;
}

@end
