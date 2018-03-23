//
//  FHLineChartView.m
//  FHLineChartDemo
//
//  Created by TK on 2018/3/23.
//  Copyright © 2018年 Hesvit. All rights reserved.
//

#import "FHLineChartView.h"
/* 弧度 转 角度 */
#define kRadiansToDegrees(r) \
((r) * (180.0 / M_PI))

/*角度 转 弧度*/
#define kDegreesToRadians(a) \
((a) / 180.0 * M_PI)

@interface FHLineChartView ()
{
    CGFloat _originX; // 原点x坐标
    CGFloat _originY; // 原点y坐标
    CGFloat _xAxiaW; // x轴长度
    CGFloat _yAxiaH; // y轴长度
}

@end

static CGFloat kLeftPadding = 20; // y轴离视图左边缘间距
static CGFloat kBottomPadding = 40; // x轴离视图下边缘间距
static CGFloat kTopPadding = 20; // y轴离视图上边缘间距
static CGFloat kRightPadding = 20; // x轴离视图右边缘间距
static CGFloat kArrowLength = 5; // 箭头长度
static CGFloat kDotRadius = 3; // 小圆点半径
@implementation FHLineChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originX = kLeftPadding;
        _originY = self.bounds.size.height - kBottomPadding;
        _xAxiaW = self.bounds.size.width - kLeftPadding - kRightPadding;
        _yAxiaH = self.bounds.size.height - kBottomPadding - kTopPadding;
        _dataSources = [NSMutableArray array];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawXAxia]; // 绘制x轴
    [self drawYAxia]; // 绘制y轴
    [self drawYLines]; // 绘制y线
    [self drawYAxiaTexts]; // 绘制y轴文字
    [self drawXAxiaTexts]; // 绘制x轴文字
    [self drawUAxiaUnitTexts]; // 绘制y轴单位
    [self drawDatasLine]; // 绘制数据线条
    [self drawDataDots]; // 绘制数据点
}

#pragma mark - 绘制
// 绘制X轴
- (void)drawXAxia {
    
    CGPoint xAxiaStartPoint = CGPointMake(_originX, _originY); // 起点
    CGPoint xAxiaEndPoint = CGPointMake(_originX+_xAxiaW, _originY); // 终点
    [self drawLineStartPoint:xAxiaStartPoint endPoint:xAxiaEndPoint];
    
    CGPoint xAxiaArrowStartPoint = xAxiaEndPoint; //箭头的起点
    CGFloat xAxiaArrowEndPointX = _originX + _xAxiaW - kArrowLength * cos(kDegreesToRadians(30));
    CGFloat xAxiaArrowEndBottomPointY = _originY + kArrowLength * sin(kDegreesToRadians(30));
    CGFloat xAxiaArrowEndTopPointY = _originY - kArrowLength * sin(kDegreesToRadians(30));
    
    CGPoint xAxiaArrowEndBottomPoint = CGPointMake(xAxiaArrowEndPointX, xAxiaArrowEndBottomPointY);
    [self drawLineStartPoint:xAxiaArrowStartPoint endPoint:xAxiaArrowEndBottomPoint];
    
    CGPoint xAxiaArrowEndTopPoint = CGPointMake(xAxiaArrowEndPointX, xAxiaArrowEndTopPointY);
    [self drawLineStartPoint:xAxiaArrowStartPoint endPoint:xAxiaArrowEndTopPoint];
}

// 绘制y轴
- (void)drawYAxia {
    
    CGPoint yAxiaStartPoint = CGPointMake(_originX, _originY);
    CGPoint yAxiaEndPoint = CGPointMake(_originX, _originY-_yAxiaH);
    [self drawLineStartPoint:yAxiaStartPoint endPoint:yAxiaEndPoint];
    
    CGPoint yAxiaArrowStartPoint = yAxiaEndPoint;
    CGFloat yAxiaArrowEndRightPointX = _originX + kArrowLength * sin(kDegreesToRadians(30));
    CGFloat yAxiaArrowEndPointY = _originY - _yAxiaH + kArrowLength * cos(kDegreesToRadians(30));
    CGFloat yAxiaArrowEndLeftPointX = _originX - kArrowLength * sin(kDegreesToRadians(30));
    
    CGPoint yAxiaArrowEndRightPoint = CGPointMake(yAxiaArrowEndRightPointX, yAxiaArrowEndPointY);
    [self drawLineStartPoint:yAxiaArrowStartPoint endPoint:yAxiaArrowEndRightPoint];
    
    CGPoint yAxiaArrowEndLeftPoint = CGPointMake(yAxiaArrowEndLeftPointX, yAxiaArrowEndPointY);
    [self drawLineStartPoint:yAxiaArrowStartPoint endPoint:yAxiaArrowEndLeftPoint];
}

// 绘制Y轴虚线
- (void)drawYLines {
    // 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger count = 10; // y轴 10条线 可修改
    CGFloat lineSpace = (_yAxiaH - 20) * 1.0 / count;
    
    for (NSInteger i = 0; i < count; i++) {
        
        CGContextSaveGState(context); // 保存上下文状态
        
        CGContextTranslateCTM(context, _originX, _originY - (i + 1) * lineSpace); // 位移上下文
        
        CGContextScaleCTM(context, 1, 0.5); // 缩放上下文
        
        CGPoint startPoint = CGPointMake(0, 0);
        
        CGPoint endPoint = CGPointMake(_xAxiaW, 0);
        
        [self drawLineStartPoint:startPoint endPoint:endPoint isDash:YES];
        
        CGContextRestoreGState(context); // 恢复状态
    }
}

// 绘制纵轴文字
- (void)drawYAxiaTexts {
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSInteger count = 10;
    for (NSInteger i = 0; i <= count; i++) {
        [mutableArr addObject:[NSString stringWithFormat:@"%zd", i]];
    }
    NSArray *texts = [mutableArr copy]; // 测试文字
    
    CGFloat lineSpace = (_yAxiaH - 20) * 1.0 / count;
    
    CGFloat textW = 20;
    CGFloat textH = 20;
    
    for (NSInteger i = 0; i < texts.count; i++) {
        CGRect textRect = CGRectMake(_originX - textW, _originY - (i) * lineSpace-textH/2, textW, textH);
        NSString *str = [texts objectAtIndex:i];
        [self drawTextWithStr:str textRect:textRect alignment:NSTextAlignmentCenter];
    }
}

// 绘制横轴文字
- (void)drawXAxiaTexts {
    // 测试数据
    NSArray *arr = @[@"00:00", @"06:00", @"12:00", @"18:00", @"24:00"];
    
    CGFloat lineSpace = _xAxiaW * 1.0 / arr.count;
    CGFloat textW = 60;
    CGFloat textH = 20;
    
    for (NSInteger i = 0; i < arr.count; i++) {
        CGRect textRect = CGRectMake(_originX + (i) * lineSpace, _originY, textW, textH);
        NSString *str = [arr objectAtIndex:i];
        [self drawTextWithStr:str textRect:textRect alignment:NSTextAlignmentLeft];
    }
}

// 绘制Y轴单位
- (void)drawUAxiaUnitTexts {
    NSString *unitStr = @"ug/m³";
    CGFloat textW = 40;
    CGFloat textH = 20;
    CGRect textRect = CGRectMake(2, 0, textW, textH);
    [self drawTextWithStr:unitStr textRect:textRect alignment:NSTextAlignmentCenter];
}

/*
 绘制数据线
 */
- (void)drawDatasLine {
    NSInteger count = 60; //x轴点的个数
    if (count < self.dataSources.count) {
        // 删除数组中的第一个数据
        [self.dataSources removeObjectAtIndex:0];
        
        NSArray *dataSourceArr = [self.dataSources copy];
        // 遍历数组中元素 每个元素的x坐标向左移动1个单位
        for (NSInteger i = 0; i < dataSourceArr.count; i++) {
            NSValue *value = dataSourceArr[i];
            CGPoint newPoint = [self leftTransferWithPoint:value.CGPointValue offset:1];
            NSValue *newValue = [NSValue valueWithCGPoint:newPoint];
            [self.dataSources replaceObjectAtIndex:i withObject:newValue];
        }
        // 最后一个新添加进来的元素x坐标移动到60的位置
        NSValue *lastObj = self.dataSources.lastObject;
        CGPoint lastPoint = [self leftTransferWithPoint:lastObj.CGPointValue offset:lastObj.CGPointValue.x-60];
        // 替换最后一个元素
        [self.dataSources replaceObjectAtIndex:self.dataSources.count-1 withObject:[NSValue valueWithCGPoint:lastPoint]];
    }
    
    // 绘制实线
    [self drawSolidLineWithDatas:self.dataSources color:[UIColor yellowColor]];
}

/// 绘制数据点
- (void)drawDataDots {
    for (NSValue *value in self.dataSources) {
        CGPoint point = value.CGPointValue;
        if (point.y > 5.0) {
            [self drawDotsWithPoint:point fillColor:[UIColor redColor]];
        } else {
            [self drawDotsWithPoint:point fillColor:[UIColor greenColor]];
        }
    }
}

// 绘制实线
- (void)drawSolidLineWithDatas:(NSArray *)datas color:(UIColor *)color {
    [self drawLineWithDatas:datas dash:NO color:color];
}

// 绘制虚线
- (void)drawDashLineWithDatas:(NSArray *)datas color:(UIColor *)color {
    [self drawLineWithDatas:datas dash:YES color:color];
}

// 将点转化为坐标系中的点
- (CGPoint)realPointWithPoint:(CGPoint)point {
    // FIXME: 根据需要可适当修改
    CGFloat lineSpace = (_yAxiaH - 20) * 1.0 / 10;
    return CGPointMake(point.x * (_xAxiaW-20) * 1.0 / (6 * 10)  + _originX, _originY - point.y * lineSpace);
}

// 左移动
- (CGPoint)leftTransferWithPoint:(CGPoint)point offset:(CGFloat)offset{
    return CGPointMake(point.x-offset, point.y);
}


// 默认红色小圆点
- (void)drawDotsWithPoint:(CGPoint)point {
    [self drawDotsWithPoint:point fillColor:[UIColor redColor]];
}

// 绘制小圆点
- (void)drawDotsWithPoint:(CGPoint)point fillColor:(UIColor *)color {
    CGPoint realPoint = [self realPointWithPoint:point];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, kDotRadius);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    // 移动context
    CGContextTranslateCTM(context, realPoint.x, realPoint.y);
    
    CGRect rect = CGRectMake(-kDotRadius/2.0, -kDotRadius/2.0, kDotRadius, kDotRadius);
    // 画圆
    CGContextAddEllipseInRect(context, rect);
    
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

#pragma mark - 绘制多点线
- (void)drawLineWithDatas:(NSArray *)datas dash:(BOOL)isDash color:(UIColor *)color {
    
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *preValue = obj;
        if (idx > 0) {
            preValue = datas[idx-1];
        }
        NSValue *nowValue = obj;
        
        CGPoint preRealPoint = [self realPointWithPoint:preValue.CGPointValue];
        CGPoint nowRealPoint = [self realPointWithPoint:nowValue.CGPointValue];
        
        BOOL curveFlag = (isDash && _dashLineType == FHLineChartViewLineTypeCurve) || (!isDash && _solidLineType == FHLineChartViewLineTypeCurve);
        [self drawLineStartPoint:preRealPoint endPoint:nowRealPoint color:color lineWidth:1 isDash:isDash isCurve:curveFlag];
    }];
}

#pragma mark - 绘制文字
- (void)drawTextWithStr:(NSString *)str textRect:(CGRect)textRect alignment:(NSTextAlignment)alignment {
    //// Text Drawing
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle alloc] init];
    
    textStyle.alignment = alignment;
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 13], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
    
    CGFloat textTextHeight = [str boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY) options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
    
    CGContextSaveGState(context);
    
    CGContextClipToRect(context, textRect);
    // 画文字
    [str drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (textRect.size.height - textTextHeight) / 2, textRect.size.width, textTextHeight) withAttributes: textFontAttributes];
    
    CGContextRestoreGState(context);
}

#pragma mark - 绘制坐标线 起点和终点
- (void)drawLineStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    [self drawLineStartPoint:start endPoint:end isDash:NO];
}

- (void)drawLineStartPoint:(CGPoint)start endPoint:(CGPoint)end isDash:(BOOL)isDash{
    [self drawLineStartPoint:start endPoint:end color:UIColor.blackColor lineWidth:1 isDash:isDash isCurve:NO];
}

- (void)drawLineStartPoint:(CGPoint)start endPoint:(CGPoint)end color:(UIColor *)color lineWidth:(CGFloat)width isDash:(BOOL)isDash isCurve:(BOOL)isCurve {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:start];
    
    if (isCurve) { // 曲线
        CGPoint cp1 = CGPointMake((start.x+end.x)/2, start.y); // 控制点1
        CGPoint cp2 = CGPointMake((start.x+end.x)/2, end.y); // 控制点2
        [bezierPath addCurveToPoint:end controlPoint1:cp1 controlPoint2:cp2];
    } else {
        [bezierPath addLineToPoint:end];
    }
    
    [color setStroke];
    
    if (isDash) { // 是虚线
        CGFloat lengths[] = {1, 1};
        // pattern: c类型线性数据
        // count: pattern中数据个数
        // phase: 起始位置
        [bezierPath setLineDash:lengths count:2 phase:0];
    }
    bezierPath.lineWidth = width;
    
    [bezierPath stroke];
}


@end
