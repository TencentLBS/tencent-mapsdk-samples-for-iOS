//
//  LocationCircleController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/13.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "LocationCircleController.h"
#import "CircleAnnotationView.h"

@interface LocationCircleController ()
// 定位点标记
@property (nonatomic, strong) QPointAnnotation *userLocationAnnotation;
@property (nonatomic, strong) QPinAnnotationView *userLocationAnnotationView;
// 圆圈点标记
@property (nonatomic, strong) QPointAnnotation *circleAnnotation;
@property (nonatomic, strong) CircleAnnotationView *circleAnnotationView;
@end

@implementation LocationCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QUserLocationPresentation *presentation = [[QUserLocationPresentation alloc] init];
    presentation.circleFillColor = [UIColor clearColor];
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserLocationHidden:YES];
}

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation fromHeading:(BOOL)fromHeading {
    if (_userLocationAnnotation == nil) {
        _userLocationAnnotation = [[QPointAnnotation alloc] init];
        _circleAnnotation = [[QPointAnnotation alloc] init];
        
        [self.mapView addAnnotation:_circleAnnotation];
        [self.mapView addAnnotation:_userLocationAnnotation];
        
        [self.mapView setCenterCoordinate:userLocation.location.coordinate];
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.userLocationAnnotation.coordinate = userLocation.location.coordinate;
        weakSelf.circleAnnotation.coordinate = userLocation.location.coordinate;
    }];
    
    // 更新转向
    if (weakSelf.userLocationAnnotationView) {
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(M_PI * (userLocation.heading.trueHeading) / 180.0);
        }];
    }
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    
    static NSString *circleAnnotationIdentifier = @"circleAnnotationIdentifier";
    if (annotation == _circleAnnotation) {
        _circleAnnotationView = (CircleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:circleAnnotationIdentifier];
        
        if (_circleAnnotationView == nil) {
            _circleAnnotationView = [[CircleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:circleAnnotationIdentifier];
            
            _circleAnnotationView.frame = CGRectMake(0, 0, 100, 100);
            _circleAnnotationView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.4];
            _circleAnnotationView.layer.cornerRadius = 50;
            _circleAnnotationView.clipsToBounds = YES;
            
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = @0;
            scaleAnimation.toValue = @1;
            scaleAnimation.beginTime = CACurrentMediaTime();
            scaleAnimation.duration = 3;
            scaleAnimation.repeatCount = MAXFLOAT;// 重复次数设置为无限
            
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.fromValue = @1;
            opacityAnimation.toValue = @0;
            opacityAnimation.beginTime = CACurrentMediaTime();
            opacityAnimation.duration = 3;
            opacityAnimation.repeatCount = MAXFLOAT;// 重复次数设置为无限
            
            [_circleAnnotationView.layer addAnimation:scaleAnimation forKey:@"circle"];
            [_circleAnnotationView.layer addAnimation:opacityAnimation forKey:@"circleOpacity"];
        }
        return _circleAnnotationView;
    }
    
    static NSString *userLocationAnnotationIdentifier = @"userLocationAnnotationIdentifier";
    if (annotation == _userLocationAnnotation) {
        _userLocationAnnotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationAnnotationIdentifier];
        if (_userLocationAnnotationView == nil) {
            _userLocationAnnotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationAnnotationIdentifier];
            _userLocationAnnotationView.image = [UIImage imageNamed:@"custom_location"];
        }
        
        return _userLocationAnnotationView;
    }

    return nil;
}

@end
