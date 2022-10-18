//
//  GeofencingController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/13.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "GeofencingController.h"

@interface GeofencingController ()
// 地理围栏Polygon
@property (nonatomic, strong) QPolygon *polygon;
@property (nonatomic, strong) UILabel *label;
@end

@implementation GeofencingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.040258, 116.273406)];
    [self.mapView setZoomLevel:17];
    
    CLLocationCoordinate2D locations[4];
    locations[0] = CLLocationCoordinate2DMake(40.041408, 116.271614);
    locations[1] = CLLocationCoordinate2DMake(40.041868, 116.274479);
    locations[2] = CLLocationCoordinate2DMake(40.038928, 116.275187);
    locations[3] = CLLocationCoordinate2DMake(40.0385, 116.272151);
    
    _polygon = [[QPolygon alloc] initWithWithCoordinates:locations count:4];
    [self.mapView addOverlay:_polygon];
    
    QPointAnnotation *point = [[QPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(40.040258, 116.273406);
    [self.mapView addAnnotation:point];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"长按大头针拖动进出地理围栏区域";
    [self.mapView addSubview:_label];
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay {
    QPolygonView *polygonView = [[QPolygonView alloc] initWithPolygon:overlay];
    polygonView.strokeColor = [UIColor redColor];
    polygonView.lineWidth = 5;
    
    return polygonView;
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    static NSString *pointIdentifier = @"PointIdentifier";
    QPinAnnotationView *pinView = (QPinAnnotationView *)([mapView dequeueReusableAnnotationViewWithIdentifier:pointIdentifier]);
    if (pinView == nil) {
        pinView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointIdentifier];
        pinView.draggable = YES;
    }
    
    return pinView;
}

- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view didChangeDragState:(QAnnotationViewDragState)newState fromOldState:(QAnnotationViewDragState)oldState {
    
    // 取出当前annotation的坐标点
    CLLocationCoordinate2D currentLocation = view.annotation.coordinate;
    // 将坐标转为QMapPoint
    QMapPoint currentPoint = QMapPointForCoordinate(currentLocation);
    
    // 判断点是否进入了围栏区域
    BOOL isWalkIn = QPolygonContainsPoint(currentPoint, _polygon.points, 4);
    
    if (isWalkIn) {
        _label.text = @"进入地理围栏区域";
    } else {
        _label.text = @"离开地理围栏";
    }
}


@end
