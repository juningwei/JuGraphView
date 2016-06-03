//
//  SecondViewController.m
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/3.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import "SecondViewController.h"
#import "JuHistogramView.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet JuHistogramView *histogramView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.histogramView.valuesArray = @[@(322),@(334),@(289),@(355),@(360),@(313),@(222),@(231),@(400),@(360),@(322),@(334)];
    self.histogramView.horizentalTitles = @[@"1",@"4",@"8",@"12"];
    self.histogramView.verticalTitle = @"公里";
    self.histogramView.horizentalTitle = @"日期";
//        [self.view addSubview:self.histogramView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
