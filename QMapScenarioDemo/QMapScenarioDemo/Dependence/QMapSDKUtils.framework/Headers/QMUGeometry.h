//
//  QMUGeometry.h
//  QMapKitDemo
//
//  Created by fan lifei on 16/8/26.
//  Copyright © 2016年 TENCENT. All rights reserved.
//

#import <UIKit/UIKit.h>

/// @file QMUGeometry.h 提供一类基础类型供其它使用

/// 坐标点
typedef struct {
    double x;   ///< x坐标.
    double y;   ///< y坐标.
} QMUPoint;

/// 一个矩形区域
typedef struct {
    double  minX;
    double  minY;
    double  maxX;
    double  maxY;
} QMUBounds;

/// 创建一个点
QMUPoint QMUMakePoint(double x1, double y1);
/// 创建区域. x1,y1代表左上点(小点), x2,y2代表右下点(对角的大点)
QMUBounds QMUMakeBounds(double x1, double y1, double x2, double y2);
/// 判断是rect否包含point
BOOL QMUBoundsContainsPoint(QMUBounds rect, QMUPoint point);
/// 判断r1是否与r2相交
BOOL QMUBoundsIntersectsBounds(QMUBounds r1, QMUBounds r2);
/// 判断rect1是否完全包含rect2
BOOL QMUBoundsContainsBounds(QMUBounds rect1, QMUBounds rect2);
/// 获取矩形的x中点
double QMUBoundsGetMidX(QMUBounds r1);
/// 获取矩形的y中点
double QMUBoundsGetMidY(QMUBounds r1);