//
//  Placeholder.h
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

NS_ASSUME_NONNULL_BEGIN

@interface Placeholder : NSObject

- (instancetype)initWithLocation:(Poi *)location
                           notes:(NSString *)notes
                    creationDate:(NSDate *)creationDate
            lastModificationDate:(NSDate *)lastModificationDate;

- (instancetype)initWithLocation:(Poi *)location
                    creationDate:(NSDate *)creationDate
            lastModificationDate:(NSDate *)lastModificationDate;

@property (nonatomic, strong) Poi *location;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *lastModificationDate;

- (void)updatePlaceholderWithLocationName:(NSString *)locationName
                                    notes:(NSString *)notes
                     lastModificationDate:(NSDate *)lastModificationDate;

- (void)updatePlaceholderWithlocationLatitude:(double)locationLatitude
                            locationLongitude:(double)locationLongitude
                                        notes:(NSString *)notes
                         lastModificationDate:(NSDate *)lastModificationDate;

- (void)updatePlaceholderNotes:(NSString *)notes
          lastModificationDate:(NSDate *)lastModificationDate;

- (NSString *)displayLocationName;
- (NSString *)displayLocationLatitude;
- (NSString *)displayLocationLongitude;
- (NSString *)displayCreationDate;
- (NSString *)displayCreationTime;
- (NSString *)displayCreationFullDate;
- (NSString *)displayLastModificationDate;
- (NSString *)displayLastModificationTime;
- (NSString *)displayLastModificationFullDate;

@end

NS_ASSUME_NONNULL_END
