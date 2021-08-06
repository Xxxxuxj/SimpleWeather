//
//  LeftTableViewController.h
//  Weather
//
//  Created by 徐xj on 2021/7/22.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherInfo.h"
#import "MJRefresh.h"
NS_ASSUME_NONNULL_BEGIN

@interface LeftTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* dataSource;
    UIRefreshControl* refreshControl;
}


@end

NS_ASSUME_NONNULL_END
