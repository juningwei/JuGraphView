//
//  JuHistogramView.h
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/2.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuHistogramView : UIView
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, strong)UIColor *labelTextColor;
@property (nonatomic, strong)UIColor *axisColor;
@property (nonatomic, assign)CGFloat space;

@property (nonatomic, copy)NSArray *horizentalTitles;
@property (nonatomic, copy)NSString *horizentalTitle;
@property (nonatomic, copy)NSString *verticalTitle;
@property (nonatomic, copy)NSArray *valuesArray;

@end
