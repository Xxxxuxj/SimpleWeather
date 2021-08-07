//
//  RightTableViewCell.m
//  xm2
//
//  Created by 徐xj on 2021/7/22.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "RightTableViewCell.h"
@implementation RightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //cell初始化
    UIImage* img=[[UIImage imageNamed:@"delete"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.titleLabel.highlightedTextColor=[UIColor blackColor];
    
    [self.deleteBtn setImage:img forState:0];

    self.backgroundColor=[UIColor colorWithRed:(40.0/255.0) green:(37.0/255.0) blue:(40.0/255.0) alpha:1.0];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



//删除按钮的事件
- (IBAction)deletCity:(id)sender {
    //发送通知到rightTableViewController 进行删除
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteCity" object:nil userInfo:@{@"chooseCity":self.titleLabel.text}];
}
@end
