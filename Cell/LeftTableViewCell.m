//
//  LeftTableViewCell.m
//  xm2
//
//  Created by 徐xj on 2021/7/22.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "LeftTableViewCell.h"
@interface LeftTableViewCell()

@end


@implementation LeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //cell初始化
    self.backgroundColor=[UIColor colorWithRed:(40.0/255.0) green:(37.0/255.0) blue:(40.0/255.0) alpha:1.0];
    self.selectionStyle=UIAccessibilityTraitNone;
    self.weatherBG.layer.cornerRadius=8.0;
    self.weatherBG.layer.masksToBounds=true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
