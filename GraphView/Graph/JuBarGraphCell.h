//
//  JuBarGraphCell.h
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/2.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuBarGraphCell : UITableViewCell
@property (nonatomic, assign)CGFloat unitValue;

@property (nonatomic, assign)NSInteger indexRow;
@property (nonatomic, assign)NSInteger timeValue;
@property (nonatomic, assign)NSInteger subtractValue;
@property (nonatomic, assign)NSInteger accumulatedTime;
@property (nonatomic,strong)UIColor *fillColor;

- (void)startAnimationWithDelayTime:(CGFloat)time;
@end
