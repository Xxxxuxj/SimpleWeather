//
//  MainTableViewCell.m
//  xm2
//
//  Created by 徐xj on 2021/7/28.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UIAccessibilityTraitNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
