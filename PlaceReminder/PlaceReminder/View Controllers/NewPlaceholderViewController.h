//
//  NewPlaceholderViewController.h
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "Placeholder.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const doneButtonPressedNotification;

@interface NewPlaceholderViewController : UIViewController

@property (nonatomic, strong) id<DataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
