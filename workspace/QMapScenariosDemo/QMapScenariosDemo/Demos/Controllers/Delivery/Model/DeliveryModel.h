//
//  DeliveryModel.h
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/6/22.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryModel : NSObject

@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) BOOL firstStep;

@end

NS_ASSUME_NONNULL_END
