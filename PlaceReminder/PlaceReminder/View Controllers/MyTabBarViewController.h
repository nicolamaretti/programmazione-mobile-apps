//
//  MyTabBarViewController.h
//  PlaceReminder
//
//  Created by NM on 14/05/23.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "PlaceholderList.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTabBarViewController : UITabBarController

@property (nonatomic, strong) id<DataSource> dataSource;
@property (nonatomic, strong) PlaceholderList *placeholders;

@end

NS_ASSUME_NONNULL_END
