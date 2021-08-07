//
//  Tool.m
//  xm2
//
//  Created by 徐xj on 2021/7/26.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "Tool.h"

@implementation Tool


//返回周几 中文
-(NSString*)stringWeekdays:(NSString*)wd{
    
    if([wd isEqual:@"Monday"]){
        return @"周一";
    }else if([wd isEqual:@"Tuesday"]){
        return @"周二";
    }else if([wd isEqual:@"Wednesday"]){
        return @"周三";
    }
    else if([wd isEqual:@"Thursday"]){
        return @"周四";
    }else if([wd isEqual:@"Friday"]){
        return @"周五";
    }
    else if([wd isEqual:@"Saturday"]){
        return @"周六";
    }
    else if([wd isEqual:@"Sunday"]){
        return @"周日";
    }
    return @"--";
}




//格式化星期几
-(NSString*)returnWeekdays:(NSDate*)date{
    NSDateFormatter* dateFormatter=[NSDateFormatter new];
    dateFormatter.locale=[NSLocale localeWithLocaleIdentifier:@"ch"];
    dateFormatter.dateFormat=@"EEEE";
    
    
    
    return [self stringWeekdays:[dateFormatter stringFromDate:date]];
}


//格式化月份日期
-(NSString*)returnDate:(NSDate*)date{
    NSDateFormatter* dateFormatter=[NSDateFormatter new];
    dateFormatter.locale=[NSLocale localeWithLocaleIdentifier:@"ch"];
    dateFormatter.dateFormat=@"MM.dd";
    return [dateFormatter stringFromDate:date];
}



//将十六进制转换为颜色
+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}




//格式化请求的天气转换为所需要的天气
-(NSString*)returnWeatherType:(NSString*)weatherType{
    
    NSString* path=[[NSBundle mainBundle]pathForResource:@"weatherBG" ofType:@"plist"];
    if(path != nil){
        NSDictionary* json=[NSDictionary dictionaryWithContentsOfFile:path];
        for(NSString* str in [json allKeys]){
            if([weatherType hasPrefix:str]){
                //NSLog(@"%@",str);
                return str;
            }else if([weatherType hasSuffix:str]){
                return str;
            }
        }
    }
    return weatherType;
}




//根据weatherType 得到相应的提示message
-(NSString*)returnMsg:(NSString*)weatherType{
    
    NSString* path=[[NSBundle mainBundle]pathForResource:@"msg" ofType:@"plist"];
    if(path != nil){
        NSDictionary* json=[NSDictionary dictionaryWithContentsOfFile:path];
        for(NSString* str in [json allKeys]){
            if([weatherType hasPrefix:str]){
                //NSLog(@"%@",str);
                return json[str];
            }else if([weatherType hasSuffix:str]){
                return json[str];
            }
        }
    }
    return weatherType;
}




//根据weatherType 得到相应的图片
-(UIImage*)returnWeatherImg:(NSString*)weatherType{
    
    NSString* path=[[NSBundle mainBundle]pathForResource:@"weatherImg" ofType:@"plist"];
    if(path != nil){
        NSDictionary* json=[NSDictionary dictionaryWithContentsOfFile:path];
        for(NSString* str in [json allKeys]){
            if([weatherType hasPrefix:str] ||[weatherType hasSuffix:str]){
                //NSLog(@"%@",str);
                return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",json[str]]];
            }
        }
    }
    return [UIImage imageNamed:weatherType];
}




//根据weatherType 得到对应的颜色
//使用到了十六进制转换为颜色的方法
-(UIColor*)returnWeatherBGColor:(NSString*)weatherType{
    
    NSString* path=[[NSBundle mainBundle]pathForResource:@"weatherBG" ofType:@"plist"];
    if(path != nil){
        NSDictionary* json=[NSDictionary dictionaryWithContentsOfFile:path];
        for(NSString* str in [json allKeys]){
            if([str isEqualToString:weatherType]||[weatherType hasPrefix:str]||[weatherType hasSuffix:str]){
                NSString* key=str;
                NSString* value=json[key];
                return [Tool colorWithHexString:value alpha:1.0];
            }
        }
    }
    return [UIColor grayColor];
}




//返回格式为MM/dd的日期
-(NSString *)returnNeedDay:(NSString*)getDateString{
    NSDateFormatter* dateFormatter=[NSDateFormatter new];
    dateFormatter.locale=[NSLocale localeWithLocaleIdentifier:@"ch"];
    dateFormatter.dateFormat=@"YYYY-MM-dd";
    NSDate* date=[dateFormatter dateFromString:getDateString];
    NSDateFormatter* newFormatter=[NSDateFormatter new];
    newFormatter.locale=[NSLocale localeWithLocaleIdentifier:@"ch"];
    newFormatter.dateFormat=@"MM/dd";
    NSString* datestr=[newFormatter stringFromDate:date];
    return datestr;
    
}




//根据星期几返回周几
-(NSString*)returnWeek:(NSString*)weekday{
    if([weekday isEqualToString:@"星期一"]){
        return @"周一";
    }else if([weekday isEqualToString:@"星期二"]){
        return @"周二";
    }else if([weekday isEqualToString:@"星期三"]){
        return @"周三";
    }else if([weekday isEqualToString:@"星期四"]){
        return @"周四";
    }else if([weekday isEqualToString:@"星期五"]){
        return @"周五";
    }else if([weekday isEqualToString:@"星期六"]){
        return @"周六";
    }else if([weekday isEqualToString:@"星期日"]){
        return @"周日";
    }
    return @"--";
}


@end
