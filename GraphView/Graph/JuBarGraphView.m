//
//  JuBarGraphView.m
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/2.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import "JuBarGraphView.h"
#import "JuBarGraphCell.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface JuBarGraphView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)CGFloat unitValue;
@property (nonatomic, strong)NSMutableArray *accumulatedTimeArray;
@property (nonatomic, strong)NSMutableArray *subtractValueArray;
@property (nonatomic, assign)NSInteger maxValue;
@property (nonatomic, assign)NSInteger minValue;

@property (nonatomic, assign)BOOL isShowAnimation;
//@property (nonatomic, strong)NSMutableArray *animationBoolArray;
@end

@implementation JuBarGraphView

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
    self.accumulatedTimeArray = [NSMutableArray new];
    self.subtractValueArray = [NSMutableArray new];
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[JuBarGraphCell class] forCellReuseIdentifier:NSStringFromClass([JuBarGraphCell class])];
    self.tableView.tableFooterView = [UIView new];
    [self addSubview:self.tableView];
    
    self.isShowAnimation = YES;

}

-(void)setValuesArray:(NSArray *)valuesArray{
    _valuesArray = valuesArray;
//    [self setupAnimationBoolArrayWithCount:valuesArray.count];
    CGFloat min,max;
    
    min = max = [[valuesArray firstObject] integerValue];
    
    NSInteger accumulatedTime = 0;

    for (int i=0; i<valuesArray.count; i++) {
        NSInteger val = [[valuesArray objectAtIndex:i] integerValue];
        
        if (val>max) {
            max = val;
        }
        
        if (val<min) {
            min = val;
        }
        
        accumulatedTime += val;
        [self.accumulatedTimeArray addObject:@(accumulatedTime)];
        
        if(i == 0){
            [self.subtractValueArray addObject:@(0)];
        }
        if (i>0){
            NSUInteger previousVal = [valuesArray[i-1] integerValue];
            NSInteger substractValue = val - previousVal;
            [self.subtractValueArray addObject:@(substractValue)];
        }
    }
    
    if (max == 0) {
        max = 1;
    }
    self.minValue = min;
    self.maxValue = max;
    self.unitValue = (ScreenWidth-35-2-60)/max;
    [self.tableView reloadData];
}

//- (void)setupAnimationBoolArrayWithCount:(NSInteger)count{
//    self.animationBoolArray = [NSMutableArray new];
//    NSInteger i = 0;
//    while (i<count) {
//        [self.animationBoolArray addObject:@(YES)];
//        i++;
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.valuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JuBarGraphCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JuBarGraphCell class])];
    NSNumber *timeValue = self.valuesArray[indexPath.row];
    NSNumber *subtractValue = self.subtractValueArray[indexPath.row];
    NSNumber *accumulatedTime = self.accumulatedTimeArray[indexPath.row];
    cell.indexRow = indexPath.row;
    cell.unitValue = self.unitValue;
    cell.timeValue = timeValue.integerValue;
    cell.subtractValue = subtractValue.integerValue;
    cell.accumulatedTime = accumulatedTime.integerValue;
    cell.fillColor = [self judgeMaxOrMin:timeValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    JuBarGraphCell *juCell = (JuBarGraphCell *)cell;
    
    if (indexPath.row >= self.tableView.indexPathsForVisibleRows.count){
        _isShowAnimation = NO;
    }
    
    if (_isShowAnimation){
        [juCell startAnimationWithDelayTime:indexPath.row*0.1];
    }
}


- (UIColor *)judgeMaxOrMin:(NSNumber *)timeValue{
    if (timeValue.integerValue == self.maxValue){
        return [UIColor colorWithRed:0.97 green:0.91 blue:0.58 alpha:1.00];
    }else if (timeValue.integerValue == self.minValue){
        return [UIColor colorWithRed:0.60 green:0.86 blue:0.97 alpha:1.00];
        
    }else{
        return [UIColor colorWithRed:1.00 green:0.76 blue:0.80 alpha:1.00];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
