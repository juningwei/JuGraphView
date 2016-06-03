//
//  ThirdViewController.m
//  GraphView
//
//  Created by 鞠凝玮 on 16/6/3.
//  Copyright © 2016年 Ju. All rights reserved.
//

#import "ThirdViewController.h"
#import "JuBarGraphView.h"
@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet JuBarGraphView *barGraphView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.barGraphView.valuesArray = @[@(322),@(334),@(289),@(355),@(360),@(313),@(222),@(231),@(400),@(360),@(322),@(334),@(289),@(355),@(360),@(313),@(222),@(231),@(400),@(360)];
//    [self.view addSubview:self.barGraphView];

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
