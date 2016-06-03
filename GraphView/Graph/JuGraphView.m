//
//  JuGraphView.m
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/1.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import "JuGraphView.h"
#import "UIBezierPath+curved.h"

static CGFloat kGraphRangeTopMargin = 30;
static CGFloat kGraphRangeBottomMargin = 25;
static CGFloat kGraphRangeRightMargin = 25;


@interface JuGraphView ()
@property (nonatomic, strong)UILabel *vertivalLabel;
@property (nonatomic, strong)UILabel *horizentalLabel;
@property (nonatomic, assign)CGFloat leftMargin;
@property (nonatomic, strong)CAGradientLayer *gradient;

@property (nonatomic, assign)CGFloat unitValue;
@property (nonatomic, assign)CGFloat space;
//@property (nonatomic, strong) NSMutableArray* layers;

@end

@implementation JuGraphView

-(void)awakeFromNib{
    [self setupInit];
    [self setupLabel];

}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupInit];
        [self setupLabel];
        

    }
    return self;
}



- (void)setupInit{
    self.backgroundColor = [UIColor lightGrayColor];
    self.lineColor = [UIColor greenColor];
    self.lineWidth = 2;
    self.fillColors = @[[UIColor blueColor],[UIColor whiteColor]];
    self.labelColor = [UIColor greenColor];
    self.axisColor = [UIColor grayColor];
//    _layers = [NSMutableArray array];

}

- (void)setupLabel{
    UILabel *vertivalLabel = [[UILabel alloc]init];
    vertivalLabel.font = [UIFont systemFontOfSize:12];
    vertivalLabel.textColor = self.labelColor;
    [self addSubview:vertivalLabel];
    self.vertivalLabel = vertivalLabel;
    
    UILabel *horizentalLabel = [[UILabel alloc]init];
    horizentalLabel.font = [UIFont systemFontOfSize:12];
    horizentalLabel.textColor = self.labelColor;
    [self addSubview:horizentalLabel];
    self.horizentalLabel = horizentalLabel;
    

}

-(void)setVerticalTitle:(NSString *)verticalTitle{
    _verticalTitle = verticalTitle;
    self.vertivalLabel.text = verticalTitle;
    [self.vertivalLabel sizeToFit];
    [self.vertivalLabel setFrame:CGRectMake(3, 3, CGRectGetWidth(self.vertivalLabel.frame), CGRectGetHeight(self.vertivalLabel.frame))];
}

-(void)setHorizentalTitle:(NSString *)horizentalTitle{
    _horizentalTitle = horizentalTitle;
    self.horizentalLabel.text = horizentalTitle;
    [self.horizentalLabel sizeToFit];
    [self.horizentalLabel setFrame:CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(self.horizentalLabel.frame)-2, CGRectGetHeight(self.frame)-3-CGRectGetHeight(self.horizentalLabel.frame), CGRectGetWidth(self.horizentalLabel.frame), CGRectGetHeight(self.horizentalLabel.frame))];

}

-(void)setHorizentalTitles:(NSArray *)horizentalTitles{
    _horizentalTitles = horizentalTitles;
    
    NSInteger stepPt = (CGRectGetWidth(self.frame)-self.leftMargin-kGraphRangeRightMargin)/(horizentalTitles.count+1);
    for (int i=0;i<horizentalTitles.count;i++){
        UILabel *verticalLabel = [[UILabel alloc]init];
        verticalLabel.font = [UIFont systemFontOfSize:12];
//        verticalLabel.backgroundColor = [UIColor yellowColor];
        verticalLabel.textColor = self.labelColor;
        verticalLabel.text = horizentalTitles[i];
        [verticalLabel sizeToFit];
        [verticalLabel setFrame:CGRectMake(self.leftMargin+stepPt*(i+1), CGRectGetHeight(self.frame)-kGraphRangeBottomMargin, CGRectGetWidth(verticalLabel.frame), CGRectGetHeight(verticalLabel.frame))];
        CGPoint tempCenter = verticalLabel.center;
        tempCenter.x = self.leftMargin+(i+1)*stepPt;
        verticalLabel.center = tempCenter;
        [self addSubview:verticalLabel];
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
    
    NSInteger axisMaxValue = (NSInteger)[self getUpperRoundNumber:maxValue forGridStep:3];
    
    NSInteger stepValue = axisMaxValue/3;
    NSMutableArray *stepArr = [NSMutableArray new];
    NSInteger i = 0;
    while (i <= axisMaxValue) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)i];
        [stepArr addObject:str];
        
        i+=stepValue;
        
    }
    NSInteger stepPt = (CGRectGetHeight(self.frame)-kGraphRangeTopMargin-kGraphRangeBottomMargin)/3;
    for (int i=0;i<4;i++){
        UILabel *verticalLabel = [[UILabel alloc]init];
        verticalLabel.font = [UIFont systemFontOfSize:12];
        verticalLabel.textColor = self.labelColor;
        verticalLabel.text = stepArr[i];
        [verticalLabel sizeToFit];
        [verticalLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(verticalLabel.frame), CGRectGetHeight(verticalLabel.frame))];
        CGPoint tempCenter = verticalLabel.center;
        tempCenter.y = CGRectGetHeight(self.frame)-kGraphRangeBottomMargin-i*stepPt;
        verticalLabel.center = tempCenter;
        [self addSubview:verticalLabel];
    }
    
    
    self.unitValue = (CGRectGetHeight(self.frame)-kGraphRangeTopMargin-kGraphRangeBottomMargin)/axisMaxValue;
    self.space = (self.frame.size.width)/(self.valuesArray.count+1);
    

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

- (void)drawAxis{
//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:CGPointMake(self.leftMargin, kGraphRangeTopMargin)];
//    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)-kGraphRangeRightMargin, kGraphRangeTopMargin)];
//    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)-kGraphRangeRightMargin, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
//    
//    [bezierPath addLineToPoint:CGPointMake(self.leftMargin, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
//    [bezierPath closePath];
//    [[UIColor orangeColor]set];
//    [bezierPath stroke];
    
    UIBezierPath *axisPath = [UIBezierPath bezierPath];
    
    [axisPath moveToPoint:CGPointMake(self.leftMargin, kGraphRangeTopMargin-5)];
    [axisPath addLineToPoint:CGPointMake(self.leftMargin, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
    [axisPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)-15, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin)];
    [[UIColor redColor]set];
    [axisPath stroke];

}

-(void)drawRect:(CGRect)rect{
    [self drawAxis];

    UIBezierPath *noPath = [self getLinePath:0  close:NO];
    UIBezierPath *path = [self getLinePath:self.unitValue close:NO];
    
    UIBezierPath *noFill = [self getLinePath:0 close:YES];
    UIBezierPath *fill = [self getLinePath:self.unitValue close:YES];
    
    CAShapeLayer* fillLayer = [CAShapeLayer layer];
    fillLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y , self.bounds.size.width, self.bounds.size.height);
    fillLayer.bounds = self.bounds;
    fillLayer.path = fill.CGPath;
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
    fillAnimation.fromValue = (id)noFill.CGPath;
    fillAnimation.toValue = (id)fill.CGPath;
    [fillLayer addAnimation:fillAnimation forKey:@"path"];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y , self.bounds.size.width, self.bounds.size.height);
    pathLayer.bounds = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = self.lineColor.CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = _lineWidth;
    pathLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:pathLayer];
//    [self.layers addObject:pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = (__bridge id)(noPath.CGPath);
    pathAnimation.toValue = (__bridge id)(path.CGPath);
    [pathLayer addAnimation:pathAnimation forKey:@"path"];
}

- (UIBezierPath*)getLinePath:(float)scale close:(BOOL)closed
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
        for(int i=0;i<self.valuesArray.count - 1;i++) {
            CGPoint controlPoint[2];
            CGPoint p = [self pointAtIndex:i unitValue:scale];
            
            // Start the path drawing
            if(i == 0)
                [path moveToPoint:p];
            
            CGPoint nextPoint, previousPoint, m;
            
            // First control point
            nextPoint = [self pointAtIndex:i + 1 unitValue:scale];
            previousPoint = [self pointAtIndex:i - 1 unitValue:scale];
            m = CGPointZero;
            
            if(i > 0) {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            } else {
                m.x = (nextPoint.x - p.x) / 2;
                m.y = (nextPoint.y - p.y) / 2;
            }
            
            controlPoint[0].x = p.x + m.x * 0.2;
            controlPoint[0].y = p.y + m.y * 0.2;
            
            // Second control point
            nextPoint = [self pointAtIndex:i + 2 unitValue:scale];
            previousPoint = [self pointAtIndex:i unitValue:scale];
            p = [self pointAtIndex:i + 1 unitValue:scale];
            m = CGPointZero;
            
            if(i < self.valuesArray.count - 2) {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            } else {
                m.x = (p.x - previousPoint.x) / 2;
                m.y = (p.y - previousPoint.y) / 2;
            }
            
            controlPoint[1].x = p.x - m.x * 0.2;
            controlPoint[1].y = p.y - m.y * 0.2;
            
            [path addCurveToPoint:p controlPoint1:controlPoint[0] controlPoint2:controlPoint[1]];
        }
        
    
    
    if(closed) {
        // Closing the path for the fill drawing
        [path addLineToPoint:[self pointAtIndex:self.valuesArray.count - 1 unitValue:scale]];
        [path addLineToPoint:[self pointAtIndex:self.valuesArray.count - 1 unitValue:0]];
        [path addLineToPoint:[self pointAtIndex:0 unitValue:0]];
        [path addLineToPoint:[self pointAtIndex:0 unitValue:scale]];
    }
    
    return path;
}


- (CGPoint)pointAtIndex:(NSInteger)index unitValue:(CGFloat)unitValue;
{
    if (index < 0 || index > self.valuesArray.count-1){
        return CGPointZero;
    }
    CGFloat space = (self.frame.size.width)/(self.valuesArray.count+1);
    NSNumber *value = self.valuesArray[index];

    return CGPointMake(self.leftMargin+space*index, CGRectGetHeight(self.frame)-kGraphRangeBottomMargin-value.floatValue*unitValue-1);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
