//
//  Poi.h
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Poi : NSObject

extern NSString *const LocationUpdatedNotification;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithLatitude:(double)latitude
                       longitude:(double)longitude;
- (instancetype)initWithName:(NSString *)name
                    latitude:(double)latitude
                   longitude:(double)longitude;

@property (nonatomic, strong) NSString *name;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (void)getCoordinatesFromAddress;
- (void)getAddressFromCoordinates;

@end

NS_ASSUME_NONNULL_END
