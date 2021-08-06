//
//  MainViewController.m
//  Weather
//
//  Created by 徐xj on 2021/7/21.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "MainViewController.h"
#import "Tool.h"
#import "WeatherInfo.h"
#import "MainTableViewCell.h"
#import "Helper.h"

@interface MainViewController () <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UIImageView* imgView;
    NSString* currentNodeName;
    UITableView* myTableView;
    NSDictionary* cur_weather_info;
    MJRefreshHeader* header;
    //拿到位置的经纬度
    CLLocationManager* locationManager;
    //解析地名
    CLGeocoder* geocoder;
    
    NSString* cur_city;
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prefersHomeIndicatorAutoHidden];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseLocationAction:) name:@"ChooseLocationNotification" object:nil];
    //self.title=@"天气";
    [self location];
    
    
    self.view.backgroundColor=[UIColor blackColor];
    

    
}

-(void)autoLocationAction:(NSNotification*)sender{
    
}

-(void)chooseLocationAction:(NSNotification*)sender{
    self->cur_city=sender.userInfo[@"chooseCity"];
    [[[Helper alloc]init]insertCity:self->cur_city];
    [self initView];
}

/*
 定位功能
 
 */

-(void)initView{
    Tool* tool=[Tool new];
    [self layoutNavigationBar:[tool returnDate:[NSDate new]] :[tool returnWeekdays:[NSDate new]] :cur_city];
    
    [self request:cur_city];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"InsertCity" object:nil userInfo:@{@"insertCity":cur_city}];
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height)  style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:myTableView];
    header=[MJRefreshNormalHeader new];
    //[header setHidden:true];
    //__weak typeof(self) weekself=self;
    //    __block UIViewController * strongBlock=self;
    
    if (@available(iOS 11.0, *)) {

    myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    myTableView.contentInset = UIEdgeInsetsMake(44, 0, 49, 0);

    myTableView.scrollIndicatorInsets = myTableView.contentInset;

    }
    
    [myTableView setMj_header:header];
    [header setRefreshingBlock:^{
        NSLog(@"下拉刷新");
        [self layoutNavigationBar:[[Tool new]returnDate:[NSDate new]] :[[Tool new] returnWeekdays:[NSDate new]] :self->cur_city];
        [self request:self->cur_city];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"InsertCity" object:nil userInfo:@{@"insertCity":self->cur_city}];
    }];

    
    
    myTableView.dataSource=self;
    myTableView.delegate=self;
    
    UINib* nib=[UINib nibWithNibName:@"MainTableViewCell" bundle:[NSBundle mainBundle]];
    [myTableView registerNib:nib forCellReuseIdentifier:@"CellReuseIdentifier"];
    
    myTableView.rowHeight=896;
    myTableView.hidden=true;
    
}



-(void)location{
    if([CLLocationManager locationServicesEnabled] == false){
        return;
    }else{
        locationManager=[CLLocationManager new];
        
        NSLog(@"%@",[[UIDevice currentDevice]systemVersion]);
        float version=[[[UIDevice currentDevice]systemVersion] floatValue];
        if(version>=8.0){
            [locationManager requestAlwaysAuthorization];
        }
        
        [locationManager startUpdatingLocation];
        
        locationManager.delegate=self;
        
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败:%@",[error debugDescription]);
    if([[Helper new]readChaceCity].count>0){
        self->cur_city= [[Helper new]readChaceCity][0];
    }else{
        self->cur_city=@"北京";
    }
    [self initView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if(locations.count >0){
        [manager stopUpdatingLocation];
        CLLocation* locationInfo= locations.lastObject;
        
        geocoder=[CLGeocoder new];
        [self->geocoder reverseGeocodeLocation:locationInfo completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if(placemarks.count >0){
                //回到主线程更新ui
                dispatch_async(dispatch_get_main_queue(), ^{
                CLPlacemark *place= placemarks[0];
                
                self->cur_city=place.locality;
                
                if([self->cur_city containsString:@"市"]){
                    
                    NSRange range= [self->cur_city rangeOfString:@"市"];
                    self->cur_city=[self->cur_city substringToIndex:range.location];
                    NSLog(@"%@",self->cur_city);
                }
                
                
                    [self initView];
                });
            }
        }];
    }
}
/*
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>允许?</string>
 <key>NSLocationAlwaysUsageDescription</key>
 <string>允许?</string>
 */


-(void)layoutNavigationBar:(NSString*)date :(NSString*)weekday :(NSString*)cityName{
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem* catogryBarItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"calender.png"] style:UIBarButtonItemStylePlain target:self action:@selector(chooseDateAction:)];
    catogryBarItem.imageInsets=UIEdgeInsetsMake(-1, 0, 0, 0);
    
    UIBarButtonItem* dateBarItem=[[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%@/%@", date,weekday] style:UIBarButtonItemStylePlain target:self action:@selector(chooseDateAction:)];
    
    
    
    [[self navigationItem]setLeftBarButtonItems:[NSArray arrayWithObjects:catogryBarItem,dateBarItem,nil]];
    
//    UIBarButtonItem* shareBarItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    
    UIBarButtonItem* cityBarItem=[[UIBarButtonItem alloc]initWithTitle:cityName style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem* settingBarItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction:)];
    settingBarItem.imageInsets=UIEdgeInsetsMake(1, 0, 0, 0);
//    NSDate *nowtime=[NSDate date];
//    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
//    [format1 setDateFormat:@"hh:mm"];
//    NSString *dateStr;
//    dateStr=[format1 stringFromDate:nowtime];
//    UIBarButtonItem* timelbl=[[UIBarButtonItem alloc]initWithTitle:dateStr style:UIBarButtonItemStylePlain target:nil action:nil];
    //[[self navigationItem]setRightBarButtonItems:@[shareBarItem,cityBarItem,settingBarItem]];
    [[self navigationItem]setRightBarButtonItems:[NSArray arrayWithObjects:settingBarItem,cityBarItem,nil]];
    
}
-(void)settingAction:(UIBarButtonItem*)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AlertSetMenu" object:nil];
}


-(void)shareAction:(UIBarButtonItem*)sender{
}


-(void)chooseDateAction:(UIBarButtonItem*)sender{
    
}



-(void)request:(NSString*)cityName{
    
    //请求七天的数据
    
    NSURLSession* session=[NSURLSession sharedSession];
    
    
    
//    NSString* cityName=@"北京";
    //NSString* urlString=[[NSString stringWithFormat:@"https://sapi.k780.com:88/?app=weather.future&weaid=\%@&&appkey=60677&sign=f3b7eb5a487f0a2ace9945be8a831835&format=json",cityName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString* urlString=[[NSString stringWithFormat:@"http://api.k780.com/?app=weather.future&weaid=\%@&appkey=60677&sign=f3b7eb5a487f0a2ace9945be8a831835&format=json",cityName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //url中不能够出现中文等特殊字符 出现了则必须将其编码
    
    //    NSString* urlString=[[NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.future&weaid=\%@&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=xml",cityName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url=[[NSURL alloc]initWithString:urlString];
    
    
    
    NSURLSessionDataTask * task= [session dataTaskWithURL:url completionHandler:^(NSData* data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil){
            //NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            
            //json解析
            NSDictionary *weatherInfo=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSArray* array=weatherInfo[@"result"];
            
            NSDictionary* dict=array[0];
            
            WeatherInfo* wi=[[WeatherInfo alloc]initWithDict:dict];
            NSLog(@"%@",wi.weather);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.view.backgroundColor=[[Tool new]returnWeatherBGColor:wi.weather];
                self->myTableView.backgroundColor=[[Tool new]returnWeatherBGColor:wi.weather];
                //self.navigationController.navigationBar.backgroundColor=[[Tool new]returnWeatherBGColor:wi.weather];
                NSIndexPath* indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
                
                MainTableViewCell* cell=[self->myTableView cellForRowAtIndexPath:indexpath];
                
                
                cell.backgroundColor=[[Tool new]returnWeatherBGColor:wi.weather];
                
                self->myTableView.hidden=false;
                self->myTableView.separatorStyle=UIAccessibilityTraitNone;
                
                
                
                [NSNotificationCenter.defaultCenter postNotificationName:@"LeftControllerTypeChangedNotification" object:nil userInfo:@{@"data":array}];
                [self->header endRefreshing];
            });
            
            
            
            //            //xml解析
            //
            //            NSXMLParser* xlmparser=[[NSXMLParser alloc]initWithData:data];
            //
            //            xlmparser.delegate=self;
            //
            //            [xlmparser parse];
            
            
        }
    }];
    
    [task resume];
    
    
    //请求当天的天气信息
    NSString* cur_urlString=[[NSString stringWithFormat:@"http://api.k780.com/?app=weather.today&weaid=\%@&appkey=60677&sign=f3b7eb5a487f0a2ace9945be8a831835&format=json",cityName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL* cur_url=[[NSURL alloc]initWithString:cur_urlString];
    
    
    
    NSURLSessionDataTask * cur_task= [session dataTaskWithURL:cur_url completionHandler:^(NSData* data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil){
            
            NSDictionary *weatherInfo=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary* dict=weatherInfo[@"result"];
//
//            WeatherInfo* wi=[[WeatherInfo alloc]initWithDict:dict];
            self->cur_weather_info=[[NSDictionary alloc]initWithDictionary:dict];
            
            
            NSLog(@"%@",self->cur_weather_info);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->myTableView reloadData];
            });
            
            
            
            
            
        }
    }];
    
    [cur_task resume];
    
    
    
    
}



/*
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    currentNodeName=elementName;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSString* newstr=[[NSString alloc]init];
    [newstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(![newstr  isEqual: @""]){
        NSLog(@"%@---->%@",currentNodeName,newstr);
    }
    
}
*/


/*
-(void)btnClick:(UIButton*) sender{
    //sleep(15);
    
//    NSThread* thread=[[NSThread alloc]initWithTarget:self selector:@selector(downloadImg:) object:nil];;
//
//    [thread start];
    
    
    dispatch_queue_t gcd_queue= dispatch_get_global_queue(0, 0);
    
    dispatch_async(gcd_queue, ^{
        NSURL *path=[[NSURL alloc]initWithString:@"https://img-pre.ivsky.com/img/tupian/pre/202012/30/paiji_anbian_jiaoshi_hailang-001.jpg"];
        
        NSData *data=[[NSData alloc]initWithContentsOfURL:path];
        UIImage* img=[[UIImage alloc]initWithData:data];
        
        //更新ui  从子线程切换到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self->imgView.image=img;
        });
    });
    
    
}
*/

/*
-(void)downloadImg:(NSThread *)sender{
    NSURL *path=[[NSURL alloc]initWithString:@"https://img-pre.ivsky.com/img/tupian/pre/202012/30/paiji_anbian_jiaoshi_hailang-001.jpg"];
    
    NSData *data=[[NSData alloc]initWithContentsOfURL:path];
    UIImage* img=[[UIImage alloc]initWithData:data];
    
    //更新ui  从子线程切换到主线程
    [imgView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:false];
    
    
    
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MainTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifier"];
    
    if(self->cur_weather_info != nil){
        //NSLog(@"666");
        NSString* weather=self->cur_weather_info[@"weather"];
        cell.weatherImgView.image=[[Tool new]returnWeatherImg:weather];
        cell.weatherLabel.text=weather;
        cell.temperatureLabel.text=self->cur_weather_info[@"temp_curr"];
        cell.temperatureRangeLabel.text=[NSString stringWithFormat:@"%@~%@",self->cur_weather_info[@"temp_low"],self->cur_weather_info[@"temp_high"]];
        cell.windLabel.text=self->cur_weather_info[@"wind"];
        cell.humidityRange.text=self->cur_weather_info[@"humidity"];
        if([self->cur_weather_info[@"temp_curr"] intValue] >= 35 ){
            cell.messageLabel.text=@"高温来袭";
        }else{
            cell.messageLabel.text=[[Tool new]returnMsg:weather];
        }
    }
    
    
    
    
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

/*
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    <#code#>
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    <#code#>
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    <#code#>
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    <#code#>
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    <#code#>
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    <#code#>
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    <#code#>
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    <#code#>
}

- (void)setNeedsFocusUpdate {
    <#code#>
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    <#code#>
}

- (void)updateFocusIfNeeded {
    <#code#>
}
*/
@end
