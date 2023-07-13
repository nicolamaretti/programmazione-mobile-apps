//
//  Placeholder.m
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import "Placeholder.h"

@implementation Placeholder

- (instancetype)initWithLocation:(Poi *)location
                           notes:(NSString *)notes
                    creationDate:(NSDate *)creationDate
            lastModificationDate:(NSDate *)lastModificationDate {
    if(self = [super init]) {
        _location = location;
        _notes = notes;
        _creationDate = creationDate;
        _lastModificationDate = lastModificationDate;
    }
    
    return self;
}

- (instancetype)initWithLocation:(Poi *)location
                    creationDate:(NSDate *)creationDate
            lastModificationDate:(NSDate *)lastModificationDate {
    return [self initWithLocation:location
                            notes:@""
                     creationDate:creationDate
             lastModificationDate:lastModificationDate];
}

- (void)updatePlaceholderWithLocationName:(NSString *)locationName
                                    notes:(NSString *)notes
                     lastModificationDate:(NSDate *)lastModificationDate {
    self.location.name = locationName;
    self.notes = notes;
    self.lastModificationDate = lastModificationDate;
}

- (void)updatePlaceholderWithlocationLatitude:(double)locationLatitude
                            locationLongitude:(double)locationLongitude
                                        notes:(NSString *)notes
                         lastModificationDate:(NSDate *)lastModificationDate {
    self.location.latitude = locationLatitude;
    self.location.longitude = locationLongitude;
    self.notes = notes;
    self.lastModificationDate = lastModificationDate;
}

- (void)updatePlaceholderNotes:(NSString *)notes
          lastModificationDate:(NSDate *)lastModificationDate {
    self.notes = notes;
    self.lastModificationDate = lastModificationDate;
}

- (NSString *)displayLocationName {
    return self.location.name;
}

- (NSString *)displayLocationLatitude {
    return [[NSString alloc] initWithFormat:@"%f", self.location.latitude];
}

- (NSString *)displayLocationLongitude {
    return [[NSString alloc] initWithFormat:@"%f", self.location.longitude];
}

- (NSString *)displayCreationDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, dd MMMM yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.creationDate];
    
    return stringFromDate;
}

- (NSString *)displayCreationTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.creationDate];
    
    return stringFromDate;
}

- (NSString *)displayCreationFullDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy, HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.creationDate];
    
    return stringFromDate;
}

- (NSString *)displayLastModificationDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, dd MMMM yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.lastModificationDate];
    
    return stringFromDate;
}

- (NSString *)displayLastModificationTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.lastModificationDate];
    
    return stringFromDate;
}

- (NSString *)displayLastModificationFullDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy, HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.lastModificationDate];
    
    return stringFromDate;
}

@end
