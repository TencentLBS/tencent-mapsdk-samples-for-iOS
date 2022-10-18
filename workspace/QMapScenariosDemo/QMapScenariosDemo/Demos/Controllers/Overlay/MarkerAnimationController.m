//
//  MarkerAnnotationController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/12.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "MarkerAnimationController.h"

@interface MarkerAnimationController ()
@property (nonatomic, strong) QPointAnnotation *annotation;
@property (nonatomic, strong) QPinAnnotationView *pinView;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UILabel *hintLabel;
@end

@implementation MarkerAnimationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isAnimating = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上浮动画" style:UIBarButtonItemStyleDone target:self action:@selector(startAnimation)];

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.040219,116.273348)];
    [self.mapView setZoomLevel:15.0];
    
    [self setupPointAnnotation];
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width, 44)];
    _hintLabel.text = @"移动地图展示跳动动画\n右上角按钮展示上浮动画";
    _hintLabel.numberOfLines = 0;
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.mapView addSubview:_hintLabel];
}

- (void)setupPointAnnotation {
    _annotation = [[QPointAnnotation alloc] init];
    _annotation.coordinate = CLLocationCoordinate2DMake(40.040219,116.273348);
    
    [self.mapView addAnnotation:_annotation];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *pinIndentifier = @"PinIndentifier";
        _pinView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinIndentifier];
        if (_pinView == nil) {
            _pinView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIndentifier];
            _pinView.image = [UIImage imageNamed:@"redPin"];
        }
        
        return _pinView;
    }
    
    return nil;
}

- (void)mapViewRegionChange:(QMapView *)mapView {
    // 更新位置
    _annotation.coordinate = mapView.centerCoordinate;
}

// 跳动动画
- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture {
    if (bGesture) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.pinView.transform = CGAffineTransformMakeTranslation(weakSelf.pinView.transform.tx, weakSelf.pinView.transform.ty - 15);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.pinView.transform = CGAffineTransformMakeTranslation(weakSelf.pinView.transform.tx, weakSelf.pinView.transform.ty + 15);
            }];
        }];
    }
}

// 上浮动画
- (void)startAnimation {
    _isAnimating = !_isAnimating;
    
    if (_isAnimating) {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat: 0.6];
        rotationAnimation.toValue   = [NSNumber numberWithFloat: 1];
        rotationAnimation.duration = 2;
        rotationAnimation.autoreverses = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        
        [_pinView.layer addAnimation:rotationAnimation forKey:@"scaleAnimation"];
    } else {
        [_pinView.layer removeAllAnimations];
    }
    
    [self.mapView selectAnnotation:_annotation animated:YES];
}


@end
