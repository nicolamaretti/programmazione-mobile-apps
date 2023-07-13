//
//  DataSource.h
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import <Foundation/Foundation.h>
#import "Placeholder.h"
#import "PlaceholderList.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DataSource <NSObject>

- (void)addPlaceholder:(Placeholder *)placeholder;
- (void)deletePlaceholder:(Placeholder *)placeholder;
- (NSArray *)getPlaceholders;
- (Placeholder *)placeholderAtIndex:(NSInteger)index;
- (PlaceholderList *)getPlaceholdersOrderedByLastModificationData;
- (NSInteger)size;

- (void)addPlaceholdersDiProva;

@end

NS_ASSUME_NONNULL_END
