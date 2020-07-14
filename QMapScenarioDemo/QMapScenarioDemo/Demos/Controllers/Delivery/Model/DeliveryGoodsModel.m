//
//  DeliveryGoodsModel.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/6/22.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "DeliveryGoodsModel.h"

@implementation DeliveryGoodsModel

- (instancetype)init {
    if (self = [super init]) {
        _title = @"腾讯商品";
        _imageName = @"goods";
        _price = @"200￥";
    }
    
    return self;
}

@end
