//
//  PlaceholderDetailTableViewController.h
//  PlaceReminder
//
//  Created by NM on 13/05/23.
//

#import <UIKit/UIKit.h>
#import "Placeholder.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceholderDetailTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) Placeholder *placeholder;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
