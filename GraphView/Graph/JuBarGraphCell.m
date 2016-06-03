//
//  JuBarGraphCell.m
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/2.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import "JuBarGraphCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface BarView : UIView
@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, strong)UIColor *fillColor;
@end

@implementation BarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    }
    return self;
}

-(void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    [self setNeedsDisplay];

}
-(void)drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _progress, CGRectGetHeight(rect))];
    
    [self.fillColor set];
    [path fill];
}

@end

static CGFloat const kLabelRightMargin = 2;
static CGFloat const kBottomMargin = 2;

static CGFloat const kLabelWdith = 35;


@interface JuBarGraphCell ()
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *paceLabel;
@property (nonatomic, strong)UILabel *substarctLabel;

@property (nonatomic, strong)UILabel *totoalTimeLabel;
@property (nonatomic ,strong)BarView *barView;

@end

@implementation JuBarGraphCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kLabelWdith, CGRectGetHeight(self.frame)-kBottomMargin)];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        self.leftLabel.font = [UIFont systemFontOfSize:14];
        self.leftLabel.textColor = [UIColor whiteColor];
        self.leftLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.32 blue:0.44 alpha:1.00];
        [self.contentView addSubview:self.leftLabel];
        
        self.barView = [[BarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftLabel.frame)+kLabelRightMargin, 0, ScreenWidth-kLabelWdith-kLabelRightMargin, CGRectGetHeight(self.frame)-kBottomMargin)];
        [self.contentView addSubview:self.barView];
        
        self.paceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.barView.frame), 0, 55, CGRectGetHeight(self.frame)-kBottomMargin)];
        self.paceLabel.font = [UIFont systemFontOfSize:14];
        self.paceLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.paceLabel];
        
        self.substarctLabel = [[UILabel alloc]init];
        self.substarctLabel.font = [UIFont systemFontOfSize:12];
        self.substarctLabel.textAlignment = NSTextAlignmentCenter;
        self.substarctLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.substarctLabel];
        
        
        self.totoalTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-70, 0, 70, CGRectGetHeight(self.frame)-kBottomMargin)];
        self.totoalTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.totoalTimeLabel.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
        self.totoalTimeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.totoalTimeLabel];
        
        
    }
    return self;
}

-(void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
    self.leftLabel.text = [NSString stringWithFormat:@"%ld",(long)indexRow+1];
}

-(void)setTimeValue:(NSInteger)timeValue{
    _timeValue = timeValue;
    self.paceLabel.text = [self convertToStringWithInt:timeValue];
    
    self.barView.progress = timeValue*self.unitValue;
}

-(void)setSubtractValue:(NSInteger)subtractValue{
    _subtractValue = subtractValue;
    self.substarctLabel.text = [self convertToStringWithInt:subtractValue];
    [self.substarctLabel sizeToFit];
    [self.substarctLabel setFrame:CGRectMake(CGRectGetMinX(self.barView.frame)+self.timeValue*self.unitValue-CGRectGetWidth(self.substarctLabel.frame), 0, CGRectGetWidth(self.substarctLabel.frame), CGRectGetHeight(self.frame)-kBottomMargin)];
}

-(void)setAccumulatedTime:(NSInteger)accumulatedTime{
    _accumulatedTime = accumulatedTime;
    self.totoalTimeLabel.text = [self convertToHMSStringWithInt:accumulatedTime];
}

-(void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    self.barView.fillColor = fillColor;
}

- (void)startAnimationWithDelayTime:(CGFloat)time{
    self.contentView.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
    [UIView animateWithDuration:0.5 delay:time usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        
    } completion:nil];
}


- (NSString *)convertToStringWithInt:(NSInteger)intValue{
    NSInteger value = intValue < 0 ? -intValue : intValue;
    
    NSInteger minInt = value/60;
    NSInteger secInt = value%60;
    
    if (intValue < 0){
        return [NSString stringWithFormat:@"-%02ld'%02ld\"",(long)minInt,(long)secInt];
    }else if (intValue > 0){
        return [NSString stringWithFormat:@"+%02ld'%02ld\"",(long)minInt,(long)secInt];

    }else{
        return [NSString stringWithFormat:@"%02ld'%02ld\"",(long)minInt,(long)secInt];
    }
}

- (NSString *)convertToHMSStringWithInt:(NSInteger)intValue{
    NSInteger hourInt = intValue/3600;
    NSInteger minInt = intValue%3600/60;
    NSInteger secInt = intValue%3600%60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hourInt,(long)minInt,(long)secInt];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
