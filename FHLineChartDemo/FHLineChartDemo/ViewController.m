//
//  ViewController.m
//  FHLineChartDemo
//
//  Created by TK on 2018/3/23.
//  Copyright © 2018年 Hesvit. All rights reserved.
//

#import "ViewController.h"
#import "FHLineChartView.h"

@interface ViewController ()
{
    NSTimer *_timer;
    NSInteger _x;
}

@property (nonatomic, strong) FHLineChartView *lineChartView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.lineChartView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.lineChartView.dataSources removeAllObjects];
    _x = 0;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshLineChartView) userInfo:nil repeats:YES];
    }
}

- (void)refreshLineChartView {
    _x++;
    CGFloat y = arc4random_uniform(100)/10.0;
    CGPoint point = CGPointMake(_x, y);
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    [self.lineChartView.dataSources addObject:pointValue];
    [self.lineChartView setNeedsDisplay];
}

- (FHLineChartView *)lineChartView {
    if (!_lineChartView) {
        _lineChartView = [[FHLineChartView alloc] initWithFrame:CGRectMake(20, 80, self.view.bounds.size.width-40, 400)];
        _lineChartView.backgroundColor = [UIColor lightGrayColor];
        _lineChartView.solidLineType = FHLineChartViewLineTypeCurve;
        _lineChartView.dashLineType = FHLineChartViewLineTypeNormal;
    }
    return _lineChartView;
}

@end
