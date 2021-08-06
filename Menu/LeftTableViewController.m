//
//  LeftTableViewController.m
//  Weather
//
//  Created by 徐xj on 2021/7/22.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "LeftTableViewController.h"
#import "LeftTableViewCell.h"
#import "WeatherInfo.h"
#import "Tool.h"


@implementation LeftTableViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    

//    UIRefreshControl* refreshControl=[UIRefreshControl new];
    
//    refreshControl.backgroundColor=[UIColor blackColor];
//    refreshControl.tintColor=[UIColor whiteColor];
//    [self.tableView addSubview:refreshControl];
    CGRect mainScreenBounds=[[UIScreen mainScreen]bounds];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,mainScreenBounds.size.width, mainScreenBounds.size.height)];
    
    self.tableView.backgroundColor=[UIColor blackColor];
    
    
    
    UINib* nib=[UINib nibWithNibName:@"LeftTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"left"];
    
    self.tableView.rowHeight=100;
    
    self.tableView.separatorStyle=UIAccessibilityTraitNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData:) name:@"LeftControllerTypeChangedNotification" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
}

-(void)refreshData:(NSNotification*)sender{
    NSArray* info=[sender.userInfo valueForKey:@"data"];
    //NSLog(@"%@", info);
    dataSource=[NSMutableArray new];
    
    for(NSDictionary* dict in info){
        NSDictionary* dic=dict;
        WeatherInfo* weather= [[WeatherInfo alloc]initWithDict:dic];
        
        //NSLog(@"%@",weather.weather);
        
        [dataSource addObject:weather];
        [self.tableView reloadData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
    
    WeatherInfo* dayWeatherInfo=dataSource[indexPath.row];
    
    cell.dateLabel.text=[[Tool new]returnNeedDay:dayWeatherInfo.days];
    cell.weekDayLabel.text=[[Tool new]returnWeek: dayWeatherInfo.week];
    cell.temperatureLabel.text=[NSString stringWithFormat:@"%@~%@",dayWeatherInfo.temp_low,dayWeatherInfo.temp_high];
    cell.weatherLabel.text=[[Tool new]returnWeatherType: dayWeatherInfo.weather];
    cell.weatherBG.backgroundColor=[[Tool new]returnWeatherBGColor:dayWeatherInfo.weather];
    // Configure the cell...
    if(indexPath.row == 0){
        cell.weekDayLabel.text=@"今天";
    }
    if(indexPath.row==1){
        cell.weekDayLabel.text=@"明天";
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
    
