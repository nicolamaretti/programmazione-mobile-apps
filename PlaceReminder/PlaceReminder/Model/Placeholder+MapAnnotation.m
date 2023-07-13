//
//  Placeholder+MapAnnotation.m
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import "Placeholder+MapAnnotation.h"

@implementation Placeholder (MapAnnotation)

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.location.latitude;
    coordinate.longitude = self.location.longitude;
    
    return coordinate;
}

- (NSString *)title {
    return self.location.name;
}

@end
