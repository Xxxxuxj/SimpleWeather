//
//  Tool.h
//  xm2
//
//  Created by 徐xj on 2021/7/26.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UiKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject
-(NSString*)returnDate:(NSDate*)date;
-(NSString*)returnWeekdays:(NSDate*)date;
+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;
-(UIColor*)returnWeatherBGColor:(NSString*)weatherType;
-(NSString *)returnNeedDay:(NSString*)getDateString;
-(NSString*)returnWeek:(NSString*)weekday;
-(NSString*)returnWeatherType:(NSString*)weatherType;
-(UIImage*)returnWeatherImg:(NSString*)weatherType;
-(NSString*)returnMsg:(NSString*)weatherType;
@end

NS_ASSUME_NONNULL_END
