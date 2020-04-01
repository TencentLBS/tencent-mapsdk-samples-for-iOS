//
//  QMUClusterManager.h
//  QMapKitDemo
//
//  Created by fan on 16/8/26.
//  Copyright © 2016年 TENCENT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMUClusterAnnotationView.h"
#import <QMapKit/QMapKit.h>

/// @class QMUClusterProtocol 用于配置自定义的聚合效果
@protocol QMUClusterProtocol <NSObject>

@optional
/// 决定特定的2个点是否需要被聚合,只有当返回YES且符合距离时才会被聚合，如果不实现则任意两原始点都被聚合
- (BOOL)clusterAnnotation:(QMUAnnotation* )anno1 withAnnotation:(QMUAnnotation*)anno2;

@end

/** @class QMUClusterManager 聚合点管理类
 *
 * 本类为聚合点功能的入口，通过此类的实例来配置聚合功能，和管理数据
 */
@interface QMUClusterManager : NSObject

/// 聚合的范围。单位为屏幕坐标
@property (nonatomic, assign) CGFloat               distance;
/// 代理类，实现其方法可用于自定义聚合的效果
@property (nonatomic, weak) id<QMUClusterProtocol>  delegate;
/// map实例
@property (nonatomic, weak) QMapView*               map;
/**
 * 当zoomLevel>thresholdZoomlevel时为只计算屏幕附近的聚合点, <=thresholdZoomlevel时计算所有的聚合点.
 * 可根据数据分布设置为适合的值. 如果设置为>18或<4值时, 则只会采用一种策略。
 * 默认为7
 */
@property (nonatomic, assign) int       thresholdZoomlevel;

/// 创建一个实例.
- (instancetype)initWithMap:(QMapView*)map;

/// 添加原始被聚合点
- (void)addAnnotaion:(QMUAnnotation*)anno;
/// 添加批量的原始被聚合点
- (void)addAnnotations:(NSArray*)annos;
/// 移除原始被聚合点
- (void)removeAnnotaion:(QMUAnnotation*)anno;
/// 移除批量的原始被聚合点
- (void)removeAnnotations:(NSArray*)annos;
/// 移除所有的原始被聚合点
- (void)clearAnnotations;

/** @brief
 * 当你想强制重新聚合时调用。地图产生变化后需调用刷新聚合点状态
 * 如 mapView: regionDidChangeAnimated: gesture: 等地图区域状态回调接口
 * (当仅改配置如distance, threeholdZoomlevel时会需要)
 */
- (void)refreshCluster;

@end
