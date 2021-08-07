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
    
    //存放七天天气信息的可变数组
    NSMutableArray* dataSource;
    
    //fresh控键control
    UIRefreshControl* refreshControl;
}


@end

NS_ASSUME_NONNULL_END
