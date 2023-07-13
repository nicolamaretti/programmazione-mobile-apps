//
//  PlaceholderList.m
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import "PlaceholderList.h"

@interface PlaceholderList ()

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation PlaceholderList

- (instancetype)init {
    if(self = [super init]) {
        _list = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)add:(Placeholder *)placeholder {
    [self.list addObject:placeholder];
}

- (void)remove:(Placeholder *)placeholder {
    [self.list removeObject:placeholder];
}

- (void)removePlaceholderAtIndex:(NSInteger)index {
    [self.list removeObjectAtIndex:index];
}

- (Placeholder *)placeholderAtIndex:(NSInteger)index {
    return [self.list objectAtIndex:index];
}

- (NSInteger)size {
    return self.list.count;
}

- (NSArray *)getPlaceholders {
    return self.list;
}

@end
