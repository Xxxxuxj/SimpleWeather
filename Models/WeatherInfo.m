//
//  WeatherInfo.m
//  xm2
//
//  Created by 徐xj on 2021/7/27.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "WeatherInfo.h"

@implementation WeatherInfo
-(instancetype)initWithDict:(NSDictionary*)dict{
    if(self=[super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
