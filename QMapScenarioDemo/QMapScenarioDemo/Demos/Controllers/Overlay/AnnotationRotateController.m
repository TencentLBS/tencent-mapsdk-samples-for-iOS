//
//  AnnotationRotateController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "AnnotationRotateController.h"

@interface AnnotationRotateController ()
@property (nonatomic, strong) QPointAnnotation *carAnnotation;
@property (nonatomic, strong) QPointAnnotation *bjAnnotation;
@property (nonatomic, strong) QPinAnnotationView *carAnnotationView;
@property (nonatomic, assign) NSUInteger index;
@end

@implementation AnnotationRotateController

- (NSString *)testTitle {
    return @"小车角度";
}

- (void)handleTestAction {
    _index++;
    
    if (_index == self.mapView.annotations.count - 2) {
        _index = 0;
    }
    
    QPointAnnotation *annotation = self.mapView.annotations[_index];
    
    _carAnnotation.coordinate = annotation.coordinate;
    
    [self annotationRotate];
}

- (void)annotationRotate {
    // 取出终点坐标位置
    CLLocationCoordinate2D toCoord = _bjAnnotation.coordinate;
    
    double fromLat = _carAnnotation.coordinate.latitude;
    double fromlon = _carAnnotation.coordinate.longitude;
    double toLat = toCoord.latitude;
    double tolon = toCoord.longitude;

    double slope = ((toLat - fromLat) / (tolon - fromlon));
    
    double radio = atan(slope);
    double angle = 180 * (radio / M_PI);
    if (slope > 0) {
        if (tolon < fromlon) {
            angle = -90 - angle;
        } else {
            angle = 90 - angle;
        }
    } else if (slope == 0) {
        if (tolon < fromlon) {
            angle = -90;
        } else {
            angle = 90;
        }
    } else {
        if (toLat < fromLat) {
            angle = 90 - angle;
        } else {
            angle = -90 - angle;
        }
    }
    
    _carAnnotationView.transform = CGAffineTransformMakeRotation((M_PI * (angle) / 180.0));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 0;
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(31.649301, 110.623529)];
    [self.mapView setZoomLevel:4.77];
    
    [self setupAnnotation];
    
    [self annotationRotate];
}

- (void)setupAnnotation {
    
    CLLocationCoordinate2D locations[7];
    
    // 福州
    locations[0] = CLLocationCoordinate2DMake(26.101797,119.415539);
    // 西安
    locations[1] = CLLocationCoordinate2DMake(34.475422,109.0005);
    // 西宁
    locations[2] = CLLocationCoordinate2DMake(36.69099,101.749523);
    // 济南
    locations[3] = CLLocationCoordinate2DMake(36.761434,117.174328);
    // 太原
    locations[4] = CLLocationCoordinate2DMake(37.949064,112.56007);
    // 天津
    locations[5] = CLLocationCoordinate2DMake(39.117802,117.174328);
    // 北京
    locations[6] = CLLocationCoordinate2DMake(39.897614,116.383312);
    
    // 福州
    QPointAnnotation *nnAnnotation = [[QPointAnnotation alloc] init];
    nnAnnotation.coordinate = locations[0];
    [self.mapView addAnnotation:nnAnnotation];
    
    // 西安
    QPointAnnotation *gzAnnotation = [[QPointAnnotation alloc] init];
    gzAnnotation.coordinate = locations[1];
    [self.mapView addAnnotation:gzAnnotation];
    
    // 西宁
    QPointAnnotation *ncAnnotation = [[QPointAnnotation alloc] init];
    ncAnnotation.coordinate = locations[2];
    [self.mapView addAnnotation:ncAnnotation];
    
    // 济南
    QPointAnnotation *hfAnnotation = [[QPointAnnotation alloc] init];
    hfAnnotation.coordinate = locations[3];
    [self.mapView addAnnotation:hfAnnotation];
    
    // 太原
    QPointAnnotation *jnAnnotation = [[QPointAnnotation alloc] init];
    jnAnnotation.coordinate = locations[4];
    [self.mapView addAnnotation:jnAnnotation];
    
    // 天津
    QPointAnnotation *tjAnnotation = [[QPointAnnotation alloc] init];
    tjAnnotation.coordinate = locations[5];
    [self.mapView addAnnotation:tjAnnotation];
    
    // 北京
    QPointAnnotation *bjAnnotation = [[QPointAnnotation alloc] init];
    bjAnnotation.coordinate = locations[6];
    [self.mapView addAnnotation:bjAnnotation];
    _bjAnnotation = bjAnnotation;
    
    // 卡车
    _carAnnotation = [[QPointAnnotation alloc] init];
    _carAnnotation.coordinate = locations[0];
    _carAnnotation.userData = @"car";
    [self.mapView addAnnotation:_carAnnotation];
    
    QPolyline *polyline = [[QPolyline alloc] initWithCoordinates:locations count:7];
    [self.mapView addOverlay:polyline];
}

    - (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
        static NSString *reuse = @"annotation";
        static NSString *reuseCar = @"annotationCar";
        QPinAnnotationView *annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuse];
        if (annotationView == nil) {
            if (annotation == _carAnnotation) {
                annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseCar];
                annotationView.image = [UIImage imageNamed:@"car"];
                _carAnnotationView = annotationView;
            } else {
                annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuse];
            }
        }
        
        return annotationView;
    }

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay {
    if ([overlay isKindOfClass:[QPolyline class]]) {
        QPolylineView *polylineView = [[QPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 5;
        polylineView.strokeColor = [UIColor redColor];
        
        return polylineView;
    }
    
    return nil;
}

- (void)mapViewRegionChange:(QMapView *)mapView {
    NSLog(@"%f %f, zoom = %f", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude, self.mapView.zoomLevel);
}

@end
