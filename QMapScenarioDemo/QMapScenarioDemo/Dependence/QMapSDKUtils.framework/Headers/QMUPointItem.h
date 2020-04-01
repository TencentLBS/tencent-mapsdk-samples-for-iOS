//
//  QMUPointItem.h
//  QMapKitDemo
//
//  Created by fan lifei on 16/8/26.
//  Copyright © 2016年 TENCENT. All rights reserved.
//

#import "QMUGeometry.h"

/// 代表一种可被聚合的拥有位置属性的通用类型
@protocol QMUPointItem <NSObject>

/// 本值代表其位置，被用于计算距离参与聚合运算。
@property (nonatomic, readonly) QMUPoint point;

@end
