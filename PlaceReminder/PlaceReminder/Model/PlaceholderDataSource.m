//
//  PlaceholderDataSource.m
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import "PlaceholderDataSource.h"
#import "Poi.h"
#import "Placeholder.h"
#import "PlaceholderList.h"

NSString *const PlaceholderListHasChangedNotification = @"PlaceholderListHasChangedNotification";

@interface PlaceholderDataSource ()

@property (nonatomic, strong) PlaceholderList *placeholders;
- (void)placeholderListHasChanged;
- (PlaceholderList *)sortByData:(NSMutableArray <Placeholder *> *)array;

@end

@implementation PlaceholderDataSource

- (instancetype)init {
    if(self = [super init]) {
        _placeholders = [[PlaceholderList alloc] init];
    }
    
    return self;
}

- (NSInteger)size {
    return [self.placeholders size];
}

- (void)addPlaceholder:(Placeholder *)placeholder {
    [self.placeholders add:placeholder];
    [self placeholderListHasChanged];
}

- (void)deletePlaceholder:(Placeholder *)placeholder {
    [self.placeholders remove:placeholder];
    [self placeholderListHasChanged];
}

- (Placeholder *)placeholderAtIndex:(NSInteger)index {
    return [self.placeholders placeholderAtIndex:index];
}

- (NSArray *)getPlaceholders {
    return [self.placeholders getPlaceholders];
}

- (PlaceholderList *)getPlaceholdersOrderedByLastModificationData {
    // copio i self.placeholders dentro ad un array temporaneo dove andrò ad ordinarli
    long size = [self.placeholders size];
    
    NSMutableArray <Placeholder*> *tempArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < size; ++i) {
        Placeholder *placeholder = [self.placeholders placeholderAtIndex:i];
        
        [tempArray addObject:placeholder];
    }
    
    return [self sortByData:tempArray];
}

- (PlaceholderList *)sortByData:(NSMutableArray <Placeholder *> *)array {
    PlaceholderList* sortedPlaceholders = [[PlaceholderList alloc] init];
    
    // insertion sort
    long size = array.count;
    
    NSLog(@"newSize: %ld", size);
    
    for(int i = 0; i < size; ++i) {
        NSLog(@"%@", array[i].location.name);
    }
    
    for(int i = 1; i < size; ++i) {
        // data key per fare i confronti
        Placeholder *keyPlaceholder = [array objectAtIndex:i];
        NSDate *dateToCompare = keyPlaceholder.lastModificationDate;

        // indice delle date che precedono dateToCompare
        int j = i - 1;

        while(j >= 0 && [[array objectAtIndex:j].lastModificationDate compare:dateToCompare] == NSOrderedAscending) {
            Placeholder *placeholder= [array objectAtIndex:j];

            array[j + 1] = placeholder;

            j--;
        }

        array[j + 1] = keyPlaceholder;
    }
    
    // copio i placeholder ordinati dentro all'array da restituire
    for(int i = 0; i < size; ++i) {
        Placeholder *placeholder = [array objectAtIndex:i];
        
        [sortedPlaceholders add:placeholder];
    }
    
    return sortedPlaceholders;
}

- (void)placeholderListHasChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:PlaceholderListHasChangedNotification
                                                        object:self];
}

- (void)addPlaceholdersDiProva {
    [self.placeholders add:[[Placeholder alloc] initWithLocation:[[Poi alloc] initWithName:@"Piacenza" latitude:45.0526629 longitude:9.6938145] notes:@"Placeholder in Piazza Cavalli" creationDate:[[NSDate alloc] init] lastModificationDate:[[NSDate alloc] initWithTimeIntervalSinceNow:130]]];
    [self.placeholders add:[[Placeholder alloc] initWithLocation:[[Poi alloc] initWithName:@"Milano" latitude:45.4639102 longitude:9.1906426] notes:@"Placeholder in Piazza Duomo" creationDate:[[NSDate alloc] init] lastModificationDate:[[NSDate alloc] initWithTimeIntervalSinceNow:60]]];
    [self.placeholders add:[[Placeholder alloc] initWithLocation:[[Poi alloc] initWithName:@"Arma di Taggia" latitude:43.8310037 longitude:7.8490829] notes:@"Placeholder al mare" creationDate:[[NSDate alloc] init] lastModificationDate:[[NSDate alloc] initWithTimeIntervalSinceNow:90]]];
    [self.placeholders add:[[Placeholder alloc] initWithLocation:[[Poi alloc] initWithName:@"Carisolo" latitude:46.1687756 longitude:10.7591591] creationDate:[[NSDate alloc] init] lastModificationDate:[[NSDate alloc] initWithTimeIntervalSinceNow:150]]];
    [self.placeholders add:[[Placeholder alloc] initWithLocation:[[Poi alloc] initWithName:@"Università di Parma - Campus, Parco Area delle Scienze" latitude:44.765542 longitude:10.311033] notes:@"Placeholder in università" creationDate:[[NSDate alloc] init] lastModificationDate:[[NSDate alloc] initWithTimeIntervalSinceNow:10]]];

    NSLog(@"%s Placeholder list size: %ld", __FUNCTION__, [self.placeholders size]);
}

@end
