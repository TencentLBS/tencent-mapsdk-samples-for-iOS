//
//  QMUClusterAnnotation.h
//  QMapKitDemo
//
//  Created by fan on 16/8/26.
//  Copyright © 2016年 TENCENT. All rights reserved.
//

#import "QMUAnnotation.h"

/** @class QMUClusterAnnotation 本类代表了经过聚合计算后的单个聚合点数据
 *
 * 包含了当前范围的所有原始点。有可能有多个原始点，也有可能只有一个
 */
@interface QMUClusterAnnotation : QMUAnnotation

/// 该聚合点包含的原始点个数
@property (nonatomic, readonly) NSUInteger   count;
/// 该聚合点包含的所有原始点
@property (nonatomic, strong) NSMutableSet* items;

@end
