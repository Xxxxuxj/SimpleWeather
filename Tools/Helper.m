//
//  Helper.m
//  xm2
//
//  Created by 徐xj on 2021/7/22.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "Helper.h"

@implementation Helper

-(instancetype)init{
    if(self=[super init]){
    //构造时 就将存放历史城市的文件路径得到
    history_city_path=[NSString stringWithFormat:@"%@/history_city_path.txt",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]];
    }
    return self;
}


//返回一个存放历史城市的NSArray
-(NSArray*)readChaceCity{
    NSArray* array=[NSArray arrayWithContentsOfFile:history_city_path];
    if(array == nil){
        return @[];
    }else{
        if(array.count == 0){
            return @[];
        }else{
            NSMutableArray* cities=[NSMutableArray new];
            for(NSString *ele in array){
                [cities addObject:ele];
            }
            return cities;
        }
    }
}


//插入一个city到文件中 插入的city排首位
-(BOOL)insertCity:(NSString* )city{
    NSMutableArray* old_cities=[NSMutableArray new];
    for(NSString* ele in [self readChaceCity]){
        [old_cities addObject:ele];
    }
    
    if([old_cities containsObject:city]){
        NSUInteger index=[old_cities indexOfObject:city];
        [old_cities removeObjectAtIndex:index];
    }
    
    [old_cities insertObject:city atIndex:0];
    
    //写入
    return [old_cities writeToFile:history_city_path atomically:true];
    
    
}


//删除一个city 然后写入到文件中
-(BOOL)deleteCity:(NSString* )city{
    NSMutableArray* old_cities=[NSMutableArray new];
    for(NSString* ele in [self readChaceCity]){
        [old_cities addObject:ele];
    }
    if([old_cities containsObject:city]){
        NSUInteger index=[old_cities indexOfObject:city];
        [old_cities removeObjectAtIndex:index];
    }
    
    //[old_cities insertObject:city atIndex:0];
    
    return [old_cities writeToFile:history_city_path atomically:true];
}


//清空historycity 但是保留第一个 即当前显示的城市
-(void)removeCity{
    NSMutableArray* old_cities=[NSMutableArray new];
    for(NSString* ele in [self readChaceCity]){
        [old_cities addObject:ele];
    }
    for(int i=1;i<old_cities.count;i++){
        [self deleteCity:old_cities[i]];
    }

}





@end
