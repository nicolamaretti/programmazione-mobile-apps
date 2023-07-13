//
//  PlaceholderList.h
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import <Foundation/Foundation.h>
#import "Placeholder.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceholderList : NSObject

- (instancetype)init;

- (void)add:(Placeholder *)placeholder;
- (void)remove:(Placeholder *)placeholder;
- (void)removePlaceholderAtIndex:(NSInteger)index;
- (Placeholder *)placeholderAtIndex:(NSInteger)index;
- (NSArray *)getPlaceholders;
- (NSInteger)size;

@end

NS_ASSUME_NONNULL_END
