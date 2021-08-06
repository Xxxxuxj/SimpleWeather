//
//  addCityView.h
//  xm2
//
//  Created by 徐xj on 2021/8/1.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface addCityView : UIView
- (IBAction)cancelBtn:(id)sender;
- (IBAction)submitBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

NS_ASSUME_NONNULL_END
