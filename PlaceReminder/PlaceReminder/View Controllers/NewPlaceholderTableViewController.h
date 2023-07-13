//
//  NewPlaceholderTableViewController.h
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const empty;
extern NSString *const error;
extern NSString *const address;
extern NSString *const coordinates;
extern NSString *const dataSavedNotification;

@interface NewPlaceholderTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) id<DataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
