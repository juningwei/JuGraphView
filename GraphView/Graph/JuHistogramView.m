//
//  JuHistogramView.m
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/2.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import "JuHistogramView.h"

static CGFloat kGraphRangeTopMargin = 30;
static CGFloat kGraphRangeBottomMargin = 25;
static CGFloat kGraphRangeRightMargin = 25;

@interface JuHistogramView ()
@property (nonatomic, assign)CGFloat leftMargin;
@property (nonatomic, assign)CGFloat unitValue;


@end

@implementation JuHistogramView

-(void)awakeFromNib{
    [self setupInit];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupInit];
    }
    return self;
}

- (void)setupInit{
    self.backgroundColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.45 alpha:1.00];
    self.fillColor = [UIColor colorWithRed:1.00 green:0.60 blue:0.70 alpha:1.00];
    self.labelTextColor = [UIColor whiteColor];
    self.axisColor = [UIColor colorWithRed:0.95 green:0.11 blue:0.45 alpha:1.00];
    self.space = 2;

}

-(void)setHorizentalTitles:(NSArray *)horizentalTitles{
    _horizentalTitles = horizentalTitles;
    CGFloat unitStep = (CGRectGetWidth(self.frame)-self.leftMargin-kGraphRangeRightMargin)/(horizentalTitles.count-1);
    CGFloat width = ((CGRectGetWidth(self.frame)-self.leftMargin-kGraphRangeRightMargin)-self.valuesArray.count*self.space)/self.valuesArray.count;

    for (int i=0;i<horizentalTitles.count;i++){
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = self.labelTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = horizentalTitles[i];
        [label sizeToFit];
        [label setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin, CGRectGetWidth(label.frame), CGRectGetHeight(label.frame))];
//        label.backgroundColor = [UIColor yellowColor];
        CGPoint tempCenter = label.center;
        if (i == 0){
            tempCenter.x = self.leftMargin+width/2;

        }else{
            tempCenter.x = self.leftMargin+i*unitStep-width/2;

        }
        label.center = tempCenter;
        [self addSubview:label];
    }
}

-(void)setValuesArray:(NSArray *)valuesArray{
    _valuesArray = valuesArray;
    
    CGFloat min,max;
    
    min = max = [[valuesArray firstObject] floatValue];
    
    for (NSInteger i=0; i<valuesArray.count; i++) {
        CGFloat val = [[valuesArray objectAtIndex:i] floatValue];
        
        if (val>max) {
            max = val;
        }
        
        if (val<min) {
            min = val;
        }
    }
    
    if (max == 0) {
        max = 1;
    }
    
    NSInteger maxValue = (NSInteger)max;
    NSString *maxValueStr = [NSString stringWithFormat:@"%ld",(long)maxValue];
    self.leftMargin = [maxValueStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width+3;
    
    NSInteger axisMaxValue = (NSInteger)[self getUpperRoundNumber:maxValue forGridStep:5];
    
    NSInteger stepValue = axisMaxValue/5;
    NSMutableArray *stepArr = [NSMutableArray new];
    NSInteger i = 0;
    while (i <= axisMaxValue) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)i];
        [stepArr addObject:str];
        
        i+=stepValue;
        
    }
    NSInteger stepPt = (CGRectGetHeight(self.frame)-kGraphRangeTopMargin-kGraphRangeBottomMargin)/5;
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    for (int i=0;i<6;i++){
        UILabel *verticalLabel = [[UILabel alloc]init];
        verticalLabel.font = [UIFont systemFontOfSize:12];
        verticalLabel.textColor = self.labelTextColor;
        verticalLabel.text = stepArr[i];
        verticalLabel.textAlignment = NSTextAlignmentRight;
        [verticalLabel sizeToFit];
        [verticalLabel setFrame:CGRectMake(0, 0, self.leftMargin-1, CGRectGetHeight(verticalLabel.frame))];
        CGPoint tempCenter = verticalLabel.center;
        tempCenter.y = CGRectGetHeight(self.frame)-kGraphRangeBottomMargin-i*stepPt;
        verticalLabel.center = tempCenter;
        [self addSubview:verticalLabel];
    }
    
    
    self.unitValue = (CGRectGetHeight(self.frame)-kGraphRangeTopMargin-kGraphRangeBottomMargin)/axisMaxValue;
    [self setNeedsDisplay];
    
}

-(void)setVerticalTitle:(NSString *)verticalTitle{
    _verticalTitle = verticalTitle;
    UILabel *label = [[UILabel alloc]init];
    label.text = verticalTitle;
    label.textColor = self.labelTextColor;
    label.font = [UIFont systemFontOfSize:12];
    [label sizeToFit];
    [label setFrame:CGRectMake(self.leftMargin+1, 3, CGRectGetWidth(label.frame), CGRectGetHeight(label.frame))];
    [self addSubview:label];
    
    
}

-(void)setHorizentalTitle:(NSString *)horizentalTitle{
    _horizentalTitle = horizentalTitle;
    UILabel *label = [[UILabel alloc]init];
    label.text = horizentalTitle;
    label.textColor = self.labelTextColor;
    label.font = [UIFont systemFontOfSize:12];
    [label sizeToFit];
    [label setFrame:CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(label.frame), CGRectGetHeight(self.frame)-kGraphRangeBottomMargin, CGRectGetWidth(label.frame), CGRectGetHeight(label.frame))];
    [self addSubview:label];

}

-(void)drawRect:(CGRect)rect{
    [self drawAxis];
    CGFloat width = ((CGRectGetWidth(self.frame)-self.leftMargin-kGraphRangeRightMargin)-self.valuesArray.count*self.space)/self.valuesArray.count;
    
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    UIBezierPath *path = [UIBezierPath bezierPath];

    for (int i=0;i<self.valuesArray.count;i++){
        CGFloat x = self.leftMargin+(i+1)*self.space+i*width;
        CGFloat num = [self.valuesArray[i] floatValue];
        CGFloat y = CGRectGetHeight(self.frame)-kGraphRangeTopMargin-kGraphRangeBottomMargin-num*self.unitValue;
//        CGFloat height = num*self.unitValue;
        
        [fillPath moveToPoint:CGPointMake(x, y)];
        [fillPath addLineToPoint:CGPointMake(x+width, y)];
        [fillPath addLineToPoint:CGPointMake(x+width, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
        [fillPath addLineToPoint:CGPointMake(x, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
        [fillPath closePath];
        
        [path moveToPoint:CGPointMake(x, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin-0.1)];
        [path addLineToPoint:CGPointMake(x+width, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin-0.1)];
        [path addLineToPoint:CGPointMake(x+width, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
        [path addLineToPoint:CGPointMake(x, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
        [path closePath];

    }
    [self.fillColor set];
    
    
    CAShapeLayer* fillLayer = [CAShapeLayer layer];
    fillLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y , self.bounds.size.width, self.bounds.size.height);
    fillLayer.bounds = self.bounds;
    fillLayer.path = fillPath.CGPath;
    fillLayer.strokeColor = nil;
    fillLayer.fillColor = [UIColor colorWithRed:0.58 green:0.94 blue:0.95 alpha:1].CGColor;
    fillLayer.lineWidth = 0;
    fillLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:fillLayer];
    //        [self.layers addObject:fillLayer];
    
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = 0.5;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.fromValue = (id)path.CGPath;
    fillAnimation.toValue = (id)fillPath.CGPath;
    [fillLayer addAnimation:fillAnimation forKey:@"path"];

//    [fillPath fill];
}

- (void)drawAxis{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(self.leftMargin, 8)];
//    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)-kGraphRangeRightMargin, 8)];
    
    [bezierPath addLineToPoint:CGPointMake(self.leftMargin, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)-kGraphRangeRightMargin, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];

//    [bezierPath closePath];
    [[UIColor blackColor]set];
    [bezierPath stroke];
    
    UIBezierPath *axisPath = [UIBezierPath bezierPath];
    
    [axisPath moveToPoint:CGPointMake(self.leftMargin, kGraphRangeTopMargin)];
    [axisPath addLineToPoint:CGPointMake(self.leftMargin, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
    [axisPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)-15, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
    [[UIColor blackColor]set];
    [axisPath stroke];
    
}


- (CGFloat)getUpperRoundNumber:(CGFloat)value forGridStep:(int)gridStep
{
    if(value <= 0)
        return 0;
    
    CGFloat logValue = log10f(value);
    CGFloat scale = powf(10, floorf(logValue));
    CGFloat n = ceilf(value / scale * 4);
    
    int tmp = (int)(n) % gridStep;
    
    if(tmp != 0) {
        n += gridStep - tmp;
    }
    NSLog(@"n * scale / 4.0f===%f",n * scale / 4.0f);
    return n * scale / 4.0f;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
