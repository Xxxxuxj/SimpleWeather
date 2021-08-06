//
//  Helper.h
//  xm2
//
//  Created by 徐xj on 2021/7/22.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface Helper : NSObject
{
    NSString* history_city_path;
}

-(NSArray*)readChaceCity;
-(BOOL)insertCity:(NSString* )city;
-(BOOL)deleteCity:(NSString* )city;
-(void)removeCity;
@end

NS_ASSUME_NONNULL_END
