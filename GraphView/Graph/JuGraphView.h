//
//  JuGraphView.h
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/1.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuGraphView : UIView
@property (nonatomic, strong)UIColor *lineColor;
@property (nonatomic, assign)CGFloat lineWidth;
@property (nonatomic, copy)NSArray *fillColors;
@property (nonatomic, strong)UIColor *labelColor;
@property (nonatomic, strong)UIColor *axisColor;
@property (nonatomic, copy)NSArray *horizentalTitles;
@property (nonatomic, copy)NSString *horizentalTitle;
@property (nonatomic, copy)NSString *verticalTitle;
@property (nonatomic, copy)NSArray *valuesArray;
@end
