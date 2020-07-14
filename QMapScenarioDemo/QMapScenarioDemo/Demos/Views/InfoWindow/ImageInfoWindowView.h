//
//  CarInfoWindowView.h
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/22.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageInfoWindowView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *image;

- (void)presentInfoWindowInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
