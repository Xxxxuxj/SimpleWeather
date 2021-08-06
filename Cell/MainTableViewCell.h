//
//  MainTableViewCell.h
//  xm2
//
//  Created by 徐xj on 2021/7/28.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImgView;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureRangeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *windImgView;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UIImageView *humidityImgView;
@property (weak, nonatomic) IBOutlet UILabel *humidityRange;


@end

NS_ASSUME_NONNULL_END
