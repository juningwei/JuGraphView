//
//  ViewController.m
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/1.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import "ViewController.h"
#import "JuGraphView.h"
#import "JuBarGraphView.h"
#import "JuHistogramView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet JuGraphView *graphView1;
@property (weak, nonatomic) IBOutlet JuGraphView *graphView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.graphView1.valuesArray = @[@12,@34,@45,@66,@88,@45,@34];
    self.graphView1.verticalTitle = @"海拔/米";
    self.graphView1.horizentalTitle = @"时间/分";
    self.graphView1.horizentalTitles = @[@"10",@"20",@"30"];
//    [self.view addSubview:self.graphView1];
    
    self.graphView2.valuesArray = @[@100,@120,@98,@110,@130,@134,@136];
    self.graphView2.verticalTitle = @"步频/步";
    self.graphView2.horizentalTitle = @"时间/分";
    self.graphView2.horizentalTitles = @[@"10",@"20",@"30"];
//    [self.view addSubview:self.graphView2];
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
