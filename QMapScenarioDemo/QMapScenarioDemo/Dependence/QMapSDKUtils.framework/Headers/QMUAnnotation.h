//
//  QMUAnnotation.h
//  QMapKitDemo
//
//  Created by fan lifei on 16/8/26.
//  Copyright © 2016年 TENCENT. All rights reserved.
//

#import <QMapKit/QAnnotation.h>
#import "QMUGeometry.h"
#import <QMapKit/QGeometry.h>
#import "QMUPointItem.h"

/** @class QMUAnnotation 可被聚合的原始点数据
 */
@interface QMUAnnotation : NSObject<QAnnotation, QMUPointItem, NSCopying>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy ) NSString* title;
@property (nonatomic, copy ) NSString* subtitle;

/// 本值代表其位置，被用于参与聚合运算。默认为墨卡托坐标
@property (nonatomic, readonly) QMUPoint point;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

/// 当子类有新添加字段时，子类有可能需要重载来帮助判断是不是同一个点
- (NSUInteger)hash;
/// 当子类有新添加字段时，子类有可能需要重载来帮助判断是不是同一个点
- (BOOL)isEqual:(id)object;

@end
