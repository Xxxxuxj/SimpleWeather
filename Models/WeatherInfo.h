//
//  WeatherInfo.h
//  xm2
//
//  Created by 徐xj on 2021/7/27.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfo : NSObject
/*
 {
 cityid = 101210101;
 citynm = "\U676d\U5dde";
 cityno = hangzhou;
 days = "2021-07-27";
 "humi_high" = 0;
 "humi_low" = 0;
 humidity = "0%/0%";
 "temp_high" = 29;
 "temp_low" = 25;
 temperature = "29\U2103/25\U2103";
 weaid = 94;
 weather = "\U5c0f\U5230\U4e2d\U96e8\U8f6c\U5c0f\U96e8";
 "weather_icon" = "http://api.k780.com/upload/weather/d/21.gif";
 "weather_icon1" = "http://api.k780.com/upload/weather/n/7.gif";
 "weather_iconid" = 21;
 "weather_iconid1" = 7;
 weatid = 22;
 weatid1 = 8;
 week = "\U661f\U671f\U4e8c";
 wind = "\U5357\U98ce";
 windid = 4;
 winp = "5-6\U7ea7";
 winpid = 3;
 }
 */

@property(nonatomic,copy)NSString* cityid;
@property(nonatomic,copy)NSString* citynm;
@property(nonatomic,copy)NSString* cityno;
@property(nonatomic,copy)NSString* days;
@property(nonatomic,copy)NSString* humi_high;
@property(nonatomic,copy)NSString* humi_low;
@property(nonatomic,copy)NSString* humidity;
@property(nonatomic,copy)NSString* temp_high;
@property(nonatomic,copy)NSString* temp_low;
@property(nonatomic,copy)NSString* temperature;
@property(nonatomic,copy)NSString* weaid;
@property(nonatomic,copy)NSString* weather;
@property(nonatomic,copy)NSString* weather_icon;
@property(nonatomic,copy)NSString* weather_icon1;
@property(nonatomic,copy)NSString* weather_iconid;
@property(nonatomic,copy)NSString* weather_iconid1;
@property(nonatomic,copy)NSString* weatid;
@property(nonatomic,copy)NSString* weatid1;
@property(nonatomic,copy)NSString* week;
@property(nonatomic,copy)NSString* wind;
@property(nonatomic,copy)NSString* windid;
@property(nonatomic,copy)NSString* winp;
@property(nonatomic,copy)NSString* winpid;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
