//
//  FHLineChartView.h
//  FHLineChartDemo
//
//  Created by TK on 2018/3/23.
//  Copyright © 2018年 Hesvit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FHLineChartViewLineType) {
    FHLineChartViewLineTypeNormal, // 普通折线
    FHLineChartViewLineTypeCurve, // 曲线
};

@interface FHLineChartView : UIView

/// 虚线类型 直线或曲线
@property (nonatomic, assign) FHLineChartViewLineType dashLineType;

/// 实线类型 直线或曲线
@property (nonatomic, assign) FHLineChartViewLineType solidLineType;

@property (nonatomic, strong) NSMutableArray *dataSources;

@end
