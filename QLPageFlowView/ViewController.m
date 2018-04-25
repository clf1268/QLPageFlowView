//
//  ViewController.m
//  QLPageFlowView
//
//  Created by cailianfeng on 2018/4/19.
//  Copyright © 2018年 cailianfeng. All rights reserved.
//

#import "ViewController.h"
#import "QLPageFlowView.h"
@interface ViewController ()<QLPageFlowViewDelegate,QLPageFlowViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QLPageFlowView * page = [[QLPageFlowView alloc] initWithFrame:CGRectMake(0, 0, 300, 200) scrollDirection:(QLPageFlowViewScrollDirectionHorizontal)];
    [self.view addSubview:page];
    page.center = self.view.center;
    page.minimumPageScale = 0.9;
    page.minimumPageAlpha = 0.4;
    page.pageSize = CGSizeMake(300, 200);
    page.delegate = self;
    page.dataSource = self;
    [page reloadData];
}

- (NSInteger)numberOfItemsInPageFlowView:(QLPageFlowView *)pageFlowView{
    return 5;
}

- (UIView *)pageFlowView:(QLPageFlowView *)pageFlowView viewForRowAtIndex:(NSInteger)index{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1];
    return view;
}

- (void)pageFlowView:(QLPageFlowView *)pageFlowView didSelectItemAtIndex:(NSInteger)index{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
