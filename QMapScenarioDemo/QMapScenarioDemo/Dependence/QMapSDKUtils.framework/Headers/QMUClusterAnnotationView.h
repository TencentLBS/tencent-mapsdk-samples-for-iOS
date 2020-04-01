//
//  QMUClusterAnnotationView.h
//  QMapKitDemo
//
//  Created by fan on 16/8/26.
//  Copyright © 2016年 TENCENT. All rights reserved.
//

#import <QMapKit/QAnnotationView.h>
#import "QMUClusterAnnotation.h"

/** @class QMUClusterAnnotationView 预定义的聚合点样式view
 *
 * 聚合点样式类。一般与QMUClusterAnnotation配套使用
 * 包含View本身，一个背景图片，一个显示文字，可修改显示效果后直接使用
 */
@interface QMUClusterAnnotationView : QAnnotationView

/// 背景图片
@property (nonatomic, strong) UIImageView*  background;
/// 显示的文字
@property (nonatomic, strong) UILabel*      displayText;

/// 创建实例，同父类的方法
- (id)initWithAnnotation:(id <QAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
