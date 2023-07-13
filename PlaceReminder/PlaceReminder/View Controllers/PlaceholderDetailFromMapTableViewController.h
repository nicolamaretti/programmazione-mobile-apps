//
//  PlaceholderDetailFromMapTableViewController.h
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import <UIKit/UIKit.h>
#import "Placeholder.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceholderDetailFromMapTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) Placeholder *placeholder;

@end

NS_ASSUME_NONNULL_END
