//
//  PlaceholderDataSource.h
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const PlaceholderListHasChangedNotification;

@interface PlaceholderDataSource : NSObject <DataSource>

@end

NS_ASSUME_NONNULL_END
